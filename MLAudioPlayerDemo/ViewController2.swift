//
//  ViewController2.swift
//  MLAudioPlayerDemo
//
//  Created by Michel Anderson Lutz Teixeira on 12/06/19.
//  Copyright © 2019 micheltlutz. All rights reserved.
//

import UIKit
import MLAudioPlayer

class ViewController2: UIViewController {
    var mlAudioPlayer: MLAudioPlayer = {

//        http://www.bensound.org/bensound-music/bensound-dubstep.mp3
        let mlAudioPlayer = MLAudioPlayer(urlAudio: "https://protettordelinks.com/wp-content/baixar/RockyBalboa_www.toquesengracadosmp3.com.mp3",
                                          config: nil,
                                          isLocalFile: false, autoload: false)
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

    override func viewWillAppear(_ animated: Bool) {
        //        mlAudioPlayer.loadAudio()
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: .MLAudioPlayerNotification, object: nil,
                                        userInfo: ["action": MLPlayerActions.load])
    }
}
