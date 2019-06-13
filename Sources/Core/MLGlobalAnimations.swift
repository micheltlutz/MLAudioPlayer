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

struct MLGlobalAnimations {
    /**
     Create infinite rotate animation in UIView with duration to complete step animation

     - Parameter view: ***UIView*** for animate
     - Parameter duration: ***Double*** for duration to complete step animation
     */
    static func infiniteRotate(view: UIView, duration: Double) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: duration/2, delay: 0.0, options: .curveLinear, animations: {
                view.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            }, completion: { finished in
                UIView.animate(withDuration: duration/2, delay: 0.0, options: .curveLinear, animations: {
                    view.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi*2))
                }, completion: { finished in
                    MLGlobalAnimations.infiniteRotate(view: view, duration: duration)
                })
            })
        }
    }
    /**
     Create infinite rotate animation to use in layer with duration to complete step animation

     - Parameter duration: ***Double*** for duration to complete step animation
     - return ***CABasicAnimation***
     */
    static func infiniteRotate(duration: Double) -> CABasicAnimation {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = Double.pi * 2 //Minus can be Direction
        rotationAnimation.duration = duration
        rotationAnimation.repeatCount = .infinity
        return rotationAnimation
    }
}
