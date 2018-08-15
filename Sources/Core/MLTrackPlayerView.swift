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

struct MLTrackingConfig {
    var imageNameTrackingThumb: String
    var trackingTintColor: UIColor
    var trackingMinimumTrackColor: UIColor
    var trackingMaximumTrackColor: UIColor
}

class MLTrack: UISlider {
    var trackHeight: CGFloat = 4
    
    init(config: MLTrackingConfig) {
        super.init(frame: .zero)
        isContinuous = false
        tintColor = config.trackingTintColor
        minimumTrackTintColor = config.trackingMinimumTrackColor
        maximumTrackTintColor = config.trackingMaximumTrackColor
        translatesAutoresizingMaskIntoConstraints = false
        setThumbImage(UIImage(named: config.imageNameTrackingThumb), for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(origin: bounds.origin, size: CGSize(width: bounds.width, height: trackHeight))
    }
}

class MLTrackPlayerView: UIView {
    private var sliderTrack: MLTrack!
    var didChangeValue: ((_ value: Float) -> Void)?
    
    init(config: MLTrackingConfig) {
        super.init(frame: .zero)
        sliderTrack = MLTrack(config: config)
        sliderTrack.addTarget(self, action: #selector(changeValue), for: .valueChanged)
        setupViewConfiguration()
    }
    
    func changeMaximunValue(value: Float) {
        DispatchQueue.main.sync {
            self.sliderTrack.maximumValue = value
        }
    }
    
    func updateValue(value: Float) {
        sliderTrack.setValue(value, animated: true)
    }
    
    @objc private func changeValue() {
        didChangeValue?(sliderTrack.value)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MLTrackPlayerView: ViewConfiguration {
    func setupConstraints() {
        heightAnchor.constraint(equalToConstant: 16).isActive = true
        sliderTrack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        sliderTrack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        sliderTrack.topAnchor.constraint(equalTo: topAnchor).isActive = true
        sliderTrack.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func buildViewHierarchy() {
        addSubview(sliderTrack)
    }
    
    func configureViews() {
        translatesAutoresizingMaskIntoConstraints = false
    }
}
