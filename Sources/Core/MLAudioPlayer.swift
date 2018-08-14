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
    internal var playerButton = MLPlayerButtonView()
    internal var labelTimer = MLLabelTimerPlayerView()
    convenience public init(urlAudio: String) {
        self.init(frame: .zero)
        setupViewConfiguration()
        setupPlayer(urlAudio: urlAudio)
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
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension MLAudioPlayer: MLAudioPlayerManagerDelegate {
    open func didError(error: Error) {
        print(error)
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
        widthAnchor.constraint(equalToConstant: 368).isActive = true
        heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        playerButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        playerButton.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        
        trackPlayerView.topAnchor.constraint(equalTo: playerButton.bottomAnchor, constant: 24).isActive = true
        trackPlayerView.widthAnchor.constraint(equalToConstant: 224).isActive = true
        trackPlayerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        labelTimer.topAnchor.constraint(equalTo: trackPlayerView.bottomAnchor, constant: 0).isActive = true
        labelTimer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        labelTimer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
    }
    
    func buildViewHierarchy() {
        addSubview(playerButton)
        addSubview(trackPlayerView)
        addSubview(labelTimer)
    }
    
    func configureViews() {
        translatesAutoresizingMaskIntoConstraints = false
    }
}
