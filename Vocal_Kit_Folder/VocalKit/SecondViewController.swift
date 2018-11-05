//
//  SecondViewController.swift
//  VocalKit
//
//  Created by Alexis Soto on 10/29/18.
//  Copyright © 2018 Alexis Soto. All rights reserved.
//

import UIKit
import CsoundiOS
import AVFoundation

class SecondViewController: UIViewController {


    @IBOutlet var reverbSlider: UISlider!
    @IBOutlet var volumeSlider: UISlider!
    @IBOutlet var compSlider: UISlider!
    
    @IBOutlet var volValue: UILabel!
    @IBOutlet var verbValue: UILabel!
    @IBOutlet var compValue: UILabel!
    
    @IBOutlet var OnOffSwitch: UISwitch!
    
    @IBOutlet var statusLabel: UILabel!
    
    //Buttons
    @IBOutlet var RecordButton: UIButton!
    @IBOutlet var PlayButton: UIButton!
    @IBOutlet var StopButton: UIButton!
    
    //Pointers
    var reverbPtr: UnsafeMutablePointer<Float>?
    var levelPtr: UnsafeMutablePointer<Float>?
    var compPtr: UnsafeMutablePointer<Float>?
    
    var reverb: Float = 0
    var level: Float = 0
    var comp: Float = 0
    
    let csound = SharedInstances.csound
    var csoundUI: CsoundUI!
    
    //Declarations
    var Recorded = false
    var Player = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        
        csoundUI = CsoundUI(csoundObj: csound)
        csound.addBinding(self)
        
        csound.useAudioInput = true
        
        csound.play(Bundle.main.path(forResource:"VocalHarmonizer", ofType: "csd"))
        
        
        [volumeSlider, reverbSlider, compSlider].forEach { ValueChanged($0) }
        
        volumeSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))
        reverbSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))
        compSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        csound.sendScore("i-1 0 1")
        csound.sendScore("i-100 0 1")
    }
    
    @IBAction func OnOff1(_ sender: UISwitch){
        if OnOffSwitch.isOn == true {
            csound.sendScore("i2 0 -1")
            csound.sendScore("i101 0 -1")
        }else{
            csound.sendScore("i-2 0 1")
            csound.sendScore("i-101 0 1")
        }
    }
    
    lazy var sliderToLabel1: [UISlider: UILabel] = [reverbSlider: verbValue, volumeSlider: volValue, compSlider: compValue]
    
    @IBAction func ValueChanged(_ sender: UISlider){
        if let label = sliderToLabel1[sender] {
            label.text = String(format: "%.2f", sender.value)
        }
        switch sender{
        case volumeSlider: level = sender.value
        case reverbSlider: reverb = sender.value
        case compSlider: comp = sender.value
        default:
            break
        }
    }
    
    func recordingURL() -> URL {
        let docDirPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return docDirPath.appendingPathComponent("Recorded.wav")
    }
    
    @IBAction func startRecording(_ sender: UIButton){
        csound.record(to: recordingURL())
        statusLabel.text = String("Recording...")
    }
    
    @IBAction func stopRecording(_ sender: UIButton){
        csound.stopRecording()
        do {
            Player = try AVAudioPlayer(contentsOf: recordingURL())
        } catch {
            print(error.localizedDescription)
            }
        
        Recorded = true
        statusLabel.text = String("Recording stopped")
        }
    
    @IBAction func Playback(_ sender: UIButton){
        if Recorded {
            Player.prepareToPlay()
            Player.play()
        }
        statusLabel.text = String("Playing back")
    }
}

extension SecondViewController: CsoundBinding{
    func setup(_ csoundObj: CsoundObj) {
        reverbPtr = csoundObj.getInputChannelPtr("reverb1", channelType: CSOUND_CONTROL_CHANNEL)
        levelPtr = csoundObj.getInputChannelPtr("gain", channelType: CSOUND_CONTROL_CHANNEL)
        compPtr = csoundObj.getInputChannelPtr("comp", channelType: CSOUND_CONTROL_CHANNEL)
    }
    
    func updateValuesToCsound() {
        reverbPtr?.pointee = reverb
        levelPtr?.pointee = level
        compPtr?.pointee = comp
    }
}


