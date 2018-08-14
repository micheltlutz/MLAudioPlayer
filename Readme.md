# MLAudioPlayer

[![Platforms](https://img.shields.io/cocoapods/p/MLAudioPlayer.svg)](https://cocoapods.org/pods/MLAudioPlayer)
[![License](https://img.shields.io/cocoapods/l/MLAudioPlayer.svg)](https://raw.githubusercontent.com/micheltlutz/MLAudioPlayer/master/LICENSE)

[![Swift Package Manager](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods compatible](https://img.shields.io/cocoapods/v/MLAudioPlayer.svg)](https://cocoapods.org/pods/MLAudioPlayer)

[![Travis](https://img.shields.io/travis/micheltlutz/MLAudioPlayer/master.svg)](https://travis-ci.org/micheltlutz/MLAudioPlayer/branches)
[![SwiftFrameworkTemplate](https://img.shields.io/badge/SwiftFramework-Template-red.svg)](http://github.com/RahulKatariya/SwiftFrameworkTemplate)

AudioPlayer for Swift projects

- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [License](#license)

## Requirements

- iOS 10.0+ / tvOS 9.0+ 
- Xcode 9.0+

## Installation

### Dependency Managers
<details>
  <summary><strong>CocoaPods</strong></summary>

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate MLAudioPlayer into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

pod 'MLAudioPlayer', '~> 0.0.1'
```

Then, run the following command:

```bash
$ pod install
```

</details>

<details>
  <summary><strong>Carthage</strong></summary>

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that automates the process of adding frameworks to your Cocoa application.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate MLAudioPlayer into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "micheltlutz/MLAudioPlayer" ~> 0.0.1
```

</details>

<details>
  <summary><strong>Swift Package Manager</strong></summary>

To use MLAudioPlayer as a [Swift Package Manager](https://swift.org/package-manager/) package just add the following in your Package.swift file.

``` swift
// swift-tools-version:4.1

import PackageDescription

let package = Package(
    name: "HelloMLAudioPlayer",
    dependencies: [
        .package(url: "https://github.com/micheltlutz/MLAudioPlayer.git", .upToNextMajor(from: "0.0.1"))
    ],
    targets: [
        .target(name: "HelloMLAudioPlayer", dependencies: ["MLAudioPlayer"])
    ]
)
```
</details>

### Manually

If you prefer not to use either of the aforementioned dependency managers, you can integrate MLAudioPlayer into your project manually.

<details>
  <summary><strong>Git Submodules</strong></summary><p>

- Open up Terminal, `cd` into your top-level project directory, and run the following command "if" your project is not initialized as a git repository:

```bash
$ git init
```

- Add MLAudioPlayer as a git [submodule](http://git-scm.com/docs/git-submodule) by running the following command:

```bash
$ git submodule add https://github.com/micheltlutz/MLAudioPlayer.git
$ git submodule update --init --recursive
```

- Open the new `MLAudioPlayer` folder, and drag the `MLAudioPlayer.xcodeproj` into the Project Navigator of your application's Xcode project.

    > It should appear nested underneath your application's blue project icon. Whether it is above or below all the other Xcode groups does not matter.

- Select the `MLAudioPlayer.xcodeproj` in the Project Navigator and verify the deployment target matches that of your application target.
- Next, select your application project in the Project Navigator (blue project icon) to navigate to the target configuration window and select the application target under the "Targets" heading in the sidebar.
- In the tab bar at the top of that window, open the "General" panel.
- Click on the `+` button under the "Embedded Binaries" section.
- You will see two different `MLAudioPlayer.xcodeproj` folders each with two different versions of the `MLAudioPlayer.framework` nested inside a `Products` folder.

    > It does not matter which `Products` folder you choose from.

- Select the `MLAudioPlayer.framework`.

- And that's it!

> The `MLAudioPlayer.framework` is automagically added as a target dependency, linked framework and embedded framework in a copy files build phase which is all you need to build on the simulator and a device.

</p></details>

<details>
  <summary><strong>Embedded Binaries</strong></summary><p>

- Download the latest release from https://github.com/micheltlutz/MLAudioPlayer/releases
- Next, select your application project in the Project Navigator (blue project icon) to navigate to the target configuration window and select the application target under the "Targets" heading in the sidebar.
- In the tab bar at the top of that window, open the "General" panel.
- Click on the `+` button under the "Embedded Binaries" section.
- Add the downloaded `MLAudioPlayer.framework`.
- And that's it!

</p></details>

## Usage

### You need two image files with named in your Assets 

- questionUnchecked
- questionChecked

```swift

import MLQuestionCheck

let question1 = MLQuestionCheck(question: "You are ok?")
question1.didChangeState = { checked in
print("question1 checked? \(checked)")
}

```

### You can Change the image name 
```swift

question1.uncheckedImageName = "new image name"
question1.checkedImageName = "new image name"
question1.setupCheck() // to change configuration buttons

```

## Contributing

Issues and pull requests are welcome!

## Author

Michel Anderson Lutz Teixeira [@michel_lutz](https://twitter.com/michel_lutz)

## License

MLAudioPlayer is released under the MIT license. See [LICENSE](https://github.com/micheltlutz/MLAudioPlayer/blob/master/LICENSE) for details.
