// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "spm-bundle-sign-package",
    platforms: [.iOS(.v14)],
    products: [
        .library(name: "DependencyWithResources", targets: ["TargetWithResources"]),
        .library(name: "DependencyWithoutResources", targets: ["TargetWithoutResources"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "TargetWithResources", resources: [.process("Resources/file.txt")]),
        .target(name: "TargetWithoutResources")
    ]
)
