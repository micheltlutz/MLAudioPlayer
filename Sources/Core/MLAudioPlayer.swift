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
    internal let trackPlayerView = MLTrackPlayerView()
    internal var totalDuration: Float = 0.0
    internal var type: MLPlayerType!
    internal var playerButton: MLPlayerButtonView!
    internal var labelTimer: MLLabel = {
        let labelTimer = MLLabel()
        labelTimer.text = "00:00 / 00:00"
        return labelTimer
    }()
    internal var retryButton = MLRetryButton()
    convenience public init(urlAudio: String, type: MLPlayerType? = .full) {
        self.init(frame: .zero)
        self.type = type
        setupType()
        setupPlayer(urlAudio: urlAudio)
        setupViewConfiguration()
    }
    private func setupType() {
        if type == .full {
            playerButton = MLPlayerButtonView()
        } else {
            playerButton = MLPlayerButtonView(width: (48), height: (48), type: .mini)
        }
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
    }
    private func showErrorInfos() {
        playerButton.loadingLabel.text = "Could not load"
        retryButton.isHidden = false
    }
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension MLAudioPlayer: MLAudioPlayerManagerDelegate {
    open func didError(error: Error) {
        print("didError")
        print(error)
        playerButton.blockAnimate()
    }
    open func didPause() {
        print("didPause")
        playerButton.pause()
    }
    open func didPlay() {
        print("didPlay")
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
        }
        self.trackPlayerView.changeMaximunValue(value: Float(totalDuration))
    }
}
extension MLAudioPlayer: ViewConfiguration {
    func setupConstraints() {
        if type == .full {
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
        
        retryButton.topAnchor.constraint(equalTo: playerButton.bottomAnchor, constant: 24).isActive = true
        retryButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        trackPlayerView.topAnchor.constraint(equalTo: retryButton.bottomAnchor, constant: 24).isActive = true
        trackPlayerView.widthAnchor.constraint(equalToConstant: 224).isActive = true
        trackPlayerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        labelTimer.topAnchor.constraint(equalTo: trackPlayerView.bottomAnchor, constant: 0).isActive = true
        labelTimer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        labelTimer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
    }
    
    private func constraintsMini() {
        widthAnchor.constraint(equalToConstant: 368).isActive = true
        heightAnchor.constraint(equalToConstant: 64).isActive = true
        
        playerButton.button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24).isActive = true
        playerButton.button.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        playerButton.button.heightAnchor.constraint(equalToConstant: playerButton.height).isActive = true
        playerButton.button.widthAnchor.constraint(equalToConstant: playerButton.width).isActive = true
        
        playerButton.loadingView.centerXAnchor.constraint(equalTo: playerButton.button.centerXAnchor).isActive = true
        playerButton.loadingView.centerYAnchor.constraint(equalTo: playerButton.button.centerYAnchor).isActive = true
        playerButton.loadingView.heightAnchor.constraint(equalTo: playerButton.button.heightAnchor).isActive = true
        playerButton.loadingView.widthAnchor.constraint(equalTo: playerButton.button.widthAnchor).isActive = true
        
        trackPlayerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        trackPlayerView.leadingAnchor.constraint(equalTo: playerButton.button.trailingAnchor, constant: 24).isActive = true
        trackPlayerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24).isActive = true
        
        labelTimer.textAlignment = .left
        labelTimer.topAnchor.constraint(equalTo: trackPlayerView.bottomAnchor, constant: 0).isActive = true
        labelTimer.leadingAnchor.constraint(equalTo: trackPlayerView.leadingAnchor, constant: 0).isActive = true
        labelTimer.widthAnchor.constraint(equalToConstant: 128).isActive = true
        
        playerButton.loadingLabel.topAnchor.constraint(equalTo: labelTimer.topAnchor, constant: 0).isActive = true
        playerButton.loadingLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24).isActive = true
        playerButton.loadingLabel.widthAnchor.constraint(equalToConstant: 108).isActive = true
        playerButton.loadingLabel.textAlignment = .right
        
        retryButton.topAnchor.constraint(equalTo: playerButton.button.bottomAnchor, constant: 24).isActive = true
        retryButton.leadingAnchor.constraint(equalTo: playerButton.button.leadingAnchor).isActive = true
    }
    
    func buildViewHierarchy() {
        if type == .full {
            addSubview(playerButton)
            addSubview(retryButton)
            addSubview(trackPlayerView)
            addSubview(labelTimer)
        } else {
            addSubview(playerButton.button)
            addSubview(playerButton.loadingView)
            addSubview(trackPlayerView)
            addSubview(labelTimer)
            addSubview(playerButton.loadingLabel)
            addSubview(retryButton)
        }
    }
    
    func configureViews() {
        translatesAutoresizingMaskIntoConstraints = false
        labelTimer.textColor = UIColor(hex: "5C7A98")
        playerButton.loadingLabel.textColor = UIColor(hex: "5C7A98")
        retryButton.isHidden = false
        //retryButton.isHidden = true
    }
}
