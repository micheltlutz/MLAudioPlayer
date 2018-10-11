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
    private var urlAudio: String!
    private var timer: Timer!
    private var audioPlayer: AVAudioPlayer!
    var volume: Float!
    var isDownloading = false
    var percentageDownload: Int = 0
    var delegate: MLAudioPlayerManagerDelegate?
    init(urlAudio: String, volume: Float? = 0.7) {
        super.init()
        self.urlAudio = urlAudio
        self.volume = volume
        self.beginDownloadingFile()
    }
    private func preparePlayer(url: URL) {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            let soundData = try Data(contentsOf: url)
            audioPlayer = try AVAudioPlayer(data: soundData)
            audioPlayer.prepareToPlay()
            audioPlayer.volume = volume
            delegate?.readyToPlay(currentTime: audioPlayer.currentTime, totalDuration: audioPlayer.duration)
        } catch {
            delegate?.didError(error: error)
        }
    }
    private func beginDownloadingFile(){
        let configuration = URLSessionConfiguration.ephemeral
        let operationQueue = OperationQueue()
        let urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
        guard let url = URL(string: self.urlAudio) else { return }
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
    }
    open func play() {
        audioPlayer.play()
        startTimer()
        delegate?.didPlay()
    }
    open func pause() {
        audioPlayer.pause()
        timer.invalidate()
        delegate?.didPause()
    }
    open func reset() {
        audioPlayer.pause()
        timer.invalidate()
        timer = nil
        self.delegate?.didFinishPlaying()
    }
    open func tryAgain() {
        self.beginDownloadingFile()
    }
    open func trackNavigation(to value: Float){
        audioPlayer.currentTime = Double(value)
    }
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
