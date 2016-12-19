import PackageDescription

let package = Package(
    name: "Server",
    dependencies: [
        .Package(url: "https://github.com/apple/swift-protobuf.git", Version(0,9,26)),
        .Package(url: "https://github.com/IBM-Swift/Kitura.git", majorVersion: 1, minor: 3),
    ]
)
