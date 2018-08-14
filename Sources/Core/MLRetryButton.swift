//
//  MLRetryButton.swift
//  MLAudioPlayer-iOS
//
//  Created by Michel Anderson Lutz Teixeira on 14/08/2018.
//  Copyright © 2018 micheltlutz. All rights reserved.
//

import UIKit

class MLRetryButton: UIView {
    var label: MLLabel = {
        let label = MLLabel()
        label.text = "TRY AGAIN"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var icon: UIImageView = {
        let icon = UIImageView(image: UIImage(named: "retry"))
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.heightAnchor.constraint(equalToConstant: 16).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 16).isActive = true
        return icon
    }()
    
    var didTap: (() -> Void)?
    var heightLayoutConstraint: NSLayoutConstraint?
    init(text: String? = "TRY AGAIN") {
        super.init(frame: .zero)
        if let text = text {
            label.text = text
        }
        addGestureRecognizer(UIGestureRecognizer.init(target: self, action: #selector(tapAction)))
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
        heightLayoutConstraint = heightAnchor.constraint(equalToConstant: 32)
        heightLayoutConstraint?.isActive = true
        icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        icon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 0).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
    }
    
    func buildViewHierarchy() {
        addSubview(icon)
        addSubview(label)
    }
    
    func configureViews() {
        translatesAutoresizingMaskIntoConstraints = false
    }

}
