//
//  SecondViewController.swift
//  VocalKit
//
//  Created by Alexis Soto on 10/29/18.
//  Copyright © 2018 Alexis Soto. All rights reserved.
//

import UIKit
import CsoundiOS

class SecondViewController: UIViewController {


    @IBOutlet var reverbSlider: UISlider!
    @IBOutlet var volumeSlider: UISlider!
    @IBOutlet var compSlider: UISlider!
    
    @IBOutlet var volValue: UILabel!
    @IBOutlet var verbValue: UILabel!
    @IBOutlet var compValue: UILabel!
    
    @IBOutlet var OnOffSwitch: UISwitch!
    
    //Pointers
    var reverbPtr: UnsafeMutablePointer<Float>?
    var levelPtr: UnsafeMutablePointer<Float>?
    
    var reverb: Float = 0
    var level: Float = 0
    
    let csound = SharedInstances.csound
    var csoundUI: CsoundUI!
    
    var verb: Float = 0
    var volume: Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        
        csoundUI = CsoundUI(csoundObj: csound)
        csound.addBinding(self)
        
        csound.useAudioInput = true
        
        csound.play(Bundle.main.path(forResource:"VocalHarmonizer", ofType: "csd"))
        
        
        [volumeSlider, reverbSlider].forEach { ValueChanged($0) }
        
        volumeSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))
        reverbSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))
        compSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        csound.sendScore("i-1 0 1")
        csound.sendScore("i-100 0 1")
    }
    
    @IBAction func OnOff1(_ sender: UISwitch){
        if OnOffSwitch.isOn == false {
            csound.sendScore("i-2 0 1")
            csound.sendScore("i-101 0 1")
        }else{
            csound.sendScore("i2 0 -1")
            csound.sendScore("i101 0 -1")
        }
    }
    
    @IBAction func ValueChanged(_ sender: UISlider){
        switch sender{
        case volumeSlider: level = sender.value
        case reverbSlider: reverb = sender.value
        default:
            break
        }
    }
}

extension SecondViewController: CsoundBinding{
    func setup(_ csoundObj: CsoundObj) {
        reverbPtr = csoundObj.getInputChannelPtr("reverb1", channelType: CSOUND_CONTROL_CHANNEL)
        levelPtr = csoundObj.getInputChannelPtr("gain", channelType: CSOUND_CONTROL_CHANNEL)
    }
    
    func updateValuesToCsound() {
        reverbPtr?.pointee = reverb
        levelPtr?.pointee = level
    }
}


