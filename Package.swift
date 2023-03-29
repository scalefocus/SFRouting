// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "SFRouting",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "SFRouting",
            targets: ["SFRouting"])
    ],
    targets: [
        .target(name: "SFRouting")
    ]
)
