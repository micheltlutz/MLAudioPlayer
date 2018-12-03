//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport
import MLAudioPlayer
import PlaygroundSupport

// Define if audio is stream or local file
let isStreamAudio = false

class StreamAudioViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        
        let player = MLAudioPlayer(urlAudio: "http://frogstar.com/wp-content/uploads/2012/mp3/boom.mp3")
        
        player.frame = CGRect(x: 0, y: 50, width: 100, height: 100)
        
        view.addSubview(player)
        self.view = view
    }
}

class LocalStreamAudioViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        
        guard let localPath = Bundle.main.url(forResource: "tada", withExtension: "mp3") else {
            print("file not found")
            return
        }
        
        let player = MLAudioPlayer(urlAudio: localPath.absoluteString, isLocalFile: true)
        
        player.frame = CGRect(x: 0, y: 50, width: 100, height: 100)
        
        view.addSubview(player)
        self.view = view
    }
}

if isStreamAudio {
    // Stream audio
    PlaygroundPage.current.liveView = StreamAudioViewController()
} else {
    // Local file
    PlaygroundPage.current.liveView = LocalStreamAudioViewController()
}
