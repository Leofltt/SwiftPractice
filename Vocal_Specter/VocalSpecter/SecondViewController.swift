//
//  SecondViewController.swift
//  VocalKit
//
//  Created by Alexis Soto on 10/29/18.
//  Copyright © 2018 Leonardo Foletto. All rights reserved.
//

import UIKit
import CsoundiOS
import AVFoundation

class SecondViewController: UIViewController {


    @IBOutlet var volumeSlider: UISlider!
    @IBOutlet var filtSlider: UISlider!
    
    @IBOutlet var volValue: UILabel!
    @IBOutlet var filtValue: UILabel!
    
    @IBOutlet var frzSwitch: UISwitch!
    
    @IBOutlet var statusLabel: UILabel!
    
    //Buttons
    @IBOutlet var RecordButton: UIButton!
    @IBOutlet var PlayButton: UIButton!
    @IBOutlet var StopButton: UIButton!
    
    //Pointers
    var levelPtr: UnsafeMutablePointer<Float>?
    var filtPtr: UnsafeMutablePointer<Float>?
    
    var level: Float = 0
    var filt: Float = 0
    
    let csound = SharedInstances.csound
    var csoundUI: CsoundUI!
    
    //Declarations
    var Recorded = false
    var Player = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.lightGray
        
        csoundUI = CsoundUI(csoundObj: csound)
        csound.addBinding(self)
        
        csound.useAudioInput = true
        
        csound.play(Bundle.main.path(forResource:"Specter", ofType: "csd"))
        
        
        [volumeSlider, filtSlider].forEach { ValueChanged($0) }
        
        volumeSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))
        filtSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        csound.sendScore("i3 0 1")
        csound.sendScore("i-1 0 1")
        csound.sendScore("i2 0 -1 0")
        csound.sendScore("i100 0 -1")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        csound.stopRecording()  // just for safety
        statusLabel.text = ""
    }
    
    @IBAction func OnOff1(_ sender: UISwitch){
        if frzSwitch.isOn == true {
             csound.sendScore("i2 0 1  0")
             csound.sendScore("i2 0 -1 1")
        }else{
             csound.sendScore("i-2 0 1 1")
             csound.sendScore("i2 0 -1  0")
       }
    }
    
    lazy var sliderToLabel1: [UISlider: UILabel] = [ volumeSlider: volValue, filtSlider: filtValue]
     
    @IBAction func ValueChanged(_ sender: UISlider){
        if let label = sliderToLabel1[sender] {
            label.text = String(format: "%.2f", sender.value)
        }
        switch sender{
        case volumeSlider: level = sender.value
        case filtSlider: filt = sender.value
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
        statusLabel.text = "Recording..."
    }
    
    @IBAction func stopRecording(_ sender: UIButton){
        csound.stopRecording()
        do {
            Player = try AVAudioPlayer(contentsOf: recordingURL())
        } catch {
            print(error.localizedDescription)
            }
        
        Recorded = true
        statusLabel.text = "Recording stopped"
        }
    
    @IBAction func Playback(_ sender: UIButton){
        if Recorded {
            Player.prepareToPlay()
            Player.enableRate = true
            Player.rate = 2.0 // the player was playing half of the speed so we make it twice as fast
            Player.play()
        }
        statusLabel.text = "Playing back"
    }
}

extension SecondViewController: CsoundBinding{
    func setup(_ csoundObj: CsoundObj) {
        levelPtr = csoundObj.getInputChannelPtr("gain", channelType: CSOUND_CONTROL_CHANNEL)
        filtPtr = csoundObj.getInputChannelPtr("filt", channelType: CSOUND_CONTROL_CHANNEL)
    }
    
    func updateValuesToCsound() {
        levelPtr?.pointee = level
        filtPtr?.pointee = filt
    }
}


