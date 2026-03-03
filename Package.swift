// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "featurevisor-example-swift",
    platforms: [
        .macOS(.v13)
    ],
    dependencies: [
        .package(url: "https://github.com/featurevisor/featurevisor-swift2.git", from: "0.1.0")
    ],
    targets: [
        .executableTarget(
            name: "featurevisor-example-swift",
            dependencies: [
                .product(name: "Featurevisor", package: "featurevisor-swift2")
            ]
        )
    ]
)
