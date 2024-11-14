// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-validations",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
        .watchOS(.v9),
        .tvOS(.v16),
        .visionOS(.v1),
    ],
    products: [
        .library(
            name: "Validations",
            targets: ["Validations"]),
    ],
    targets: [
        .target(
            name: "Validations"
        ),
        .testTarget(
            name: "ValidationsTests",
            dependencies: ["Validations"]
        ),
    ]
)
