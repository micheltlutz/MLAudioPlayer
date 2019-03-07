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

class MLRetryButton: UIView {
    var button: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "refresh"), for: .normal)
        button.setTitle("TRY AGAIN", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    var didTap: (() -> Void)?
    var heightLayoutConstraint: NSLayoutConstraint?
    init(text: String? = "TRY AGAIN") {
        super.init(frame: .zero)
        if let text = text {
            button.setTitle(text, for: .normal)
        }
        button.addTarget(self, action: #selector(tapAction), for: .touchUpInside)
        setupViewConfiguration()
    }
    @objc func tapAction() {
        didTap?()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MLRetryButton: ViewConfiguration {
    func setupConstraints() {
        heightLayoutConstraint = heightAnchor.constraint(equalToConstant: 1)
        heightLayoutConstraint?.isActive = true
        button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        button.topAnchor.constraint(equalTo: topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func buildViewHierarchy() {
        addSubview(button)
    }
    
    func configureViews() {
        translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
    }
}
