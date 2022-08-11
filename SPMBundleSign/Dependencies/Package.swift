// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "Dependencies",
    platforms: [.iOS(.v14)],
    products: [
        .library(name: "DependenciesUmbrella",
                 type: .dynamic,
                 targets: ["DependenciesUmbrella"]),
    ],
    dependencies: [
        .package(name: "spm-bundle-sign-package", path:"../../"),
    ],
    targets: [
        .target(
            name: "DependenciesUmbrella",
            dependencies: [
                .product(name: "DependencyWithResources", package: "spm-bundle-sign-package"),
                .product(name: "DependencyWithoutResources", package: "spm-bundle-sign-package")
            ]),
    ]
)
