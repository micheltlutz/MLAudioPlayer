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
 Default MLPlayerButtonConfig
 */
class MLPlayerButtonConfig {
    var playButtonImageName: String? = "play"
    var pauseButtonImageName: String? = "pause"
    var loadingImageName: String = "playerLoad"
    var width: CGFloat? = 128
    var height: CGFloat? = 128
    var playerType: MLPlayerType? = .full
    var loadAnimating: Bool? = true
    var showLoadLabel: Bool? = true
    var aCircleTime = 2.0
}
/**
 MLPlayerButtonView extends UIView
 */
class MLPlayerButtonView: UIView {
    /// state: MLPlayerState default value .idle
    var state: MLPlayerState = .idle
    /// type: MLPlayerType default value .full
    var type: MLPlayerType = .full
    ///check playerInfo: String
    var playerInfo: String = ""
    /**
     Class constant button: UIButton
     */
    internal let button: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "play"), for: .normal)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    /**
     Class constant loadingView: UIImageView
     */
    internal let loadingView: UIImageView = {
        let loadingView = UIImageView(image: UIImage(named: "playerLoad"))
        loadingView.isHidden = true
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        return loadingView
    }()
    /**
     Class constant loadingLabel: MLLabel
     */
    internal let loadingLabel: MLLabel = {
        let loadingLabel = MLLabel()
        loadingLabel.text = ""
        return loadingLabel
    }()
    ///Clousure to didPlay no paramter
    var didPlay: (() -> Void)!
    ///Clousure to didPause no paramter
    var didPause: (() -> Void)!
    /// ***MLPlayerButtonConfig***
    var config = MLPlayerButtonConfig()
    /**
     Initializer
     - Parameter MLPlayerButtonConfig?:
     */
    init(config: MLPlayerButtonConfig?) {
        super.init(frame: .zero)
        if let config = config {
            self.config = config
        }
        self.button.addTarget(self, action: #selector(toogleState), for: .touchUpInside)
        if self.config.playerType == .full {
            self.setupViewConfiguration()
        }
    }
    /**
     toogleState selector
     */
    @objc private func toogleState() {
        switch state {
        case .paused, .loaded:
            play()
            didPlay?()
        case .playing:
            pause()
            didPause?()
        case .loading:
            if playerInfo == "readyToPlay" {
                play()
                didPlay?()
            }
        default:
            break
        }
    }
    /**
     Play selector
     */
    @objc func play() {
        state = .playing
        button.setImage(UIImage(named: config.pauseButtonImageName!), for: .normal)
    }
    /**
     Pause selector
     */
    @objc func pause() {
        state = .paused
        button.setImage(UIImage(named: config.playButtonImageName!), for: .normal)
    }
    /**
     Stop Animation and call interaction definer
     */
    func stopAnimate() {
        if self.config.loadAnimating! {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 1.0, animations: {
                    if self.config.showLoadLabel! {
                        self.loadingLabel.alpha = 0.0
                        self.button.isHidden = false
                    }
                    self.loadingView.alpha = 0.0
                }) { (success) in
                    if success {
                        self.readyToInteract()
                        self.loadingView.layer.removeAllAnimations()
                    }
                }
            }
        } else {
            readyToInteract()
        }
    }
    /**
     Change state to .loaded and define bottom to ready to interact
     */
    private func readyToInteract() {
        self.state = .loaded
        self.loadingLabel.isHidden = true
        self.loadingView.isHidden = true
        self.isUserInteractionEnabled = true
    }
    /**
     Start Animation and change state of buttom
     */
    func startAnimate() {
        state = .loading
        loadingView.isHidden = false
        if !config.showLoadLabel! {
            loadingLabel.isHidden = true
        }
        if config.loadAnimating! {
            MLGlobalAnimations.infiniteRotate(view: loadingView, duration: config.aCircleTime)
        }
    }
    /**
     Remove All Animations of PlayerButton
     */
    func blockAnimate() {
        if config.loadAnimating! {
            DispatchQueue.main.async {
                self.loadingView.layer.removeAllAnimations()
            }
        }
    }
    /**
     :nodoc:
     */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MLPlayerButtonView: ViewConfiguration {
    func setupConstraints() {
        heightAnchor.constraint(equalToConstant: config.height!).isActive = true
        widthAnchor.constraint(equalToConstant: config.width!).isActive = true
        
        button.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        button.topAnchor.constraint(equalTo: topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        loadingView.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
        loadingView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        loadingView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        loadingLabel.leadingAnchor.constraint(equalTo: loadingView.leadingAnchor, constant: 16).isActive = true
        loadingLabel.trailingAnchor.constraint(equalTo: loadingView.trailingAnchor, constant: -16).isActive = true
        loadingLabel.heightLayoutConstraint?.constant = config.height! - 36
        loadingLabel.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor).isActive = true
        loadingLabel.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor).isActive = true
    }
    func buildViewHierarchy() {
        addSubview(button)
        addSubview(loadingView)
        addSubview(loadingLabel)
    }
    func configureViews() {
        translatesAutoresizingMaskIntoConstraints = false
    }
}
