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
}

final class App: NSObject, NSApplicationDelegate, NSWindowDelegate {
    var item: NSStatusItem!
    var panel: NSPanel!
    var label: NSTextField!
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
        panel = NSPanel(contentRect: NSRect(x: 0, y: 0, width: 330, height: 260), styleMask: [.titled, .closable, .utilityWindow], backing: .buffered, defer: false)
        panel.title = "Codex 额度"
        panel.delegate = self
        panel.setFrameAutosaveName("CodexQuotaPanel")
        panel.level = .floating
        panel.isFloatingPanel = true
        panel.hidesOnDeactivate = false
        panel.isReleasedWhenClosed = false
        panel.center()
        label = NSTextField(wrappingLabelWithString: "正在读取额度…")
        label.frame = NSRect(x: 20, y: 60, width: 290, height: 180)
        label.font = .systemFont(ofSize: 15)
        panel.contentView?.addSubview(label)
        let button = NSButton(title: "立即刷新", target: self, action: #selector(refresh))
        button.frame = NSRect(x: 20, y: 15, width: 110, height: 32)
        panel.contentView?.addSubview(button)
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
        for line in lines() { let row = NSMenuItem(title: line, action: nil, keyEquivalent: ""); menu.addItem(row) }
        menu.addItem(.separator())
        let state = error ?? updated.map { "更新于 \(dateText($0)) · 每分钟刷新" } ?? "正在读取…"
        menu.addItem(NSMenuItem(title: state, action: nil, keyEquivalent: ""))
        for (title, action) in [(panel.isVisible ? "隐藏浮窗" : "显示浮窗", #selector(togglePanel)), ("立即刷新", #selector(refresh)), ("退出", #selector(quit))] {
            let row = NSMenuItem(title: title, action: action, keyEquivalent: ""); row.target = self; menu.addItem(row)
        }
        item.menu = menu
        label.stringValue = (lines() + ["", state]).joined(separator: "\n")
    }
    @objc func togglePanel() {
        if panel.isVisible { panel.orderOut(nil) } else { panel.makeKeyAndOrderFront(nil); NSApp.activate(ignoringOtherApps: true) }
        render()
    }
    func resetText() -> String {
        resets.map { "\($0) 次" } ?? "接口未提供，请更新 ChatGPT"
    }
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
