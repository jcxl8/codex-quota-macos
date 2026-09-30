import AppKit

struct WindowLimit {
    let remaining: Int
    let reset: Date?
    init?(_ raw: Any?) {
        guard let d = raw as? [String: Any], let used = d["usedPercent"] as? Double, used.isFinite else { return nil }
        remaining = Int(max(0, min(100, 100 - used)).rounded())
        reset = (d["resetsAt"] as? Double).map { Date(timeIntervalSince1970: $0) }
    }
    var icon: String { remaining <= 10 ? "🔴" : remaining <= 30 ? "🟡" : "🟢" }
    var tint: NSColor { remaining <= 10 ? .systemRed : remaining <= 30 ? .systemOrange : .systemGreen }
}

final class QuotaMeterView: NSStackView {
    let nameLabel = NSTextField(labelWithString: "")
    let percentLabel = NSTextField(labelWithString: "—")
    let progress = NSProgressIndicator()
    let recoveryLabel = NSTextField(labelWithString: "下次恢复时间未知")

    init(title: String) {
        super.init(frame: .zero)
        orientation = .vertical
        alignment = .leading
        spacing = 4
        translatesAutoresizingMaskIntoConstraints = false

        nameLabel.stringValue = title
        nameLabel.font = .systemFont(ofSize: 13, weight: .medium)
        nameLabel.textColor = .secondaryLabelColor
        percentLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        percentLabel.alignment = .right

        let heading = NSStackView(views: [nameLabel, NSView(), percentLabel])
        heading.orientation = .horizontal
        heading.alignment = .centerY
        heading.translatesAutoresizingMaskIntoConstraints = false

        progress.style = .bar
        progress.isIndeterminate = false
        progress.minValue = 0
        progress.maxValue = 100
        progress.controlSize = .small
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.heightAnchor.constraint(equalToConstant: 5).isActive = true
        progress.setAccessibilityLabel("\(title)剩余比例")

        recoveryLabel.font = .systemFont(ofSize: 11)
        recoveryLabel.textColor = .secondaryLabelColor

        addArrangedSubview(heading)
        addArrangedSubview(progress)
        addArrangedSubview(recoveryLabel)
        heading.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        progress.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        widthAnchor.constraint(greaterThanOrEqualToConstant: 280).isActive = true
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func update(_ limit: WindowLimit?, dateText: (Date?) -> String) {
        guard let limit else {
            percentLabel.stringValue = "—"
            percentLabel.textColor = .tertiaryLabelColor
            progress.doubleValue = 0
            recoveryLabel.stringValue = "下次恢复时间未知"
            return
        }
        percentLabel.stringValue = "\(limit.remaining)%"
        percentLabel.textColor = limit.tint
        progress.doubleValue = Double(limit.remaining)
        recoveryLabel.stringValue = "下次恢复  \(dateText(limit.reset))"
    }
}

final class App: NSObject, NSApplicationDelegate, NSWindowDelegate {
    var item: NSStatusItem!
    var panel: NSPanel!
    var rootStack: NSStackView!
    var primaryMeter: QuotaMeterView!
    var secondaryMeter: QuotaMeterView!
    var resetCount: NSTextField!
    var updatedLabel: NSTextField!
    var scheduleLabel: NSTextField!
    var scheduleIcon: NSImageView!
    var refreshButton: NSButton!
    var process: Process?
    var input: FileHandle?
    var buffer = Data()
    var primary: WindowLimit?
    var secondary: WindowLimit?
    var resets: Int?
    var updated: Date?
    var error: String?
    var ready = false
    var pending = false
    var serial = 10
    var requestID: Int?
    var timer: Timer?
    var deadline: Timer?

    func applicationDidFinishLaunching(_ notification: Notification) {
        item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        item.button?.setAccessibilityLabel("Codex 额度")
        panel = NSPanel(contentRect: NSRect(x: 0, y: 0, width: 360, height: 300), styleMask: [.titled, .closable, .utilityWindow], backing: .buffered, defer: false)
        panel.title = "Codex 额度"
        panel.delegate = self
        panel.setFrameAutosaveName("CodexQuotaPanelV2")
        panel.level = .floating
        panel.isFloatingPanel = true
        panel.hidesOnDeactivate = false
        panel.isReleasedWhenClosed = false
        panel.isMovableByWindowBackground = true
        panel.setContentSize(NSSize(width: 360, height: 285))
        panel.center()
        buildPanelContents()
        render()
        start()
        if CommandLine.arguments.contains("--show-panel") { togglePanel() }
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in self?.refresh() }
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(refresh), name: NSWorkspace.didWakeNotification, object: nil)
    }
    func start() {
        buffer.removeAll(); requestID = nil; ready = false
        let paths = ["/Applications/ChatGPT.app/Contents/Resources/codex-cli/bin/codex", FileManager.default.homeDirectoryForCurrentUser.path + "/.local/bin/codex", "/opt/homebrew/bin/codex", "/usr/local/bin/codex"]
        guard let path = paths.first(where: { FileManager.default.isExecutableFile(atPath: $0) }) else {
            error = "未找到 Codex CLI。请安装并运行 codex login。"; render(); return
        }
        let p = Process(), stdinPipe = Pipe(), stdoutPipe = Pipe()
        p.executableURL = URL(fileURLWithPath: path)
        p.arguments = ["app-server", "--listen", "stdio://"]
        p.standardInput = stdinPipe; p.standardOutput = stdoutPipe
        p.standardError = FileHandle.nullDevice
        input = stdinPipe.fileHandleForWriting
        stdoutPipe.fileHandleForReading.readabilityHandler = { [weak self] handle in
            let data = handle.availableData
            DispatchQueue.main.async { self?.receive(data) }
        }
        p.terminationHandler = { [weak self, weak p] _ in
            DispatchQueue.main.async {
                guard let self = self, self.process === p else { return }
                self.deadline?.invalidate(); self.buffer.removeAll(); self.requestID = nil
                self.input = nil; self.process = nil; self.pending = false; self.ready = false
                self.error = "额度连接已断开；点击刷新重试。"; self.render()
            }
        }
        do {
            try p.run(); process = p
            send(["id": 1, "method": "initialize", "params": ["clientInfo": ["name": "codex_quota", "title": "Codex Quota", "version": "1.0.0"], "capabilities": ["experimentalApi": true, "requestAttestation": false]]])
            armTimeout()
        } catch { self.error = "无法启动 Codex CLI。"; render() }
    }
    func send(_ object: [String: Any]) {
        guard let bytes = try? JSONSerialization.data(withJSONObject: object) else { return }
        do { try input?.write(contentsOf: bytes + Data([10])) }
        catch { self.error = "无法向 Codex 发送请求。"; pending = false; render() }
    }
    func armTimeout() {
        deadline?.invalidate()
        deadline = Timer.scheduledTimer(withTimeInterval: 20, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            self.pending = false; self.ready = false; self.error = "读取超时；显示值可能已过期。"; self.render(); self.process?.terminate()
        }
    }
    func receive(_ data: Data) {
        buffer.append(data)
        while let end = buffer.firstIndex(of: 10) {
            let line = buffer.prefix(upTo: end); buffer.removeSubrange(...end)
            guard let json = try? JSONSerialization.jsonObject(with: line) as? [String: Any] else { continue }
            if json["id"] as? Int == 1 {
                deadline?.invalidate()
                if json["error"] != nil { error = "初始化失败，请更新 Codex CLI。"; render(); process?.terminate(); continue }
                send(["method": "initialized"]); ready = true; refresh()
            } else if let id = json["id"] as? Int, id == requestID {
                deadline?.invalidate(); pending = false
                guard let result = json["result"] as? [String: Any] else {
                    error = "读取失败，请确认 Codex CLI 已登录 ChatGPT。"; render(); continue
                }
                apply(result)
            } else if json["method"] as? String == "account/rateLimits/updated" {
                refresh()
            }
        }
    }
    func apply(_ result: [String: Any]) {
        let all = result["rateLimitsByLimitId"] as? [String: Any]
        let limits = (all?["codex"] as? [String: Any]) ?? (result["rateLimits"] as? [String: Any]) ?? [:]
        primary = WindowLimit(limits["primary"]); secondary = WindowLimit(limits["secondary"])
        resets = (result["rateLimitResetCredits"] as? [String: Any])?["availableCount"] as? Int
        updated = Date()
        error = primary == nil && secondary == nil ? "未返回额度；API 密钥账户可能不支持。" : nil
        render()
    }
    @objc func refresh() {
        if process == nil { start(); return }
        guard ready, !pending else { return }
        pending = true; serial += 1; requestID = serial
        send(["id": serial, "method": "account/rateLimits/read", "params": [:]])
        armTimeout()
    }
    func dateText(_ date: Date?) -> String {
        guard let date = date else { return "未知" }
        let formatter = DateFormatter(); formatter.locale = Locale(identifier: "zh_TW")
        formatter.dateFormat = "MM/dd HH:mm"; return formatter.string(from: date)
    }
    func buildPanelContents() {
        guard let content = panel.contentView else { return }
        let background = NSVisualEffectView()
        background.material = .popover
        background.blendingMode = .withinWindow
        background.state = .active
        background.translatesAutoresizingMaskIntoConstraints = false
        content.addSubview(background)
        NSLayoutConstraint.activate([
            background.leadingAnchor.constraint(equalTo: content.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: content.trailingAnchor),
            background.topAnchor.constraint(equalTo: content.topAnchor),
            background.bottomAnchor.constraint(equalTo: content.bottomAnchor)
        ])

        rootStack = NSStackView()
        rootStack.orientation = .vertical
        rootStack.alignment = .leading
        rootStack.spacing = 8
        rootStack.translatesAutoresizingMaskIntoConstraints = false
        background.addSubview(rootStack)
        NSLayoutConstraint.activate([
            rootStack.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 20),
            rootStack.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -20),
            rootStack.topAnchor.constraint(equalTo: background.topAnchor, constant: 15),
            rootStack.bottomAnchor.constraint(lessThanOrEqualTo: background.bottomAnchor, constant: -15)
        ])

        let heading = NSStackView()
        heading.orientation = .horizontal
        heading.alignment = .centerY
        heading.spacing = 6
        let title = NSTextField(labelWithString: "额度概览")
        title.font = .systemFont(ofSize: 17, weight: .semibold)
        scheduleIcon = NSImageView(image: NSImage(systemSymbolName: "arrow.clockwise", accessibilityDescription: "自动刷新")!)
        scheduleIcon.symbolConfiguration = NSImage.SymbolConfiguration(pointSize: 11, weight: .medium)
        let spacer = NSView()
        scheduleLabel = NSTextField(labelWithString: "每分钟更新")
        scheduleLabel.font = .systemFont(ofSize: 11)
        scheduleLabel.textColor = .secondaryLabelColor
        heading.addArrangedSubview(title)
        heading.addArrangedSubview(spacer)
        heading.addArrangedSubview(scheduleIcon)
        heading.addArrangedSubview(scheduleLabel)
        rootStack.addArrangedSubview(heading)

        primaryMeter = QuotaMeterView(title: "5 小时额度")
        secondaryMeter = QuotaMeterView(title: "每周额度")
        rootStack.addArrangedSubview(primaryMeter)
        rootStack.addArrangedSubview(secondaryMeter)

        let divider = NSBox()
        divider.boxType = .separator
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        rootStack.addArrangedSubview(divider)
        divider.widthAnchor.constraint(equalTo: rootStack.widthAnchor).isActive = true

        let resetRow = NSStackView()
        resetRow.orientation = .horizontal
        resetRow.alignment = .centerY
        resetRow.spacing = 8
        let resetIcon = NSImageView(image: NSImage(systemSymbolName: "arrow.clockwise.circle.fill", accessibilityDescription: "可用重置")!)
        resetIcon.symbolConfiguration = NSImage.SymbolConfiguration(pointSize: 16, weight: .medium)
        resetIcon.contentTintColor = .controlAccentColor
        let resetTitle = NSTextField(labelWithString: "可用重置次数")
        resetTitle.font = .systemFont(ofSize: 13, weight: .medium)
        let resetSpacer = NSView()
        resetCount = NSTextField(labelWithString: "— 次")
        resetCount.font = .systemFont(ofSize: 13, weight: .semibold)
        resetCount.alignment = .center
        resetCount.textColor = .controlAccentColor
        resetCount.wantsLayer = true
        resetCount.layer?.backgroundColor = NSColor.controlAccentColor.withAlphaComponent(0.12).cgColor
        resetCount.layer?.cornerRadius = 8
        resetRow.addArrangedSubview(resetIcon)
        resetRow.addArrangedSubview(resetTitle)
        resetRow.addArrangedSubview(resetSpacer)
        resetRow.addArrangedSubview(resetCount)
        rootStack.addArrangedSubview(resetRow)

        updatedLabel = NSTextField(labelWithString: "正在读取额度…")
        updatedLabel.font = .systemFont(ofSize: 11)
        updatedLabel.textColor = .secondaryLabelColor
        rootStack.addArrangedSubview(updatedLabel)

        refreshButton = NSButton(title: "立即刷新", target: self, action: #selector(refresh))
        refreshButton.image = NSImage(systemSymbolName: "arrow.clockwise", accessibilityDescription: "立即刷新")
        refreshButton.imagePosition = .imageLeading
        refreshButton.bezelStyle = .regularSquare
        refreshButton.isBordered = false
        refreshButton.controlSize = .large
        refreshButton.wantsLayer = true
        refreshButton.layer?.backgroundColor = NSColor.controlAccentColor.cgColor
        refreshButton.layer?.cornerRadius = 10
        refreshButton.contentTintColor = .white
        refreshButton.attributedTitle = NSAttributedString(string: "立即刷新", attributes: [.foregroundColor: NSColor.white, .font: NSFont.systemFont(ofSize: 14, weight: .semibold)])
        rootStack.addArrangedSubview(refreshButton)
        refreshButton.widthAnchor.constraint(equalTo: rootStack.widthAnchor).isActive = true
    }
    func lines() -> [String] {
        ["\(primary?.icon ?? "⚪️") 5 小时剩余：\(primary.map { "\($0.remaining)%" } ?? "未知")",
         "\(secondary?.icon ?? "⚪️") 每周剩余：\(secondary.map { "\($0.remaining)%" } ?? "未知")",
         "🔄 可用重置：\(resetText())",
         "⏱ 5 小时恢复：\(dateText(primary?.reset))",
         "    每周恢复：\(dateText(secondary?.reset))"]
    }
    func render() {
        if CommandLine.arguments.contains("--probe") {
            if let error = error { print(error); exit(1) }
            if updated != nil { print(lines().joined(separator: "\n")); process?.terminate(); exit(0) }
            return
        }
        item.button?.title = error != nil ? "⚠️ Codex" : primary.map { "\($0.icon) \($0.remaining)%" } ?? "⚪️ Codex"
        item.button?.toolTip = (lines() + [error ?? "每分钟刷新"]).joined(separator: "\n")
        let menu = NSMenu()
        for line in lines() {
            let row = NSMenuItem(title: line, action: #selector(infoItemSelected), keyEquivalent: "")
            row.target = self
            row.attributedTitle = NSAttributedString(string: line, attributes: [.foregroundColor: NSColor.labelColor])
            menu.addItem(row)
        }
        menu.addItem(.separator())
        let state = error ?? updated.map { "更新于 \(dateText($0)) · 每分钟刷新" } ?? "正在读取…"
        let status = NSMenuItem(title: state, action: #selector(infoItemSelected), keyEquivalent: "")
        status.target = self
        status.attributedTitle = NSAttributedString(string: state, attributes: [.foregroundColor: NSColor.secondaryLabelColor])
        menu.addItem(status)
        for (title, action) in [(panel.isVisible ? "隐藏浮窗" : "显示浮窗", #selector(togglePanel)), ("立即刷新", #selector(refresh)), ("退出", #selector(quit))] {
            let row = NSMenuItem(title: title, action: action, keyEquivalent: ""); row.target = self; menu.addItem(row)
        }
        item.menu = menu
        primaryMeter.update(primary, dateText: dateText)
        secondaryMeter.update(secondary, dateText: dateText)
        resetCount.stringValue = resets.map { "\($0) 次" } ?? "暂不可用"
        updatedLabel.stringValue = error ?? updated.map { "上次更新  \(dateText($0))" } ?? "正在读取额度…"
        updatedLabel.textColor = error == nil ? .secondaryLabelColor : .systemRed
        scheduleLabel.stringValue = error == nil ? "每分钟更新" : "更新暂停"
        scheduleIcon.contentTintColor = error == nil ? .systemGreen : .systemOrange
    }
    @objc func togglePanel() {
        if panel.isVisible { panel.orderOut(nil) } else { panel.makeKeyAndOrderFront(nil); NSApp.activate(ignoringOtherApps: true) }
        render()
    }
    func resetText() -> String {
        resets.map { "\($0) 次" } ?? "接口未提供，请更新 ChatGPT"
    }
    @objc func infoItemSelected() {}
    func windowWillClose(_ notification: Notification) {
        DispatchQueue.main.async { [weak self] in self?.render() }
    }
    @objc func quit() { NSApp.terminate(nil) }
    func applicationWillTerminate(_ notification: Notification) { process?.terminate() }
}

if CommandLine.arguments.contains("--self-check") {
    assert(WindowLimit(["usedPercent": 47.0])?.remaining == 53)
    assert(WindowLimit(["usedPercent": 105.0])?.remaining == 0)
    assert(WindowLimit(["usedPercent": -5.0])?.remaining == 100)
    assert(WindowLimit(["usedPercent": 90.0])?.icon == "🔴")
    assert(WindowLimit([:]) == nil)
    print("额度解析检查通过")
} else if CommandLine.arguments.contains("--probe") {
    let delegate = App()
    delegate.start()
    RunLoop.main.run()
} else {
    let application = NSApplication.shared
    let delegate = App()
    application.setActivationPolicy(.accessory)
    application.delegate = delegate
    application.run()
}
