// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PopNetworking",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "KKPinCodeTextField",
            targets: ["KKPinCodeTextField"]
        ),
    ],
    targets: [
        .target(
            name: "KKPinCodeTextField",
            path: "Classes"
        )
    ]
)
