//
//  AudioPlayer.swift
//  PhonoCam
//
//  Created by Akito van Troyer on 11/26/18.
//  Copyright © 2018 Akito van Troyer. All rights reserved.
//

import Foundation
import AVFoundation

class AudioPlayer: NSObject {
    
    var player:AVAudioPlayer!
    
    func setup(fileURL:URL){
        do {
            try player = AVAudioPlayer(contentsOf: fileURL)
            player.delegate = self
            player.prepareToPlay()
            player.volume = 1.0
            player.numberOfLoops = -1 //infinite loop
            player.isMeteringEnabled = true
            player.averagePower(forChannel: 0)
        } catch {
            print("Failed to initialize AVAudioPlayer")
            print(error.localizedDescription)
        }
    }
    
    func setupSession(){
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(.playback, mode: .default, options: .defaultToSpeaker)
        } catch {
            print("Failed to set AVAudioSession")
            print(error.localizedDescription)
        }
        
        do {
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Failed to activate AVAudioSession")
            print(error.localizedDescription)
        }
    }
    
    func play(){
        if(player != nil && !player.isPlaying){
            player.play()
        }
        else {
            print("AVAudioPlayer is nil or busy")
        }
    }
    
    func stop(){
        if(player != nil && player.isPlaying){
            player.stop()
        }
    }
}

extension AudioPlayer: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print(error!)
    }
}
