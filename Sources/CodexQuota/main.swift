import AppKit
import SwiftUI

struct WindowLimit {
    let remaining: Int
    let reset: Date?

    init?(_ raw: Any?) {
        guard let value = raw as? [String: Any],
              let used = value["usedPercent"] as? Double,
              used.isFinite else { return nil }
        remaining = Int(max(0, min(100, 100 - used)).rounded())
        reset = (value["resetsAt"] as? Double).map(Date.init(timeIntervalSince1970:))
    }
}

struct QuotaProgressBar: View {
    let remaining: Int?

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule().fill(Color.primary.opacity(0.12))
                Capsule().fill(Color.blue)
                    .frame(width: geometry.size.width * CGFloat(remaining ?? 0) / 100)
            }
        }
        .frame(height: 8)
        .accessibilityElement()
        .accessibilityLabel(Text(verbatim: AppText.text("Remaining quota")))
        .accessibilityValue(remaining.map { "\($0)%" } ?? AppText.text("Unknown"))
    }
}

struct QuotaMeter: View {
    let title: String
    let limit: WindowLimit?
    let recoveryText: String

    var body: some View {
        let content = VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline) {
                Text(verbatim: title).font(.system(size: 14, weight: .medium))
                Spacer(minLength: 12)
                Text(limit.map { "\($0.remaining)%" } ?? "—")
                    .font(.system(size: 23, weight: .semibold, design: .rounded).monospacedDigit())
                    .foregroundStyle(.primary)
                    .accessibilityLabel(Text(verbatim: AppText.quotaAccessibility(title: title, remaining: limit?.remaining)))
            }
            QuotaProgressBar(remaining: limit?.remaining)
                .accessibilityLabel(Text(verbatim: AppText.quotaAccessibility(title: title, remaining: limit?.remaining)))
            Label {
                Text(verbatim: recoveryText)
            } icon: {
                Image(systemName: "clock")
            }
                .font(.system(size: 11))
                .foregroundStyle(Color.primary.opacity(0.72))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)

        content.modifier(AdaptiveGlassSurface(radius: 18))
    }
}

struct AdaptiveGlassSurface: ViewModifier {
    var radius: CGFloat

    func body(content: Content) -> some View {
        if #available(macOS 26.0, *) {
            content.glassEffect(.regular, in: RoundedRectangle(cornerRadius: radius, style: .continuous))
        } else {
            content.background(.regularMaterial, in: RoundedRectangle(cornerRadius: radius, style: .continuous))
        }
    }
}

struct AdaptiveGlassButton<Label: View>: View {
    let action: () -> Void
    var role: ButtonRole? = nil
    var prominent = false
    @ViewBuilder let label: () -> Label

    var body: some View {
        if #available(macOS 26.0, *) {
            if prominent {
                Button(role: role, action: action, label: label).buttonStyle(.glassProminent).tint(.blue)
            } else {
                Button(role: role, action: action, label: label).buttonStyle(.glass)
            }
        } else {
            if prominent {
                Button(role: role, action: action, label: label).buttonStyle(.borderedProminent).tint(.blue)
            } else {
                Button(role: role, action: action, label: label).buttonStyle(.bordered)
            }
        }
    }
}

struct QuotaDashboard: View {
    @ObservedObject var app: App
    var isFloating: Bool
    @State private var confirmsReset = false

    var body: some View {
        glassContent
    }

    @ViewBuilder
    private var glassContent: some View {
        if #available(macOS 26.0, *) {
            GlassEffectContainer(spacing: 12) {
                if isFloating {
                    panelContent.glassEffect(.regular, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
                } else {
                    panelContent
                }
            }
        } else if isFloating {
            panelContent.background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        } else {
            panelContent
        }
    }

    private var panelContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            header
            quotaMeters
            resetAction
            footer
        }
        .padding(18)
        .frame(width: 390)
        .alert(Text(verbatim: AppText.text("Use one reset credit?")), isPresented: $confirmsReset) {
            Button(role: .destructive) { app.consumeResetCredit() } label: {
                Text(verbatim: AppText.text("Use reset"))
            }
            Button(role: .cancel) { } label: {
                Text(verbatim: AppText.text("Cancel"))
            }
        } message: {
            Text(verbatim: AppText.text("This will use one reset credit and reset eligible quota."))
        }
    }

    private var header: some View {
        HStack(spacing: 8) {
            draggableHeading
            dragRegion
            AdaptiveGlassButton(action: app.refresh) {
                Label {
                    Text(verbatim: AppText.text("Refresh"))
                } icon: {
                    Image(systemName: "arrow.clockwise")
                }
            }
            .controlSize(.small)
            .disabled(app.pending || app.isConsumingReset)
            .help(AppText.text("Refresh quota"))

            if isFloating {
                AdaptiveGlassButton(action: app.hideFloatingPanel) {
                    Image(systemName: "xmark")
                        .frame(width: 18, height: 18)
                }
                .controlSize(.small)
                .accessibilityLabel(Text(verbatim: AppText.text("Close floating window")))
            } else {
                AdaptiveGlassButton(action: app.showFloatingPanel) {
                    Image(systemName: "macwindow")
                        .frame(width: 18, height: 18)
                }
                .controlSize(.small)
                .accessibilityLabel(Text(verbatim: AppText.text("Open floating window")))
            }

            AdaptiveGlassButton(action: { NSApp.terminate(nil) }) {
                Label {
                    Text(verbatim: AppText.text("Quit"))
                } icon: {
                    Image(systemName: "power")
                }
            }
            .controlSize(.small)
            .accessibilityLabel(Text(verbatim: AppText.text("Quit")))
            .help(AppText.text("Quit Codex Quota"))
        }
    }

    private var titleContent: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(verbatim: AppText.text("Codex Quota"))
                .font(.system(size: 17, weight: .semibold, design: .rounded))
            Text(verbatim: app.error ?? AppText.text("Updates every minute"))
                .font(.system(size: 11))
                .foregroundStyle(app.error == nil ? Color.primary.opacity(0.72) : Color.orange)
                .lineLimit(1)
                .layoutPriority(1)
        }
        .layoutPriority(1)
    }

    @ViewBuilder
    private var draggableHeading: some View {
        if isFloating, #available(macOS 26.0, *) {
            titleContent
                .gesture(WindowDragGesture())
                .allowsWindowActivationEvents()
                .accessibilityHint(Text(verbatim: AppText.text("Drag the title to move this window")))
        } else {
            titleContent
        }
    }

    @ViewBuilder
    private var dragRegion: some View {
        if isFloating, #available(macOS 26.0, *) {
            Color.clear
                .frame(maxWidth: .infinity, minHeight: 44)
                .contentShape(Rectangle())
                .gesture(WindowDragGesture())
                .allowsWindowActivationEvents()
                .accessibilityHidden(true)
                .layoutPriority(-1)
        } else {
            Spacer(minLength: 4)
        }
    }

    private var quotaMeters: some View {
        VStack(spacing: 10) {
            QuotaMeter(
                title: AppText.text("5-hour quota"),
                limit: app.primary,
                recoveryText: AppText.format("Resets at %@", app.dateText(app.primary?.reset))
            )
            QuotaMeter(
                title: AppText.text("Weekly quota"),
                limit: app.secondary,
                recoveryText: AppText.format("Resets at %@", app.dateText(app.secondary?.reset))
            )
        }
    }

    private var resetAction: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 3) {
                Label {
                    Text(verbatim: AppText.text("Reset credits"))
                } icon: {
                    Image(systemName: "arrow.uturn.backward")
                }
                    .font(.system(size: 13, weight: .medium))
                Text(verbatim: app.resets.map { AppText.count("Available: %d", $0) } ?? AppText.text("Loading…"))
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
            }
            Spacer(minLength: 8)
            AdaptiveGlassButton(action: { confirmsReset = true }, prominent: true) {
                Label {
                    Text(verbatim: AppText.text(app.isConsumingReset ? "Using…" : "Use reset"))
                } icon: {
                    Image(systemName: "arrow.uturn.backward")
                }
            }
            .controlSize(.small)
            .disabled(!app.canConsumeReset)
        }
        .padding(13)
        .frame(maxWidth: .infinity, alignment: .leading)
        .modifier(AdaptiveGlassSurface(radius: 18))
    }

    private var footer: some View {
        let status = app.error ?? app.notice ?? app.updated.map { AppText.format("Last updated: %@", app.dateText($0)) } ?? AppText.text("Connecting to Codex…")
        return HStack(spacing: 6) {
            if app.error != nil {
                Image(systemName: "exclamationmark.triangle.fill").foregroundStyle(.orange)
            } else if app.notice != nil {
                Image(systemName: "checkmark.circle.fill").foregroundStyle(.blue)
            }
            Text(verbatim: status)
                .font(.system(size: 11))
                .foregroundStyle(app.error == nil ? Color.primary.opacity(0.72) : Color.orange)
                .lineLimit(2)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 2)
    }
}

@MainActor
final class App: NSObject, NSApplicationDelegate, NSWindowDelegate, ObservableObject {
    var item: NSStatusItem!
    var panel: NSPanel!
    var popover: NSPopover!
    var process: Process?
    var input: FileHandle?
    var buffer = Data()
    @Published var primary: WindowLimit?
    @Published var secondary: WindowLimit?
    @Published var resets: Int?
    @Published var updated: Date?
    @Published var error: String?
    @Published var notice: String?
    @Published var ready = false
    @Published var pending = false
    @Published var isConsumingReset = false
    var serial = 10
    var requestID: Int?
    var resetRequestID: Int?
    var resetIdempotencyKey = UserDefaults.standard.string(forKey: "pendingRateLimitResetKey")
    var timer: Timer?
    var deadline: Timer?
    var noticeTimer: Timer?

    var canConsumeReset: Bool {
        ready && !pending && !isConsumingReset && (resets ?? 0) > 0
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        item.button?.setAccessibilityLabel(AppText.text("Codex Quota"))
        item.button?.target = self
        item.button?.action = #selector(togglePopover)

        panel = NSPanel(contentRect: NSRect(x: 0, y: 0, width: 390, height: 370), styleMask: [.borderless, .utilityWindow], backing: .buffered, defer: false)
        panel.title = AppText.text("Codex Quota")
        panel.delegate = self
        panel.setFrameAutosaveName("CodexQuotaGlassPanel")
        panel.level = .floating
        panel.isFloatingPanel = true
        panel.hidesOnDeactivate = false
        panel.isReleasedWhenClosed = false
        panel.isMovableByWindowBackground = true
        panel.isOpaque = false
        panel.backgroundColor = .clear
        let panelContent = NSHostingView(rootView: QuotaDashboard(app: self, isFloating: true))
        panelContent.frame = NSRect(origin: .zero, size: NSSize(width: 390, height: 370))
        panelContent.autoresizingMask = [.width, .height]
        panel.contentView = panelContent
        panel.center()

        popover = NSPopover()
        popover.behavior = .transient
        popover.animates = true
        let popoverContent = NSHostingController(rootView: QuotaDashboard(app: self, isFloating: false))
        popover.contentViewController = popoverContent
        popover.contentSize = NSSize(width: 390, height: 370)

        renderStatusItem()
        start()
        if CommandLine.arguments.contains("--show-panel") { showFloatingPanel() }
        if CommandLine.arguments.contains("--show-popover") {
            DispatchQueue.main.async { [weak self] in
                NSApp.activate(ignoringOtherApps: true)
                self?.showPopover()
            }
        }
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            MainActor.assumeIsolated { self?.refresh() }
        }
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(refresh), name: NSWorkspace.didWakeNotification, object: nil)
    }

    func start() {
        buffer.removeAll()
        requestID = nil
        resetRequestID = nil
        ready = false
        let paths = ["/Applications/ChatGPT.app/Contents/Resources/codex-cli/bin/codex", FileManager.default.homeDirectoryForCurrentUser.path + "/.local/bin/codex", "/opt/homebrew/bin/codex", "/usr/local/bin/codex"]
        guard let path = paths.first(where: { FileManager.default.isExecutableFile(atPath: $0) }) else {
            error = AppText.text("Codex CLI was not found. Please sign in to ChatGPT.")
            renderStatusItem()
            return
        }
        let process = Process(), stdinPipe = Pipe(), stdoutPipe = Pipe()
        process.executableURL = URL(fileURLWithPath: path)
        process.arguments = ["app-server", "--listen", "stdio://"]
        process.standardInput = stdinPipe
        process.standardOutput = stdoutPipe
        process.standardError = FileHandle.nullDevice
        input = stdinPipe.fileHandleForWriting
        stdoutPipe.fileHandleForReading.readabilityHandler = { [weak self] handle in
            let data = handle.availableData
            DispatchQueue.main.async { self?.receive(data) }
        }
        process.terminationHandler = { [weak self, weak process] _ in
            DispatchQueue.main.async {
                guard let self, self.process === process else { return }
                self.deadline?.invalidate()
                self.buffer.removeAll()
                self.requestID = nil
                self.resetRequestID = nil
                self.input = nil
                self.process = nil
                self.pending = false
                self.isConsumingReset = false
                self.ready = false
                self.error = self.resetIdempotencyKey == nil
                    ? AppText.text("Quota connection was lost. Click Refresh to try again.")
                    : AppText.text("Connection interrupted. Confirm again to safely retry this reset.")
                self.renderStatusItem()
            }
        }
        do {
            try process.run()
            self.process = process
            send(["id": 1, "method": "initialize", "params": [
                "clientInfo": ["name": "codex_quota", "title": "Codex Quota", "version": "1.4.0"],
                "capabilities": ["experimentalApi": true, "requestAttestation": false]
            ]])
            armTimeout()
        } catch {
            self.error = AppText.text("Unable to start Codex CLI.")
            renderStatusItem()
        }
    }

    func send(_ object: [String: Any]) {
        guard let bytes = try? JSONSerialization.data(withJSONObject: object) else { return }
        do {
            try input?.write(contentsOf: bytes + Data([10]))
        } catch {
            self.error = AppText.text("Could not send a request to Codex.")
            pending = false
            isConsumingReset = false
            renderStatusItem()
        }
    }

    func armTimeout() {
        deadline?.invalidate()
        deadline = Timer.scheduledTimer(withTimeInterval: 20, repeats: false) { [weak self] _ in
            MainActor.assumeIsolated {
                guard let self else { return }
                self.pending = false
                self.isConsumingReset = false
                self.ready = false
                self.error = self.resetIdempotencyKey == nil
                    ? AppText.text("Timed out while reading quota; values may be outdated.")
                    : AppText.text("The reset result is unconfirmed. Confirm again to retry safely.")
                self.renderStatusItem()
                self.process?.terminate()
            }
        }
    }

    func receive(_ data: Data) {
        buffer.append(data)
        while let end = buffer.firstIndex(of: 10) {
            let line = buffer.prefix(upTo: end)
            buffer.removeSubrange(...end)
            guard let json = try? JSONSerialization.jsonObject(with: line) as? [String: Any] else { continue }
            if json["id"] as? Int == 1 {
                deadline?.invalidate()
                if json["error"] != nil {
                    error = AppText.text("Initialization failed. Update Codex CLI.")
                    renderStatusItem()
                    process?.terminate()
                    continue
                }
                send(["method": "initialized"])
                ready = true
                error = nil
                refresh()
            } else if let id = json["id"] as? Int, id == resetRequestID {
                finishReset(json)
            } else if let id = json["id"] as? Int, id == requestID {
                deadline?.invalidate()
                pending = false
                guard let result = json["result"] as? [String: Any] else {
                    error = AppText.text("Could not read quota. Make sure you are signed in to ChatGPT.")
                    renderStatusItem()
                    continue
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
        primary = WindowLimit(limits["primary"])
        secondary = WindowLimit(limits["secondary"])
        resets = (result["rateLimitResetCredits"] as? [String: Any])?["availableCount"] as? Int
        updated = Date()
        error = primary == nil && secondary == nil ? AppText.text("No quota data was returned; this account may not support it.") : nil
        if resets == 0 { clearResetAttempt() }
        renderStatusItem()
    }

    @objc func refresh() {
        if process == nil { start(); return }
        guard ready, !pending, !isConsumingReset else { return }
        pending = true
        serial += 1
        requestID = serial
        send(["id": serial, "method": "account/rateLimits/read", "params": [:]])
        armTimeout()
    }

    func consumeResetCredit() {
        guard canConsumeReset else { return }
        if resetIdempotencyKey == nil {
            resetIdempotencyKey = UUID().uuidString
            UserDefaults.standard.set(resetIdempotencyKey, forKey: "pendingRateLimitResetKey")
        }
        guard let resetIdempotencyKey else { return }
        isConsumingReset = true
        notice = nil
        serial += 1
        resetRequestID = serial
        send(["id": serial, "method": "account/rateLimitResetCredit/consume", "params": ["idempotencyKey": resetIdempotencyKey]])
        armTimeout()
    }

    func finishReset(_ response: [String: Any]) {
        deadline?.invalidate()
        resetRequestID = nil
        isConsumingReset = false
        guard let result = response["result"] as? [String: Any],
              let outcome = result["outcome"] as? String else {
            showNotice(AppText.text("Reset is unconfirmed. Confirm again to retry safely."))
            renderStatusItem()
            return
        }
        switch outcome {
        case "reset":
            clearResetAttempt()
            showNotice(AppText.text("Reset used. Refreshing quota…"))
            refresh()
        case "alreadyRedeemed":
            clearResetAttempt()
            showNotice(AppText.text("This reset request was already completed. Refreshing quota…"))
            refresh()
        case "noCredit":
            clearResetAttempt()
            showNotice(AppText.text("No reset credits are currently available."))
            refresh()
        case "nothingToReset":
            clearResetAttempt()
            showNotice(AppText.text("There is no quota eligible for reset."))
            refresh()
        default:
            showNotice(AppText.text("Reset was not completed. Confirm again to retry safely."))
        }
        renderStatusItem()
    }

    func clearResetAttempt() {
        resetIdempotencyKey = nil
        UserDefaults.standard.removeObject(forKey: "pendingRateLimitResetKey")
    }

    func showNotice(_ text: String) {
        notice = text
        noticeTimer?.invalidate()
        noticeTimer = Timer.scheduledTimer(withTimeInterval: 8, repeats: false) { [weak self] _ in
            MainActor.assumeIsolated { self?.notice = nil }
        }
    }

    func dateText(_ date: Date?) -> String {
        guard let date else { return AppText.text("Unknown") }
        let formatter = DateFormatter()
        formatter.locale = AppText.locale
        formatter.setLocalizedDateFormatFromTemplate("MMMdHm")
        return formatter.string(from: date)
    }

    func renderStatusItem() {
        guard let button = item?.button else { return }
        let logo = Bundle.module.url(forResource: "chatgptTemplate", withExtension: "png")
            .flatMap(NSImage.init(contentsOf:))
        button.image = logo ?? NSImage(systemSymbolName: "circle.hexagongrid.fill", accessibilityDescription: "ChatGPT")
        button.image?.isTemplate = true
        button.title = primary.map { " \($0.remaining)%" } ?? " —%"
        button.setAccessibilityLabel(error ?? AppText.quotaAccessibility(title: AppText.text("5-hour quota"), remaining: primary?.remaining))
        button.toolTip = [
            AppText.format("5-hour quota: %@", primary.map { "\($0.remaining)%" } ?? AppText.text("Unknown")),
            AppText.format("Weekly quota: %@", secondary.map { "\($0.remaining)%" } ?? AppText.text("Unknown")),
            resets.map { AppText.count("Reset credits available: %d", $0) }
                ?? AppText.text("Reset credits available: %d").replacingOccurrences(of: "%d", with: AppText.text("Unknown")),
            error ?? notice ?? updated.map { AppText.format("Updated: %@", dateText($0)) } ?? AppText.text("Loading quota…")
        ].joined(separator: "\n")
    }

    @objc func togglePopover() {
        if popover.isShown { popover.performClose(nil) } else { showPopover() }
    }

    func showPopover() {
        guard let button = item?.button else { return }
        popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
    }

    func showFloatingPanel() {
        popover.performClose(nil)
        panel.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    func hideFloatingPanel() { panel.orderOut(nil) }

    func windowWillClose(_ notification: Notification) {
        objectWillChange.send()
    }

    func applicationWillTerminate(_ notification: Notification) { process?.terminate() }
}

if CommandLine.arguments.contains("--self-check") {
    assert(WindowLimit(["usedPercent": 47.0])?.remaining == 53)
    assert(WindowLimit(["usedPercent": 105.0])?.remaining == 0)
    assert(WindowLimit(["usedPercent": -5.0])?.remaining == 100)
    assert(WindowLimit([:]) == nil)
    assert(AppLanguage.resolve(preferredLanguages: ["en-US"]) == .english)
    assert(AppLanguage.resolve(preferredLanguages: ["zh-Hans-CN"]) == .simplifiedChinese)
    assert(AppLanguage.resolve(preferredLanguages: ["zh-Hant-HK"]) == .traditionalChinese)
    assert(AppLanguage.resolve(preferredLanguages: ["fr-FR"]) == .french)
    assert(AppLanguage.resolve(preferredLanguages: ["ru-RU"]) == .russian)
    assert(AppLanguage.resolve(preferredLanguages: ["de-DE"]) == .german)
    assert(AppLanguage.resolve(preferredLanguages: ["it-IT"]) == .italian)
    assert(AppLanguage.resolve(preferredLanguages: ["ja-JP"]) == .japanese)
    assert(AppLanguage.resolve(preferredLanguages: ["ko-KR"]) == .korean)
    assert(AppLanguage.resolve(preferredLanguages: ["pt-PT"]) == .portuguese)
    assert(AppLanguage.resolve(preferredLanguages: ["es-ES", "fr-FR"]) == .french)
    assert(AppLanguage.resolve(preferredLanguages: ["es-ES"]) == .english)
    assert(AppText.text("Updates every minute", language: .simplifiedChinese) == "每分钟自动更新")
    assert(AppText.text("Quit", language: .traditionalChinese) == "退出")
    assert(AppText.text("Quit", language: .french) == "Quitter")
    assert(AppText.text("Quit", language: .russian) == "Выйти")
    assert(AppText.text("Codex Quota", language: .german) == "Codex-Limit")
    assert(AppText.text("Quit", language: .italian) == "Esci")
    assert(AppText.text("Updates every minute", language: .japanese) == "毎分自動更新")
    assert(AppText.text("Quit", language: .korean) == "종료")
    assert(AppText.text("Quit", language: .portuguese) == "Sair")
    print("额度解析检查通过")
} else if CommandLine.arguments.contains("--probe") {
    MainActor.assumeIsolated {
        let delegate = App()
        delegate.start()
        RunLoop.main.run()
    }
} else {
    MainActor.assumeIsolated {
        let application = NSApplication.shared
        let delegate = App()
        application.setActivationPolicy(.accessory)
        application.delegate = delegate
        application.run()
    }
}
