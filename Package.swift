// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HalsteadVolume",
    products: [
        .library(
            name: "HalsteadVolume",
            targets: ["HalsteadVolume"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", exact: "0.50600.1"),
    ],
    targets: [
        .target(
            name: "HalsteadVolume",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxParser", package: "swift-syntax"),
            ]),
        .testTarget(
            name: "HalsteadVolumeTests",
            dependencies: ["HalsteadVolume"]),
    ]
)
