# MLAudioPlayer

<p align="center">
 <img width="300" height="300"src="http://micheltlutz.me/imagens/projetos/MLAudioPlayer/MLAUDIOPLAYER.png">
 </p>

[![Swift Version](https://img.shields.io/badge/Swift-5.0-brightgreen.svg?style=flat)](https://github.com/apple/swift/blob/master/CHANGELOG.md)
[![Platforms](https://img.shields.io/cocoapods/p/MLAudioPlayer.svg)](https://cocoapods.org/pods/MLAudioPlayer)
[![License](https://img.shields.io/cocoapods/l/MLAudioPlayer.svg)](https://raw.githubusercontent.com/micheltlutz/MLAudioPlayer/master/LICENSE)

[![Swift Package Manager](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods compatible](https://img.shields.io/cocoapods/v/MLAudioPlayer.svg)](https://cocoapods.org/pods/MLAudioPlayer)


AudioPlayer for Swift projects

- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [License](#license)

## Requirements

- iOS 10.0+
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

pod 'MLAudioPlayer', '~> 1.1.0'
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
github "micheltlutz/MLAudioPlayer" ~> 1.1.0
```

</details>

<details>
  <summary><strong>Swift Package Manager</strong></summary>

To use MLAudioPlayer as a [Swift Package Manager](https://swift.org/package-manager/) package just add the following in your Package.swift file.

``` swift
// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "HelloMLAudioPlayer",
    dependencies: [
        .package(url: "https://github.com/micheltlutz/MLAudioPlayer.git", .upToNextMajor(from: "1.1.0"))
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

### You need these images files with named in your Assets 

- play
- pause
- refresh
- playerLoad
- thumbTracking


```swift
import MLAudioPlayer


//Default Sizes
//MLAudioPlayer.widthPlayerMini = UIScreen.main.bounds.width
//MLAudioPlayer.heightPlayerMini = CGFloat(216)

// For playing stream/online files
var mlAudioPlayer: MLAudioPlayer = {
    // For playing the stream/online files
    let mlAudioPlayer = MLAudioPlayer(urlAudio: "http://urlyouraudio.mp3")
    return mlAudioPlayer
}()

// For playing local storage files
var mlLocalAudioPlayer: MLAudioPlayer = {
    // For playing the stream/online files
    let mlAudioPlayer = MLAudioPlayer(urlAudio: "file://urlyourlocalaudio.mp3", isLocalFile: true)
    return mlAudioPlayer
}()


//Default Sizes
//MLAudioPlayer.widthPlayerFull = UIScreen.main.bounds.width
//MLAudioPlayer.heightPlayerFull = CGFloat(80)
var mlAudioPlayerMini: MLAudioPlayer = {
    var config = MLPlayerConfig()
    config.loadingText = "carregando"
    config.playerType = .mini
    config.tryAgainText = "TENTAR NOVAMENTE"

    let mlAudioPlayerMini = MLAudioPlayer(urlAudio: "http://urlyouraudio.mp3", config: config)
    return mlAudioPlayerMini
}()

//Can you listenign a player heightConstraint changes
mlAudioPlayer.didUpdateHeightConstraint = { constant in
	print("heightConstraint changed"
}

```


### MLPlayerConfig


Can you change any configuration on MLPlayerConfig


### Properties to change infos on lock screen
```swift
class MLAudioPlayer {
	/// Define a Title Audio to show in block Screen
	public var titleAudio = ""
    /// Define a Title for album to show in lock Screen
    public var titleAlbum = ""
    /// Define a artist name to show in lock Screen
    public var artistName = ""
    /// Define a artwork to show in block Screen
    public var artwork: UIImage?
    /// Contains a current time audio
    public var currentTime: Double = 0.0
}
```

#### See available configurations:


```swift
//Default configurations:

MLPlayerConfig {
	labelsColors: UIColor? = UIColor(hex: "5C7A98")
	labelsFont: UIFont? = UIFont.systemFont(ofSize: 14)
	labelsLoadingFont: UIFont? = UIFont.boldSystemFont(ofSize: 14)
   labelsTimerFont: UIFont? = UIFont.systemFont(ofSize: 12)
	playerType: MLPlayerType? = .full
	loadingText: String? = "loading"
	loadErrorText: String? = "Could not load"
	tryAgainText: String? = "TRY AGAIN"
	tryAgainFont: UIFont? = UIFont.systemFont(ofSize: 14)
	tryAgainColor: UIColor? = UIColor(hex: "246BB3")
	imageNamePlayButton: String? = "play"
	imageNamePauseButton: String? = "pause"
	imageNameLoading: String? = "playerLoad"
	imageNameTrackingThumb: String? = "thumbTracking"
	trackingTintColor: UIColor? = UIColor(hex: "246BB3")
	trackingMinimumTrackColor: UIColor? = UIColor(hex: "246BB3")
	trackingMaximumTrackColor: UIColor? = UIColor(hex: "B3C4CE")
	progressTintColor: UIColor? = UIColor(hex: "B3C4CE")
	progressTrackTintColor: UIColor? = UIColor(hex: "B3C4CE").withAlphaComponent(0.5)
	widthPlayerFull = widthPlayerFull
	heightPlayerFull = heightPlayerFull
	widthPlayerMini = widthPlayerMini
	heightPlayerMini = heightPlayerMini
}
```

### Using Notification Center

Usage: 

```swift 
NotificationCenter.default.post(name: Notification.Name.MLAudioPlayerNotification, 
										object: nil,
										userInfo: ["action":MLPlayerActions.stop])
```
Available Actions for MLAudioPlayer
 
     - play
     - pause
     - stop
     - reset



### Can you change the images names

```swift
	var config = MLPlayerConfig()
	config. imageNamePlayButton = "customPlayButton"
```

<p align="center">
 <img width="350" height="317"src="http://micheltlutz.me/imagens/projetos/MLAudioPlayer/IMG_4649.jpg"> 
</p>


## Demo 

On this project change target for MLAudioPlayerDemo Build and Run


## Docs

See [Documentation](http://htmlpreview.github.io/?https://github.com/micheltlutz/MLAudioPlayer/blob/develop/docs/index.html)

MLAudioPlayer Docs (33% documented)


## Contributing

Issues and pull requests are welcome!

## Todo

- [ ] Player type with cover image for audio
- [x] Play local files (Thanks [@maclacerda](https://github.com/maclacerda))
- [x] Suporte a Notification center to stop background audio
- [x] Migrate to Swift 4.2 (Thanks [@maclacerda](https://github.com/maclacerda))
- [x] Migrate to Swift 5
- [x] Enable MPRemoteCommandCenter
- [ ] 100% documented

## Author

Michel Anderson Lutz Teixeira [@michel_lutz](https://twitter.com/michel_lutz)

## Contributions

<a href="https://github.com/maclacerda"><img src="https://avatars.githubusercontent.com/u/4759987?v=3" title="maclacerda" width="80" height="80"></a>


## License

MLAudioPlayer is released under the MIT license. See [LICENSE](https://github.com/micheltlutz/MLAudioPlayer/blob/master/LICENSE) for details.
