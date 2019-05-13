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

import AVFoundation

/**
 Protocol MLAudioPlayerManagerDelegate
 */
protocol MLAudioPlayerManagerDelegate: class {
    func didUpdateTimer(currentTime: Double, totalDuration: Double)
    func didUpdateProgress(percentage: Int)
    func readyToPlay(currentTime: Double, totalDuration: Double)
    func didPause()
    func didPlay()
    func didError(error: Error)
    func didFinishPlaying()
}

class MLAudioPlayerManager: NSObject{
    ///Define a urlAudio: String
    private var urlAudio: String!
    ///Define a timer: Timer
    private var timer: Timer!
    ///Define a audioPlayer: AVAudioPlayer
    private var audioPlayer: AVAudioPlayer!
    ///Var contains a volume float value
    var volume: Float!
    ///Flag define if audio is downloading
    var isDownloading = false
    ///Contains a int value for percentage of downloaded file audio
    var percentageDownload: Int = 0
    ///Delegate
    var delegate: MLAudioPlayerManagerDelegate?
    /**
     This initializer start configurations for MLAudioPlayerManager
     
     - Parameter urlAudio: String
     - Parameter volume: Float? default value 0.7
     - Parameter isLocalFile: Bool default false
     */
    init(urlAudio: String, volume: Float? = 0.7, isLocalFile: Bool = false) {
        super.init()
        self.urlAudio = urlAudio
        self.volume = volume
        
        if !isLocalFile {
            self.beginDownloadingFile()
        } else {
            // If local file, trying load the file
            guard let url = URL(string: urlAudio) else {
                let errorURL = NSError(domain: "", code: 0,
                                       userInfo: ["description" : "Ocorreu um erro ao tentar carregar o arquivo especificado."])
                delegate?.didError(error: errorURL)
                return
            }
            
            self.preparePlayer(url: url)
        }
    }
    /**
     This function configure AVAudioSession, create instance of AVAudioPlayer and configure this with volume and url Audio from initializer
     
     - Parameter url: URL
     */
    private func preparePlayer(url: URL) {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .default)
            try audioSession.setActive(true)
            let soundData = try Data(contentsOf: url)
            audioPlayer = try AVAudioPlayer(data: soundData)
            audioPlayer.prepareToPlay()
            audioPlayer.volume = volume
            delegate?.readyToPlay(currentTime: audioPlayer.currentTime, totalDuration: audioPlayer.duration)
        } catch {
            delegate?.didError(error: error)
        }
    }
    /**
     This function start a download audio file
     */
    private func beginDownloadingFile(){
        let configuration = URLSessionConfiguration.ephemeral
        let operationQueue = OperationQueue()
        let urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
        guard let url = URL(string: self.urlAudio) else { return }
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
    }
    /**
     This function play audio
     */
    open func play() {
        audioPlayer.play()
        startTimer()
        delegate?.didPlay()
    }
    /**
     This function pause audio
     */
    open func pause() {
        audioPlayer.pause()
        delegate?.didPause()
    }
    /**
     This function reset audio
     */
    open func reset() {
        audioPlayer.pause()
        timer.invalidate()
        timer = nil
        delegate?.didFinishPlaying()
    }
    /**
     This function stop audio session
     */
    open func stop() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch {
            print("ERROR STOP: setActive",error.localizedDescription)
        }
    }
    /**
     This function restart download file
     */
    open func tryAgain() {
        self.beginDownloadingFile()
    }
    /**
     This function recieve a float value to current time audioplayer
     
     - Parameter to value: Float
     */
    open func trackNavigation(to value: Float){
        audioPlayer.currentTime = Double(value)
    }
    /**
     This function star a Timer schedule
     */
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            self.delegate?.didUpdateTimer(currentTime: self.audioPlayer.currentTime, totalDuration: self.audioPlayer.duration)
        })
    }
}

extension MLAudioPlayerManager: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let percentage = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        DispatchQueue.main.sync {
            self.percentageDownload = Int(percentage * 100)
            self.delegate?.didUpdateProgress(percentage: self.percentageDownload)
        }
    }
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        isDownloading = false
        preparePlayer(url: location)
    }
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        if let error = error {
            self.delegate?.didError(error: error)
        }
    }
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            self.delegate?.didError(error: error)
        }
    }
}
