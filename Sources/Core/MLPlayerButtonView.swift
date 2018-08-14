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

class MLPlayerButtonView: UIView {
    var state: MLPlayerState = .idle
    var type: MLPlayerType = .full
    internal let button: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "play"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    internal let loadingView: UIImageView = {
        let loadingView = UIImageView(image: UIImage(named: "playerLoad"))
        loadingView.isHidden = true
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        return loadingView
    }()
    
    internal let loadingLabel: MLLabel = {
        let loadingLabel = MLLabel()
        loadingLabel.text = "loading"
        return loadingLabel
    }()
    
    var didPlay: (() -> Void)!
    var didPause: (() -> Void)!
    
    internal var width: CGFloat = 128
    internal var height: CGFloat = 128
    private var loadAnimating = true
    private var showLoadLabel = true
//    init() {
//        super.init(frame: .zero)
//        button.addTarget(self, action: #selector(toogleState), for: .touchUpInside)
//        setupViewConfiguration()
//        startAnimate()
//    }
    
    init(width: CGFloat? = 128 , height: CGFloat? = 128, type: MLPlayerType? = .full, loadAnimating: Bool? = true, showLoadLabel: Bool? = true) {
        super.init(frame: .zero)
        self.button.addTarget(self, action: #selector(toogleState), for: .touchUpInside)
        self.width = width!
        self.height = height!
        self.type = type!
        self.loadAnimating = loadAnimating!
        self.showLoadLabel = showLoadLabel!
        if type == .full {
            self.setupViewConfiguration()
        }
        self.startAnimate()
    }
    
    
    @objc func toogleState() {
        switch state {
        case .paused, .loaded:
            play()
            didPlay?()
        case .playing:
            pause()
            didPause?()
        default:
            isUserInteractionEnabled = false
        }
    }
    
    @objc func play() {
        state = .playing
        button.setImage(UIImage(named: "pause"), for: .normal)
    }
    
    @objc func pause() {
        state = .paused
        button.setImage(UIImage(named: "play"), for: .normal)
    }
    
    func stopAnimate() {
        if loadAnimating {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 1.0, animations: {
                    if self.showLoadLabel {
                        self.loadingLabel.alpha = 0.0
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
    private func readyToInteract() {
        self.state = .loaded
        self.loadingLabel.isHidden = true
        self.loadingView.isHidden = true
        self.isUserInteractionEnabled = true
    }
    
    func startAnimate() {
        state = .loading
        let aCircleTime = 2.0
        loadingView.isHidden = false
        if !showLoadLabel {
            loadingLabel.isHidden = true
        }
        
        if loadAnimating {
            loadingView.layer.add(MLGlobalAnimations.infiniteRotate(duration: aCircleTime), forKey: nil)
        }
    }
    func blockAnimate() {
        if loadAnimating {
            DispatchQueue.main.async {
                self.loadingView.layer.removeAllAnimations()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MLPlayerButtonView: ViewConfiguration {
    func setupConstraints() {
        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
        
        button.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        button.topAnchor.constraint(equalTo: topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        loadingView.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
        loadingView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        loadingView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        loadingLabel.leadingAnchor.constraint(equalTo: loadingView.leadingAnchor).isActive = true
        loadingLabel.trailingAnchor.constraint(equalTo: loadingView.trailingAnchor).isActive = true
        loadingLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
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
