//
//  ViewController.swift
//  MLAudioPlayerDemo
//
//  Created by Michel Anderson Lutz Teixeira on 10/05/19.
//  Copyright © 2019 micheltlutz. All rights reserved.
//

import UIKit
import MLAudioPlayer

class ViewController: UIViewController {

    var mlAudioPlayer: MLAudioPlayer = {
        let mlAudioPlayer = MLAudioPlayer(urlAudio: "http://www.bensound.org/bensound-music/bensound-dubstep.mp3")
        return mlAudioPlayer
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayer()
    }

    private func setupPlayer() {
        view.addSubview(mlAudioPlayer)
        NSLayoutConstraint.activate([
            mlAudioPlayer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mlAudioPlayer.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
