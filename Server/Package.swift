// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "Server",
    dependencies: [
        .package(name: "Kitura", url: "https://github.com/IBM-Swift/Kitura.git", from: "1.7.0"),
        .package(name: "SwiftProtobuf", url: "https://github.com/apple/swift-protobuf.git", from: "1.6.0"),
    ],
    targets: [
        .target(name: "Server", dependencies: ["Kitura", "SwiftProtobuf"]),
    ]
)
