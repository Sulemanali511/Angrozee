//
//  KAudioRecorder
//
//  Copyright © 2017 Kenan Atmaca. All rights reserved.
//  kenanatmaca.com
//
//

import UIKit
import AVFoundation

class KAudioRecorder: NSObject {
    
    
    static var shared = KAudioRecorder()
    
    private var audioSession:AVAudioSession = AVAudioSession.sharedInstance()
    private var audioRecorder:AVAudioRecorder!
    //private var audioPlayer:AVAudioPlayer = AVAudioPlayer()
    private var audioPlayer:AVAudioPlayer!
    private let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
    fileprivate var timer:Timer!
    
    var isPlaying:Bool = false
    var isRecording:Bool = false
    var url:URL?
    var time:Int = 0
    var recordName:String?
    
    override init() {
        super.init()
        
        isAuth()
    }
    
    private func recordSetup() {
        
        let newVideoName = getDir().appendingPathComponent(recordName?.appending(".m4a") ?? "sound.m4a")
        
        do {
            
            if #available(iOS 10.0, *) {
               // try! AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: AVAudioSession.Mode.default)
               try! audioSession.setCategory(.playAndRecord, mode: AVAudioSession.Mode.default)
            }
            else {
                // Workaround until https://forums.swift.org/t/using-methods-marked-unavailable-in-swift-4-2/14949 isn't fixed
                AVAudioSession.sharedInstance().perform(NSSelectorFromString("setCategory:error:"), with: AVAudioSession.Category.playback)
            }
            
            audioRecorder = try AVAudioRecorder(url: newVideoName, settings: self.settings)
            audioRecorder.delegate = self as AVAudioRecorderDelegate
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
            
        } catch {
            print("Recording update error:",error.localizedDescription)
        }
    }
    
    func record() {
        
        recordSetup()
        
        if let recorder = self.audioRecorder {
            if !isRecording {
                
                do {
                    try audioSession.setActive(true)
                    
                    time = 0
                    timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
                    
                    recorder.record()
                    isRecording = true
                    
                } catch {
                    print("Record error:",error.localizedDescription)
                }
            }
        }
    }
    
    @objc private func updateTimer() {
        
        if isRecording && !isPlaying {
            
            time += 1
            
        } else {
            timer.invalidate()
        }
    }
    
    func stop() {
        
        audioRecorder.stop()
        
        do {
            try audioSession.setActive(false)
        } catch {
            print("stop()",error.localizedDescription)
        }
    }
    
    func play() {
        
        if !isRecording && !isPlaying {
            if let recorder = self.audioRecorder  {
                
                if recorder.url.path == url?.path && url != nil {
                    audioPlayer.play()
                    return
                }
                
                do {
                    try! audioSession.setCategory(.playAndRecord, mode: AVAudioSession.Mode.default)
                    try audioSession.setActive(true)

                    audioPlayer = try AVAudioPlayer(contentsOf: recorder.url)
                    audioPlayer.delegate = self as AVAudioPlayerDelegate
                    url = audioRecorder.url
                   // audioPlayer.prepareToPlay()
                    audioPlayer.play()
                    
                } catch {
                    print("play(), ",error.localizedDescription)
                }
            }
            
        } else {
            return
        }
    }
    
    func playSound(filepath:String){
        do {
            //            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: music! ))
            try! audioSession.setCategory(AVAudioSession.Category.ambient)
            try audioSession.setActive(true)

            let url = URL(fileURLWithPath: filepath)
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.volume = 1
            audioPlayer.delegate = self as AVAudioPlayerDelegate
            audioPlayer.play()
            
        } catch {
            print("play(with name:), ",error.localizedDescription)
        }
    }
    func play(name:String) {
        
        //        let bundle = getDir().appendingPathComponent(name.appending(".m4a"))
        let bundle = getDir().appendingPathComponent(name)
        //
        
        if FileManager.default.fileExists(atPath: bundle.path) && !isRecording && !isPlaying {
            
            do {
                
                //try! audioSession.setCategory(.playAndRecord, mode: AVAudioSession.Mode.default)
                try! audioSession.setCategory(.playAndRecord)

                try audioSession.setActive(true)

                isPlaying = true
                
                audioPlayer = try AVAudioPlayer(contentsOf: bundle)
                audioPlayer.volume = 1
                audioPlayer.delegate = self as AVAudioPlayerDelegate
              //  audioPlayer.prepareToPlay()
                audioPlayer.play()
                
            } catch {
                print("play(with name:), ",error.localizedDescription)
                isPlaying = false

            }
            
        } else {
            return
        }
    }
    
    func delete(name:String) {
        
        let bundle = getDir().appendingPathComponent(name.appending(".m4a"))
        let manager = FileManager.default
        
        if manager.fileExists(atPath: bundle.path) {
            
            do {
                try manager.removeItem(at: bundle)
            } catch {
                print("delete()",error.localizedDescription)
            }
            
        } else {
            print("File is not exist.")
        }
    }
    
    func stopPlaying() {
        
        audioPlayer.stop()
        isPlaying = false
    }
    
    func getDir() -> URL {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths.first ?? URL(fileURLWithPath: "")
    }
    
    @discardableResult
    func isAuth() -> Bool {
        
        do {
            //try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            
            if #available(iOS 11.0, *) {
                try! AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback)
                //                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                
            }
            else {
                // Workaround until https://forums.swift.org/t/using-methods-marked-unavailable-in-swift-4-2/14949 isn't fixed
                AVAudioSession.sharedInstance().perform(NSSelectorFromString("setCategory:error:"), with: AVAudioSession.Category.playback)
            }
            
        }
        catch {
            // report for an error
        }
        
        var result:Bool = false
        
        AVAudioSession.sharedInstance().requestRecordPermission { (res) in
            result = res == true ? true : false
        }
        
        return result
    }
    
    func getAudioDuration(path:URL) -> String{
        
        let duration = AVURLAsset(url: path).duration.seconds
        
        let time: String
        if duration > 3600 {
            time = String(format:"%02i:%02i:%02i",
                          Int(duration/3600),
                          Int((duration/60).truncatingRemainder(dividingBy: 60)),
                          Int(duration.truncatingRemainder(dividingBy: 60)))
        } else {
            //   return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
            
            time = String(format:"%02i:%02i",
                          Int((duration/60).truncatingRemainder(dividingBy: 60)),
                          Int(duration.truncatingRemainder(dividingBy: 60)))
        }
        return time
        //        let audioAsset = AVURLAsset.init(url: path, options: nil)
        //        let duration = audioAsset.duration
        //        let durationInSeconds = CMTimeGetSeconds(duration)
        //        return String(durationInSeconds)
    }
    func getTime() -> String {
        
        var result:String = ""
        
        if time < 60 {
            
            result = "\(time)"
            
        } else if time >= 60 {
            
            result = "\(time / 60):\(time % 60)"
        }
        
        return result
    }
    
}//

extension KAudioRecorder: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        isRecording = false
        url = nil
        timer.invalidate()
        print("record finish")
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print(error.debugDescription)
    }
}

extension KAudioRecorder: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        print("playing finish")
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print(error.debugDescription)
    }
}
