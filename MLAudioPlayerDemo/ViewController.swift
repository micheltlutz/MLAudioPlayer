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
         let mlAudioPlayer = MLAudioPlayer(urlAudio: "https://assets.cingulo.com/media/resources_file/43e3cb4f-9a81-405a-b6df-63e44b948ec4.mp3",
                                          config: nil,
                                          isLocalFile: false, autoload: false)
        return mlAudioPlayer
    }()

    var mlAudioPlayer2: MLAudioPlayer = {
        let mlAudioPlayer2 = MLAudioPlayer(urlAudio: "https://assets.cingulo.com/media/resources_file/346aacb7-23f7-4db9-b588-43d69d136a02.mp3",
                                          config: nil,
                                          isLocalFile: false, autoload: false)
        return mlAudioPlayer2
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayer()
    }

    private func setupPlayer() {
        view.addSubview(mlAudioPlayer)
        view.addSubview(mlAudioPlayer2)
        NSLayoutConstraint.activate([
            mlAudioPlayer.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            mlAudioPlayer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            mlAudioPlayer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mlAudioPlayer2.topAnchor.constraint(equalTo: mlAudioPlayer.bottomAnchor, constant: 60),
            mlAudioPlayer2.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
//        mlAudioPlayer.loadAudio()
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: .MLAudioPlayerNotification, object: nil,
                                        userInfo: ["action": MLPlayerActions.load])
    }
}
