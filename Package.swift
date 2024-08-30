// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "ai-commit",
  platforms: [
    .macOS(.v14)
  ],
  dependencies: [
    .package(url: "https://github.com/kevinhermawan/OllamaKit.git", .upToNextMajor(from: "5.0.0")),
    .package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.0"),
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .executableTarget(
      name: "ai-commit", dependencies: [
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
        .product(name: "OllamaKit", package: "OllamaKit"),
      ]
    ),
  ]
)
