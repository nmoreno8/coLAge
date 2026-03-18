// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "coLAge",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "coLAge",
            targets: ["coLAge"]),
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.0.0"),
    ],
    targets: [
        .target(
            name: "coLAge",
            dependencies: [
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
            ]),
        .testTarget(
            name: "coLAgeTests",
            dependencies: ["coLAge"]),
    ]
) 