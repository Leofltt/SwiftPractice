//
//  MIDIPlayer.swift
//  AVMIDIPlayerExample
//
//  Created by Akito van Troyer on 11/13/18.
//  Copyright © 2018 Akito van Troyer. All rights reserved.
//

import Foundation
import AVFoundation

class MIDIFilePlayer {
    var player:AVMIDIPlayer!
    var timer:Timer?
    var viewController:ViewController?
    
    init(viewController:ViewController) {
        self.viewController = viewController
    }
    
    func createAVMIDIPlayerFromMIDIFile(midiFile:String){
        
        
        guard let bankUrl = Bundle.main.url(forResource: "snd/GeneralUser GS v1.471", withExtension: "sf2") else {
            fatalError("\"GeneralUser GS MuseScore v1.442.sf2\" file not found.") //Using url because AVMIDIplayer requires url.
        }
        
        let midiUrl = URL(string: midiFile.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)
        
        do {
            try self.player = AVMIDIPlayer(contentsOf: midiUrl!, soundBankURL: bankUrl)
            print("created midi player with sound bank url \(bankUrl)")
        } catch let error as NSError {
            print("Error \(error.localizedDescription)")
        }
        
        player.prepareToPlay()
        player.rate = 1.0
        
        print("Duration: \(player.duration)")
    }
    
    func play() {
        startTimer()
        player.play({
            print("finished")
            self.player.currentPosition = 0
            self.timer?.invalidate()
            self.viewController?.reset() //We have to refference the ViewControler so it can restart the whole thing.
        })
    }
    
    func stop() {
        if player.isPlaying {
            player.stop()
            timer?.invalidate()
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.1,
                                                       target:self,
                                                       selector: #selector(self.updateTime),
                                                       userInfo:nil,
                                                       repeats:true)
    }
    
    @objc func updateTime() {
        print("\(player.currentPosition)")
    }
}
