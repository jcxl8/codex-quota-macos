import Foundation

enum ChatGPTLaunchAgent {
    static let preferenceKey = "launchWithChatGPT"
    private static let label = "local.zheng.codexquota.chatgptwatcher"

    private static var plistURL: URL {
        FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent("Library/LaunchAgents", isDirectory: true)
            .appendingPathComponent("\(label).plist")
    }

    private static var guiDomain: String { "gui/\(getuid())" }
    private static var serviceTarget: String { "\(guiDomain)/\(label)" }

    static func propertyList(executablePath: String) -> [String: Any] {
        [
            "Label": label,
            "AssociatedBundleIdentifiers": "local.zheng.codexquota",
            "ProgramArguments": [executablePath],
            "RunAtLoad": true,
            "KeepAlive": true,
            "ProcessType": "Background"
        ]
    }

    static func enable() throws {
        let executable = Bundle.main.bundleURL
            .appendingPathComponent("Contents/MacOS/CodexQuotaWatcher")
        guard FileManager.default.isExecutableFile(atPath: executable.path) else {
            throw LaunchAgentError.executableMissing
        }

        let desired = propertyList(executablePath: executable.path)
        let data = try PropertyListSerialization.data(fromPropertyList: desired, format: .xml, options: 0)
        let existing = (try? Data(contentsOf: plistURL))
            .flatMap { try? PropertyListSerialization.propertyList(from: $0, format: nil) as? [String: Any] }
        let serviceLoaded = try runLaunchctl(["print", serviceTarget]).status == 0

        if let existing,
           NSDictionary(dictionary: existing).isEqual(to: desired),
           serviceLoaded {
            return
        }

        if serviceLoaded {
            let result = try runLaunchctl(["bootout", serviceTarget])
            guard result.status == 0 else { throw LaunchAgentError.commandFailed }
        }

        try FileManager.default.createDirectory(
            at: plistURL.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        try data.write(to: plistURL, options: .atomic)

        let result = try runLaunchctl(["bootstrap", guiDomain, plistURL.path])
        guard result.status == 0 else {
            try? FileManager.default.removeItem(at: plistURL)
            throw LaunchAgentError.commandFailed
        }
    }

    static func disable() throws {
        let result = try runLaunchctl(["bootout", serviceTarget])
        if result.status != 0, try runLaunchctl(["print", serviceTarget]).status == 0 {
            throw LaunchAgentError.commandFailed
        }
        if FileManager.default.fileExists(atPath: plistURL.path) {
            try FileManager.default.removeItem(at: plistURL)
        }
    }

    private static func runLaunchctl(_ arguments: [String]) throws -> (status: Int32, output: String) {
        let process = Process()
        let pipe = Pipe()
        process.executableURL = URL(fileURLWithPath: "/bin/launchctl")
        process.arguments = arguments
        process.standardOutput = pipe
        process.standardError = pipe
        try process.run()
        let output = String(decoding: pipe.fileHandleForReading.readDataToEndOfFile(), as: UTF8.self)
        process.waitUntilExit()
        return (process.terminationStatus, output)
    }
}

private enum LaunchAgentError: Error {
    case executableMissing
    case commandFailed
}
