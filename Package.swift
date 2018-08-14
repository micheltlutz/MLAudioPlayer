// swift-tools-version:4.1
//
//  MLAudioPlayer.swift
//  MLAudioPlayer
//
//  Created by Michel Anderson Lutz Teixeira on 23/10/15.
//  Copyright © 2017 micheltlutz. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "MLAudioPlayer",
    products: [
        .library(
            name: "MLAudioPlayer",
            targets: ["MLAudioPlayer"]),
        ],
    dependencies: [],
    targets: [
        .target(
            name: "MLAudioPlayer",
            dependencies: [],
            path: "Sources"),
        .testTarget(
            name: "MLAudioPlayerTests",
            dependencies: ["MLAudioPlayer"],
            path: "Tests")
    ]
)
