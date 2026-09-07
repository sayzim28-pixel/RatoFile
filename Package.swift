// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "RatoFiles",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "RatoFilesCore",
            targets: ["RatoFilesCore"]),
    ],
    targets: [
        .target(
            name: "RatoFilesCore",
            path: "Sources/Core"),
        .testTarget(
            name: "RatoFilesTests",
            dependencies: ["RatoFilesCore"],
            path: "Tests"),
    ]
)
