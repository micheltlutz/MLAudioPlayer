# Change Log
-----
## [1.1.1 - Swift 5](https://github.com/micheltlutz/MLAudioPlayer/releases/tag/v1.1.1) (2019-04-14)

#### Add
* Swift 5


-----
## [1.1.0 - Swift 4.2](https://github.com/micheltlutz/MLAudioPlayer/releases/tag/v1.1.0) (2019-03-07)

#### Add
* MLPlayerConfig options

```swift
MLPlayerConfig.tryAgainFont: UIFont?
MLPlayerConfig.tryAgainColor: UIColor?
```

* Playing local storage files

```swift
var mlLocalAudioPlayer: MLAudioPlayer = {
    // For playing the stream/online files
    let mlAudioPlayer = MLAudioPlayer(urlAudio: "file://urlyourlocalaudio.mp3", isLocalFile: true)
    return mlAudioPlayer
}()
```
-----
## [1.0.5 - Swift 4.2](https://github.com/micheltlutz/MLAudioPlayer/releases/tag/v1.0.5) (2018-11-28)

#### Add
* Handler indicate when height of player change.

```swift
didUpdateHeightConstraint: ((_ constant: CGFloat) -> Void)?
```
##### Usage:

```swift
let mlAudioPlayer = MLAudioPlayer(urlAudio: "http://urlyouraudio.mp3")
mlAudioPlayer.didUpdateHeightConstraint = { constant in
            self.heightConstraint?.constant = (constant + 32)
        }
```

#### Change

Change default values in MLPlayerConfig 

heightPlayerFull -> from: 216 to: 177    
heightPlayerMini -> from: 60 to: 50

New attribute usad on labels timer: 

```swift
public var labelsTimerFont: UIFont? = UIFont.systemFont(ofSize: 12)
```


-----

## [1.0.4 - Swift 4.2](https://github.com/micheltlutz/MLAudioPlayer/releases/tag/v1.0.4) (2018-11-13)

#### Remove

Remove firs text loading from PlayerButton

-----

## [1.0.3 - Swift 4.2](https://github.com/micheltlutz/MLAudioPlayer/releases/tag/v1.0.3) (2018-10-14)

#### Add
* Support a Notification center to inactive audio session using Notification.Name: .MLAudioPlayerNotification

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


-----

## [1.0.2 - Swift 4.2](https://github.com/micheltlutz/MLAudioPlayer/releases/tag/v1.0.2) (2018-10-11)

#### Add
* Support for building iOS 10.0

---

## [1.0.1 - Swift 4.2](https://github.com/micheltlutz/MLAudioPlayer/releases/tag/v1.0.1) (2018-10-10)

#### Add
* Support for building with Xcode 10 and Swift 4.2. This version requires Xcode 10 or later with Swift 4.2 compiler.

#### Fix

- Change state when audio finished
- More configs to width and height on full and mini types
- New margin mini player old 24 new 8

---

## [1.0 - Swift 4.1](https://github.com/micheltlutz/MLAudioPlayer/releases/tag/v1.0) (2018-10-09)

#### Add
* Docs estructures image e more examples

---

## [0.0.1 - Swift 4.1](https://github.com/micheltlutz/MLAudioPlayer/releases/tag/v0.0.1) (2018-08-15)

#### Add
* initial project.


---

