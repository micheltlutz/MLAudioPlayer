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
/**
 Enum MLPlayerState states for player

    - idle(stopped)
    - loading
    - loaded
    - playing
    - paused
    - error
 */
public enum MLPlayerState: String {
    case idle, loading, loaded, playing, paused, error
}
/**
 Available Actions for MLAudioPlayer
 
     - play
     - pause
     - stop
     - reset
 */
public enum MLPlayerActions: String {
    case play, pause, stop, reset
}
/**
Enum MLPlayerType states for player

    - full(big playbutton and vertical)
    - mini(horizontal)
*/
public enum MLPlayerType: String {
    case full, mini
}
/**
 Struct MLAudioPlayerHelper timerFormater
*/
struct MLAudioPlayerHelper {
    /**
     This function format timer

     - Parameter time: Double value timer
     - Returns: String timer formatted 00:00
     */
    static func timerFormater(time: Double) -> String {
        let minuteString = String(format: "%02d", (Int(time) / 60))
        let secondString = String(format: "%02d", (Int(time) % 60))
        return "\(minuteString):\(secondString)"
    }
}

open class MLAudioPlayer: UIView, MLAudioPlayerProtocol {
    static let name = "MLAudioPlayer"
    /// Define MLAudioPlayerManager
    internal var audioPlayerManager: MLAudioPlayerManager!
    /// Define MLTrackPlayerView
    internal var trackPlayerView: MLTrackPlayerView!
    /// Define totalDuration: Float
    internal var totalDuration: Float = 0.0
    /// Define MLPlayerButtonView
    internal var playerButton: MLPlayerButtonView!
    /// Define progressLabel: MLLabel initial value 0%
    internal let progressLabel: MLLabel = {
        let progressLabel = MLLabel()
        progressLabel.text = "0%"
        return progressLabel
    }()
    /// progressBar: UIProgressView
    internal let progressBar: UIProgressView = {
        let progressBar = UIProgressView(progressViewStyle: .default)
        progressBar.progress = 0.0
        progressBar.transform = progressBar.transform.scaledBy(x: 1, y: 2)
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        return progressBar
    }()
    /// labelTimer: MLLabel
    internal var labelTimer: MLLabel = {
        let labelTimer = MLLabel()
        labelTimer.text = "00:00 / 00:00"
        return labelTimer
    }()
    /**
     Contains NSLayoutConstraint self heightAnchor.constraint
     */
    open private(set) var heightConstraint: NSLayoutConstraint?
    /**
     Handler indicates update in contraint height
     */
    open var didUpdateHeightConstraint: ((_ constant: CGFloat) -> Void)?
    /**
     Indicates a height CGFloat value for Main View
     */
    open var heightConstant: CGFloat!
    /**
     Contains NSLayoutConstraint self widthAnchor.constraint
     */
    open private(set) var widthConstraint: NSLayoutConstraint?
    /// retryButton: MLRetryButton
    internal var retryButton: MLRetryButton!
    private var playerConfig: MLPlayerConfig = {
        let defaultConfig = MLPlayerConfig()
        return defaultConfig
    }()
    /**
     Initializar MLAudioPlayer

     - Parameter urlAudio: String url for audio [local or stream]
     - Parameter config: MLPlayerConfig? with playerconfiguration
     */
    convenience public init(urlAudio: String, config: MLPlayerConfig? = nil, isLocalFile: Bool = false) {
        self.init(frame: .zero)
        if let config = config {
            playerConfig = config
        }
        setupType()
        setupProgressBar()
        setupTrackView()
        setupRetryButton()
        setupPlayer(urlAudio: urlAudio, isLocalFile: isLocalFile)
        setupViewConfiguration()
    }
    /**
     This function create a retryButton with playerConfig string for tryAgainText
     */
    private func setupRetryButton() {
        retryButton = MLRetryButton(text: playerConfig.tryAgainText)
    }
    /**
     This function configure a profressbar with colors on playerConfig
     */
    private func setupProgressBar() {
        progressBar.trackTintColor = playerConfig.progressTrackTintColor
        progressBar.tintColor = .white
        progressBar.progressTintColor = playerConfig.progressTintColor
        progressLabel.font = playerConfig.labelsFont
        progressLabel.textColor = playerConfig.labelsColors
    }
    /**
     This function configure playerButton
     */
    private func setupType() {
        if playerConfig.playerType == .full {
            playerButton = MLPlayerButtonView(config: nil)
            heightConstant = playerConfig.heightPlayerFull!
        } else {
            let config = MLPlayerButtonConfig()
            config.width = 48
            config.height = 48
            config.playerType = .mini
            playerButton = MLPlayerButtonView(config: config)
            heightConstant = playerConfig.heightPlayerMini!
        }
        didUpdateHeightConstraint?(heightConstant)
    }
    /**
     This function configure trackPlayerView with MLTrackPlayerView and playerConfig infos
     */
    private func setupTrackView() {
        trackPlayerView = MLTrackPlayerView(config:
            MLTrackingConfig(imageNameTrackingThumb:playerConfig.imageNameTrackingThumb!,
                             trackingTintColor: playerConfig.trackingTintColor!,
                             trackingMinimumTrackColor: playerConfig.trackingMinimumTrackColor!,
                             trackingMaximumTrackColor: playerConfig.trackingMaximumTrackColor!))
        trackPlayerView.isHidden = true
    }
    /**
     This function initialize MLAudioPlayerManager and condigure handlers, starts observables, MLAudioPlayerNotification to stop

     - Parameter urlAudio: String url for audio
     */
    internal func setupPlayer(urlAudio: String, isLocalFile: Bool) {
        audioPlayerManager = MLAudioPlayerManager(urlAudio: urlAudio)
        NotificationCenter.default.addObserver(self, selector: #selector(notificationController(_:)),
                                               name: .MLAudioPlayerNotification, object: nil)
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
    /**
     This function configure error texts and font
     */
    private func showErrorInfos() {
        DispatchQueue.main.async {
            self.playerButton.loadingLabel.text = self.playerConfig.loadErrorText
            self.playerButton.loadingLabel.font = self.playerConfig.labelsFont
            self.retryButton.isHidden = false
            self.retryButton.heightLayoutConstraint?.constant = 32
            self.trackPlayerView.isUserInteractionEnabled = false
            if self.playerConfig.playerType == .mini {
                self.heightConstant = (self.playerConfig.heightPlayerMini! + 27)
            } else {
                self.heightConstant = (self.playerConfig.heightPlayerFull! + 35)
            }
            self.heightConstraint?.constant = self.heightConstant
            self.didUpdateHeightConstraint?(self.heightConstant)
        }
    }
    /**
     This function configure loading text and font
     */
    private func showInfosTryAgain() {
        playerButton.loadingLabel.text = playerConfig.loadingText
        playerButton.loadingLabel.font = playerConfig.labelsLoadingFont
        retryButton.isHidden = true
        retryButton.heightLayoutConstraint?.constant = 2
        trackPlayerView.isUserInteractionEnabled = true
        if playerConfig.playerType == .mini {
            heightConstant = playerConfig.heightPlayerMini!
        } else {
            heightConstant = playerConfig.heightPlayerFull!
        }
        heightConstraint?.constant = heightConstant
        didUpdateHeightConstraint?(heightConstant)
    }
    /**
     :nodoc:
     */
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    /**
     :nodoc:
     */
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /**
     This function controller action on AudioPlayer with NotificationCenter
     */
    @objc func notificationController(_ notification: NSNotification) {
        if let action = notification.userInfo?["action"] as? MLPlayerActions {
            switch action {
            case .stop:
                stop()
            case .reset:
                reset()
            case .play:
                playerButton.play()
            case .pause:
                playerButton.pause()
            }
        }
    }
}

extension MLAudioPlayer: MLAudioPlayerManagerDelegate {
    /**
     This function update progressbar and label with progress downloading audio

     - Parameter percentage: Int
     */
    func didUpdateProgress(percentage: Int) {
        labelTimer.text = ""
        if playerConfig.playerType == .full {
            playerButton.loadingLabel.text = "\(percentage)% \n \(playerConfig.loadingText!)"
        } else {
            progressLabel.text = "\(percentage)%"
            labelTimer.text = playerConfig.loadingText
            labelTimer.font = playerConfig.labelsTimerFont
        }
        DispatchQueue.main.async {
            self.progressBar.setProgress(Float(percentage) / 100.0, animated: true)
        }
    }
    /**
     This function block animate and call function to show erros

     - Parameter error: Error
     */
    open func didError(error: Error) {
        playerButton.blockAnimate()
        showErrorInfos()
    }
    /**
     This function change play button to pause
     */
    open func didPause() {
        playerButton.pause()
    }
    /**
     This function change pause button to play
     */
    open func didPlay() {
        playerButton.play()
    }
    /**
     This function change timer label update tracker and reset player when audio finished

     - Parameter currentTime: Double
     - Parameter totalDuration: Double
     */
    open func didUpdateTimer(currentTime: Double, totalDuration: Double) {
        let stringTimer = makeCurrentTimerString(currentTime: currentTime, totalDuration: totalDuration)
        self.labelTimer.text = stringTimer
        self.trackPlayerView.updateValue(value: Float(currentTime))
        if ceil(currentTime) == 0.0 {
            audioPlayerManager.reset()
        }
    }
    /**
     This function make string with current and total timer

     - Parameter currentTime: Double
     - Parameter totalDuration: Double

     - Returns: String timer formatted current / total (00:00 / 00:00)
     */
    private func makeCurrentTimerString(currentTime: Double, totalDuration: Double) -> String {
        let current = MLAudioPlayerHelper.timerFormater(time: currentTime)
        let total = MLAudioPlayerHelper.timerFormater(time: totalDuration)
        return "\(current) / \(total)"
    }
    /**
     This function configure player to initialize play

     - Parameter currentTime: Double
     - Parameter totalDuration: Double
     */
    open func readyToPlay(currentTime: Double, totalDuration: Double) {
        self.playerButton.stopAnimate()
        self.totalDuration = Float(totalDuration)
        let stringTimer = makeCurrentTimerString(currentTime: currentTime, totalDuration: totalDuration)
        DispatchQueue.main.sync {
            self.labelTimer.text = stringTimer
            self.progressBar.isHidden = true
            self.trackPlayerView.isHidden = false
            self.progressLabel.isHidden = true
            self.labelTimer.font = self.playerConfig.labelsTimerFont
            if self.playerConfig.playerType == .mini {
                self.heightConstant = (self.playerConfig.heightPlayerMini!)
            } else {
                self.heightConstant = (self.playerConfig.heightPlayerFull!)
            }
            self.heightConstraint?.constant = self.heightConstant
            self.didUpdateHeightConstraint?(self.heightConstant)
        }
        self.trackPlayerView.changeMaximunValue(value: Float(totalDuration))
    }
    /**
     This function change button to paused
     */
    open func didFinishPlaying() {
        playerButton.pause()
    }
    /**
     This open function reset player
     */
    open func reset() {
        audioPlayerManager.reset()
    }
    /**
     This open function stop and reset player
     */
    open func stop() {
        self.audioPlayerManager.stop()
        playerButton.pause()
    }
}

/**
 Extension MLAudioPlayer implements ViewConfiguration protocol
 */
extension MLAudioPlayer: ViewConfiguration {
    func setupConstraints() {
        if playerConfig.playerType == .full {
            contraintsFull()
        } else {
            constraintsMini()
        }
    }
    /**
     This function configure contraints to full player
     */
    private func contraintsFull() {
        widthConstraint = widthAnchor.constraint(equalToConstant: playerConfig.widthPlayerFull!)
        widthConstraint?.isActive = true

        heightConstraint = heightAnchor.constraint(equalToConstant: playerConfig.heightPlayerFull!)
        didUpdateHeightConstraint?(CGFloat(playerConfig.heightPlayerFull!))
        heightConstraint?.isActive = true

        playerButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        playerButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
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
    /**
     This function configure contraints to mini player
     */
    private func constraintsMini() {
        widthConstraint = widthAnchor.constraint(equalToConstant: playerConfig.widthPlayerMini!)
        widthConstraint?.isActive = true

        heightConstraint = heightAnchor.constraint(equalToConstant: playerConfig.heightPlayerMini!)
        heightConstraint?.isActive = true
        didUpdateHeightConstraint?(CGFloat(playerConfig.heightPlayerMini!))
        
        playerButton.button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
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
        trackPlayerView.leadingAnchor.constraint(equalTo: playerButton.button.trailingAnchor, constant: 8).isActive = true
        trackPlayerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        
        progressBar.centerYAnchor.constraint(equalTo: playerButton.button.centerYAnchor).isActive = true
        progressBar.leadingAnchor.constraint(equalTo: playerButton.button.trailingAnchor, constant: 8).isActive = true
        progressBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        
        labelTimer.textAlignment = .left
        labelTimer.topAnchor.constraint(equalTo: trackPlayerView.bottomAnchor, constant: 0).isActive = true
        labelTimer.leadingAnchor.constraint(equalTo: trackPlayerView.leadingAnchor, constant: 0).isActive = true
        labelTimer.widthAnchor.constraint(equalToConstant: 128).isActive = true
        
        playerButton.loadingLabel.topAnchor.constraint(equalTo: labelTimer.topAnchor, constant: 0).isActive = true
        playerButton.loadingLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        playerButton.loadingLabel.widthAnchor.constraint(equalToConstant: 116).isActive = true
        playerButton.loadingLabel.textAlignment = .right
        playerButton.loadingLabel.numberOfLines = 1
        playerButton.loadingLabel.isHidden = true
        
        retryButton.topAnchor.constraint(equalTo: playerButton.button.bottomAnchor, constant: 2).isActive = true
        retryButton.leadingAnchor.constraint(equalTo: playerButton.button.leadingAnchor).isActive = true
    }
    /**
     This function configure ViewHierarchy
     */
    func buildViewHierarchy() {
        if playerConfig.playerType == .full {
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
    /**
     This function configure configureViews
     */
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

extension Notification.Name {
    ///Extension Notification name ***MLAudioPlayerNotification***
    public static let MLAudioPlayerNotification = Notification.Name("MLAudioPlayerNotificationCenter")
}
