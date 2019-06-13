////MIT License
////
////Copyright (c) 2018 Michel Anderson Lüz Teixeira
////
////Permission is hereby granted, free of charge, to any person obtaining a copy
////of this software and associated documentation files (the "Software"), to deal
////in the Software without restriction, including without limitation the rights
////to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
////copies of the Software, and to permit persons to whom the Software is
////furnished to do so, subject to the following conditions:
////
////The above copyright notice and this permission notice shall be included in all
////copies or substantial portions of the Software.
////
////THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
////IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
////FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
////AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
////LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
////OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
////SOFTWARE.

import UIKit

public struct MLPlayerConfig {
    public var labelsColors: UIColor? = UIColor(hex: "5C7A98")
    public var labelsFont: UIFont? = UIFont.systemFont(ofSize: 14)
    public var labelsLoadingFont: UIFont? = UIFont.boldSystemFont(ofSize: 14)
    public var labelsTimerFont: UIFont? = UIFont.systemFont(ofSize: 12)
    public var playerType: MLPlayerType? = .full
    public var loadingText: String? = "loading"
    public var loadErrorText: String? = "Could not load"
    public var tryAgainText: String? = "TRY AGAIN"
    public var tryAgainFont: UIFont? = UIFont.systemFont(ofSize: 14)
    public var tryAgainColor: UIColor? = UIColor(hex: "246BB3")
    public var imageNamePlayButton: String? = "play"
    public var imageNamePauseButton: String? = "pause"
    public var imageNameLoading: String? = "playerLoad"
    public var imageNameTrackingThumb: String? = "thumbTracking"
    public var trackingTintColor: UIColor? = UIColor(hex: "246BB3")
    public var trackingMinimumTrackColor: UIColor? = UIColor(hex: "246BB3")
    public var trackingMaximumTrackColor: UIColor? = UIColor(hex: "B3C4CE")
    public var progressTintColor: UIColor? = UIColor(hex: "B3C4CE")
    public var progressTrackTintColor: UIColor? = UIColor(hex: "B3C4CE").withAlphaComponent(0.5)
    public var widthPlayerFull: CGFloat? = UIScreen.main.bounds.width
    public var heightPlayerFull: CGFloat? = 177
    public var widthPlayerMini: CGFloat? = UIScreen.main.bounds.width
    public var heightPlayerMini: CGFloat? = 50
    public var initialVolume: Float? = 0.7

    public init(labelsColors: UIColor?, labelsFont: UIFont?, labelsLoadingFont: UIFont?, playerType: MLPlayerType?,
                loadingText: String?, loadErrorText: String?, imageNamePlayButton: String?,
                imageNamePauseButton: String?, imageNameLoading: String?, imageNameTrackingThumb: String?,
                trackingTintColor: UIColor?, trackingMinimumTrackColor: UIColor?,
                trackingMaximumTrackColor: UIColor?, widthPlayerFull: CGFloat?, heightPlayerFull: CGFloat?,
                widthPlayerMini: CGFloat?, heightPlayerMini: CGFloat?, labelsTimerFont: UIFont?, initialVolume: Float?) {
        self.labelsColors = labelsColors
        self.labelsFont = labelsFont
        self.labelsLoadingFont = labelsLoadingFont
        self.playerType = playerType
        self.loadingText = loadingText
        self.loadErrorText = loadErrorText
        self.imageNamePlayButton = imageNamePlayButton
        self.imageNamePauseButton = imageNamePauseButton
        self.imageNameLoading = imageNameLoading
        self.imageNameTrackingThumb = imageNameTrackingThumb
        self.trackingTintColor = trackingTintColor
        self.trackingMinimumTrackColor = trackingMinimumTrackColor
        self.trackingMaximumTrackColor = trackingMaximumTrackColor
        self.widthPlayerFull = widthPlayerFull
        self.heightPlayerFull = heightPlayerFull
        self.widthPlayerMini = widthPlayerMini
        self.heightPlayerMini = heightPlayerMini
        self.labelsTimerFont = labelsTimerFont
        self.initialVolume = initialVolume
    }
}

extension MLPlayerConfig {
    public init() {}
    public init(playerType: MLPlayerType) {
        self.playerType = playerType
    }
}
