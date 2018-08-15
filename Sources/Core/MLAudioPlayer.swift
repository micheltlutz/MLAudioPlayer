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

public enum MLPlayerState: String {
    case idle
    case loading
    case loaded
    case playing
    case paused
    case error
}

public enum MLPlayerType: String {
    case full, mini
}

struct MLAudioPlayerHelper {
    static func timerFormater(time: Double) -> String {
        let minuteString = String(format: "%02d", (Int(time) / 60))
        let secondString = String(format: "%02d", (Int(time) % 60))
        return "\(minuteString):\(secondString)"
    }
}

open class MLAudioPlayer: UIView, MLAudioPlayerProtocol {
    static let name = "MLAudioPlayer"
    internal var audioPlayerManager: MLAudioPlayerManager!
    internal var trackPlayerView: MLTrackPlayerView!
    internal var totalDuration: Float = 0.0
    internal var playerButton: MLPlayerButtonView!
    internal let progressLabel: MLLabel = {
        let progressLabel = MLLabel()
        progressLabel.text = "0%"
        return progressLabel
    }()
    
    internal let progressBar: UIProgressView = {
        let progressBar = UIProgressView(progressViewStyle: .default)
        progressBar.progress = 0.0
        progressBar.transform = progressBar.transform.scaledBy(x: 1, y: 2)
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        return progressBar
    }()
    internal var labelTimer: MLLabel = {
        let labelTimer = MLLabel()
        labelTimer.text = "00:00 / 00:00"
        return labelTimer
    }()
    internal var retryButton = MLRetryButton()
    private var playerConfig: MLPlayerConfig = {
        let defaultConfig = MLPlayerConfig()
        return defaultConfig
    }()
    convenience public init(urlAudio: String, config: MLPlayerConfig? = nil) {
        self.init(frame: .zero)
        if let config = config {
            playerConfig = config
        }
        setupType()
        setupProgressBar()
        setupTrackView()
        setupPlayer(urlAudio: urlAudio)
        setupViewConfiguration()
    }
    
    private func setupProgressBar() {
        progressBar.trackTintColor = playerConfig.progressTrackTintColor
        progressBar.tintColor = .white
        progressBar.progressTintColor = playerConfig.progressTintColor
        progressLabel.font = playerConfig.labelsFont
        progressLabel.textColor = playerConfig.labelsColors
    }
    
    private func setupType() {
        if playerConfig.playerType == .full {
            playerButton = MLPlayerButtonView(config: nil)
        } else {
            let config = MLPlayerButtonConfig()
            config.width = 48
            config.height = 48
            config.playerType = .mini
            playerButton = MLPlayerButtonView(config: config)
        }
    }
    
    private func setupTrackView() {
        trackPlayerView = MLTrackPlayerView(config: MLTrackingConfig(imageNameTrackingThumb: playerConfig.imageNameTrackingThumb!,
                                                                     trackingTintColor: playerConfig.trackingTintColor!,
                                                                     trackingMinimumTrackColor: playerConfig.trackingMinimumTrackColor!,
                                                                     trackingMaximumTrackColor: playerConfig.trackingMaximumTrackColor!))
        
        trackPlayerView.isHidden = true
    }
    
    internal func setupPlayer(urlAudio: String) {
        audioPlayerManager = MLAudioPlayerManager(urlAudio: urlAudio)
        audioPlayerManager.delegate = self
        playerButton.didPlay = { [weak self] in
            self?.audioPlayerManager.play()
        }
        playerButton.didPause = { [weak self] in
            self?.audioPlayerManager.pause()
        }
        trackPlayerView.didChangeValue = { [weak self] value in
            if self?.playerButton.state == .paused {
                DispatchQueue.main.async {
                    let stringTimer = self?.makeCurrentTimerString(currentTime: Double(value), totalDuration: Double((self?.totalDuration)!))
                    self?.labelTimer.text = stringTimer
                }
            }
            self?.audioPlayerManager.trackNavigation(to: value)
        }
        retryButton.didTap = { [weak self] in
            self?.audioPlayerManager.tryAgain()
            self?.showInfosTryAgain()
            self?.playerButton.startAnimate()
        }
    }
    private func showErrorInfos() {
        playerButton.loadingLabel.text = playerConfig.loadErrorText
        playerButton.loadingLabel.font = playerConfig.labelsFont
        retryButton.isHidden = false
        retryButton.heightLayoutConstraint?.constant = 32
        trackPlayerView.isUserInteractionEnabled = false
    }
    private func showInfosTryAgain() {
        playerButton.loadingLabel.text = playerConfig.loadingText
        playerButton.loadingLabel.font = playerConfig.labelsLoadingFont
        retryButton.isHidden = true
        retryButton.heightLayoutConstraint?.constant = 2
        trackPlayerView.isUserInteractionEnabled = true
    }
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension MLAudioPlayer: MLAudioPlayerManagerDelegate {
    func didUpdateProgress(percentage: Int) {
        labelTimer.text = ""
        if playerConfig.playerType == .full {
            playerButton.loadingLabel.text = "\(percentage)% \n \(playerConfig.loadingText!)"
        } else {
            progressLabel.text = "\(percentage)%"
            labelTimer.text = playerConfig.loadingText
            labelTimer.font = playerConfig.labelsLoadingFont
        }
        DispatchQueue.main.async {
            self.progressBar.setProgress(Float(percentage) / 100.0, animated: true)
        }
    }
    open func didError(error: Error) {
        playerButton.blockAnimate()
        showErrorInfos()
    }
    open func didPause() {
        playerButton.pause()
    }
    open func didPlay() {
        playerButton.play()
    }
    open func didUpdateTimer(currentTime: Double, totalDuration: Double) {
        let stringTimer = makeCurrentTimerString(currentTime: currentTime, totalDuration: totalDuration)
        self.labelTimer.text = stringTimer
        self.trackPlayerView.updateValue(value: Float(currentTime))
    }
    private func makeCurrentTimerString(currentTime: Double, totalDuration: Double) -> String {
        let current = MLAudioPlayerHelper.timerFormater(time: currentTime)
        let total = MLAudioPlayerHelper.timerFormater(time: totalDuration)
        return "\(current) / \(total)"
    }
    open func readyToPlay(currentTime: Double, totalDuration: Double) {
        self.playerButton.stopAnimate()
        self.totalDuration = Float(totalDuration)
        let stringTimer = makeCurrentTimerString(currentTime: currentTime, totalDuration: totalDuration)
        DispatchQueue.main.sync {
            self.labelTimer.text = stringTimer
            self.progressBar.isHidden = true
            self.trackPlayerView.isHidden = false
            self.progressLabel.isHidden = true
            self.labelTimer.font = self.playerConfig.labelsFont
        }
        self.trackPlayerView.changeMaximunValue(value: Float(totalDuration))
    }
}
extension MLAudioPlayer: ViewConfiguration {
    func setupConstraints() {
        if playerConfig.playerType == .full {
            contraintsFull()
        } else {
            constraintsMini()
        }
    }
    
    private func contraintsFull() {
        widthAnchor.constraint(equalToConstant: 368).isActive = true
        heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        playerButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        playerButton.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        
        retryButton.topAnchor.constraint(equalTo: playerButton.bottomAnchor, constant: 8).isActive = true
        retryButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        trackPlayerView.topAnchor.constraint(equalTo: retryButton.bottomAnchor, constant: 8).isActive = true
        trackPlayerView.widthAnchor.constraint(equalToConstant: 224).isActive = true
        trackPlayerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        progressBar.topAnchor.constraint(equalTo: retryButton.bottomAnchor, constant: 8).isActive = true
        progressBar.widthAnchor.constraint(equalToConstant: 224).isActive = true
        progressBar.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        labelTimer.topAnchor.constraint(equalTo: trackPlayerView.bottomAnchor, constant: 0).isActive = true
        labelTimer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        labelTimer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
    }
    
    private func constraintsMini() {
        widthAnchor.constraint(equalToConstant: 368).isActive = true
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        playerButton.button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24).isActive = true
        playerButton.button.topAnchor.constraint(equalTo: topAnchor).isActive = true
        playerButton.button.heightAnchor.constraint(equalToConstant: playerButton.config.height!).isActive = true
        playerButton.button.widthAnchor.constraint(equalToConstant: playerButton.config.width!).isActive = true
        
        playerButton.loadingView.centerXAnchor.constraint(equalTo: playerButton.button.centerXAnchor).isActive = true
        playerButton.loadingView.centerYAnchor.constraint(equalTo: playerButton.button.centerYAnchor).isActive = true
        playerButton.loadingView.heightAnchor.constraint(equalTo: playerButton.button.heightAnchor).isActive = true
        playerButton.loadingView.widthAnchor.constraint(equalTo: playerButton.button.widthAnchor).isActive = true
        
        progressLabel.centerXAnchor.constraint(equalTo: playerButton.loadingView.centerXAnchor).isActive = true
        progressLabel.centerYAnchor.constraint(equalTo: playerButton.loadingView.centerYAnchor).isActive = true
        
        trackPlayerView.centerYAnchor.constraint(equalTo: playerButton.button.centerYAnchor).isActive = true
        trackPlayerView.leadingAnchor.constraint(equalTo: playerButton.button.trailingAnchor, constant: 24).isActive = true
        trackPlayerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24).isActive = true
        
        progressBar.centerYAnchor.constraint(equalTo: playerButton.button.centerYAnchor).isActive = true
        progressBar.leadingAnchor.constraint(equalTo: playerButton.button.trailingAnchor, constant: 24).isActive = true
        progressBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24).isActive = true
        
        labelTimer.textAlignment = .left
        labelTimer.topAnchor.constraint(equalTo: trackPlayerView.bottomAnchor, constant: 0).isActive = true
        labelTimer.leadingAnchor.constraint(equalTo: trackPlayerView.leadingAnchor, constant: 0).isActive = true
        labelTimer.widthAnchor.constraint(equalToConstant: 128).isActive = true
        
        playerButton.loadingLabel.topAnchor.constraint(equalTo: labelTimer.topAnchor, constant: 0).isActive = true
        playerButton.loadingLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24).isActive = true
        playerButton.loadingLabel.widthAnchor.constraint(equalToConstant: 116).isActive = true
        playerButton.loadingLabel.textAlignment = .right
        playerButton.loadingLabel.numberOfLines = 1
        playerButton.loadingLabel.isHidden = true
        
        retryButton.topAnchor.constraint(equalTo: playerButton.button.bottomAnchor, constant: 2).isActive = true
        retryButton.leadingAnchor.constraint(equalTo: playerButton.button.leadingAnchor).isActive = true
    }
    
    func buildViewHierarchy() {
        if playerConfig.playerType == .full {
            addSubview(playerButton)
            addSubview(playerButton)
            addSubview(retryButton)
            addSubview(trackPlayerView)
            addSubview(progressBar)
            addSubview(labelTimer)
        } else {
            addSubview(playerButton.button)
            addSubview(playerButton.loadingView)
            addSubview(progressLabel)
            addSubview(trackPlayerView)
            addSubview(progressBar)
            addSubview(labelTimer)
            addSubview(playerButton.loadingLabel)
            addSubview(retryButton)
        }
    }
    
    func configureViews() {
        translatesAutoresizingMaskIntoConstraints = false
        labelTimer.textColor = playerConfig.labelsColors
        labelTimer.font = playerConfig.labelsFont
        playerButton.loadingLabel.font = playerConfig.labelsLoadingFont
        playerButton.loadingLabel.textColor = playerConfig.labelsColors
        retryButton.button.setTitleColor(playerConfig.labelsColors, for: .normal)
        retryButton.isHidden = true
    }
}
