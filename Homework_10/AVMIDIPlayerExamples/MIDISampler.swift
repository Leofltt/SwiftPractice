//
//  MIDISampler.swift
//  AVMIDIPlayerExample
//
//  Created by Akito van Troyer on 11/13/18.
//  Copyright © 2018 Akito van Troyer. All rights reserved.
//

import Foundation
import AVFoundation

class MIDISampler {
    
    var engine:AVAudioEngine!
    var sampler:AVAudioUnitSampler! //Sampler for FREE
    
    var reverb:  AVAudioUnitReverb!
    
    var pitch: AVAudioUnitTimePitch!

    //0x79 for melodic instruments and 0x78 for percussion instruments
    let melodicBank = UInt8(kAUSampler_DefaultMelodicBankMSB)
    let defaultBankLSB = UInt8(kAUSampler_DefaultBankLSB)
    
    /// general midi number for marimba
    let gmMarimba = UInt8(12)
    let gmHarpsichord = UInt8(6)
    
    init(){
        
        engine = AVAudioEngine()
        sampler = AVAudioUnitSampler()
        reverb = AVAudioUnitReverb()
        pitch = AVAudioUnitTimePitch()
        
        reverb.loadFactoryPreset(.plate)
        
        engine.attach(reverb)
        engine.attach(sampler)
        engine.attach(pitch)
        
        engine.connect(sampler, to: engine.mainMixerNode, format: nil)
        engine.connect(sampler, to: reverb, format: nil)
        engine.connect(reverb, to: engine.mainMixerNode, format: nil)

        //Why is it like this? Is not sending paralel?
        engine.connect(reverb, to: pitch, format: nil)
        engine.connect(pitch, to: engine.mainMixerNode, format: nil)
        
        start()
    }
    
    func start(){
        if engine.isRunning {
            print("audio engine already started")
            return
        }
        
        do {
            try engine.start()
            print("audio engine started")
        } catch {
            print("oops \(error)")
            print("could not start audio engine")
        }
    }
    
    func stop(){
        if !engine.isRunning {
            print("Audio engine is not running")
            return
        }
        
        engine.stop()
    }
    
    func noteOn(note:UInt8,velocity:UInt8) {
        sampler.startNote(note, withVelocity: velocity, onChannel: 0)
    }
    
    func noteOff(note:UInt8) {
        sampler.stopNote(note, onChannel: 0)
    }
    
    func loadPatch(gmPatch: UInt8, channel: UInt8 = 0) {
        guard let soundBank = Bundle.main.url(forResource: "snd/GeneralUser GS v1.471", withExtension: "sf2") else {
            fatalError("\"GeneralUser GS MuseScore v1.442.sf2\" file not found.")
        }
        
        do {
            try sampler.loadSoundBankInstrument(at: soundBank, program:gmPatch,
                                                     bankMSB: melodicBank, bankLSB: defaultBankLSB)
            
        } catch let error as NSError {
            print("\(error.localizedDescription)")
            return
        }
        
        self.sampler.sendProgramChange(gmPatch, bankMSB: melodicBank, bankLSB: defaultBankLSB, onChannel: channel)
    }
}
