import AppKit
import Foundation

private let chatGPTBundleIdentifier = "com.openai.codex"

private func quotaAppURL(for watcherExecutable: URL) -> URL {
    watcherExecutable
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .deletingLastPathComponent()
}

if CommandLine.arguments.contains("--self-check") {
    let appURL = quotaAppURL(for: URL(fileURLWithPath: "/Applications/CodexQuota.app/Contents/MacOS/CodexQuotaWatcher"))
    assert(appURL.path == "/Applications/CodexQuota.app")
    assert(chatGPTBundleIdentifier == "com.openai.codex")
    print("ChatGPT 启动监听检查通过")
} else {
    let appURL = quotaAppURL(for: URL(fileURLWithPath: CommandLine.arguments[0]))
    let center = NSWorkspace.shared.notificationCenter
    let observer = center.addObserver(
        forName: NSWorkspace.didLaunchApplicationNotification,
        object: nil,
        queue: .main
    ) { notification in
        guard let application = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication,
              application.bundleIdentifier == chatGPTBundleIdentifier else { return }
        NSWorkspace.shared.openApplication(at: appURL, configuration: NSWorkspace.OpenConfiguration()) { _, error in
            if let error { NSLog("Could not open Codex Quota: %@", error.localizedDescription) }
        }
    }

    if !NSRunningApplication.runningApplications(withBundleIdentifier: chatGPTBundleIdentifier).isEmpty {
        NSWorkspace.shared.openApplication(at: appURL, configuration: NSWorkspace.OpenConfiguration()) { _, error in
            if let error { NSLog("Could not open Codex Quota: %@", error.localizedDescription) }
        }
    }

    withExtendedLifetime(observer) { RunLoop.main.run() }
}
