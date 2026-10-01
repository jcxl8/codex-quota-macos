// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CodexQuota",
    platforms: [.macOS(.v13)],
    products: [
        .executable(name: "CodexQuota", targets: ["CodexQuota"]),
        .executable(name: "CodexQuotaWatcher", targets: ["CodexQuotaWatcher"])
    ],
    targets: [
        .executableTarget(name: "CodexQuota", resources: [.process("Resources")]),
        .executableTarget(name: "CodexQuotaWatcher")
    ]
)
