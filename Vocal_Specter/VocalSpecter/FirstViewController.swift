//
//  FirstViewController.swift
//  VocalKit
//
//  Created by Leonardo Foletto on 10/29/18.
//  Copyright © 2018 Leonardo Foletto. All rights reserved.
//

import UIKit
import CsoundiOS

class FirstViewController: UIViewController {
    
    //UI Sliders
    @IBOutlet var blurslider: UISlider!
    
    @IBOutlet var FilterSlider: UISlider!
    @IBOutlet var ReverbSlider: UISlider!
    @IBOutlet var VolumeSlider: UISlider!
    
    // UI Labels
    @IBOutlet var blurvalue: UILabel!
    
    @IBOutlet var FilterValue: UILabel!
    @IBOutlet var ReverbValue: UILabel!
    @IBOutlet var VolumeValue: UILabel!
    
    //UI Switch
    @IBOutlet var VSlider: UISwitch!
    
    //Pointers
    
    var verbPtr: UnsafeMutablePointer<Float>? //Define pointer.
    var blurPtr: UnsafeMutablePointer<Float>?
    var levlPtr: UnsafeMutablePointer<Float>?
    var filtPtr: UnsafeMutablePointer<Float>?
    
    var verb: Float = 0
    var blurAmt: Float = 0
    var volume: Float = 0
    var filt: Float = 0
    
    let csound = SharedInstances.csound
    var csoundUI: CsoundUI!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        csoundUI = CsoundUI(csoundObj: csound)
        csound.addBinding(self)
        
        csound.useAudioInput = true
        
        csound.play(Bundle.main.path(forResource:"Specter", ofType: "csd"))
        
        [VolumeSlider, blurslider, ReverbSlider,  FilterSlider].forEach { ValueChanged($0) }

        VolumeSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))
        
        view.backgroundColor = UIColor.lightGray
    }
    
    override func viewDidAppear(_ animated: Bool){
        csound.sendScore("i3 0 1")
        csound.sendScore("i-2 0 1 0")
    }
    
    @IBAction func OnOff(_ sender:UISwitch){
        if VSlider.isOn == true{
            csound.sendScore("i1 0.1 -1")
            csound.sendScore("i100 0 -1")
        }else{
            csound.sendScore("i-1 0 1")
            csound.sendScore("i-100 0 1")
        }
    }
    
    lazy var sliderToLabel: [UISlider: UILabel] = [blurslider: blurvalue,
                                                   VolumeSlider: VolumeValue,
                                                   FilterSlider: FilterValue,
                                                   ReverbSlider: ReverbValue]
    
    @IBAction func ValueChanged(_ sender: UISlider){
        if let label = sliderToLabel[sender] {
            label.text = String(format: "%.2f", sender.value)
        }
        switch sender{
        case ReverbSlider: verb = sender.value
        case blurslider: blurAmt = sender.value
        case VolumeSlider: volume = sender.value
        case FilterSlider: filt = sender.value
        default:
            break
        }
    }
    
}

extension FirstViewController: CsoundBinding {
    func setup(_ csoundObj: CsoundObj) {
        verbPtr = csoundObj.getInputChannelPtr("reverb", channelType: CSOUND_CONTROL_CHANNEL)
        blurPtr = csoundObj.getInputChannelPtr("blurAmt", channelType: CSOUND_CONTROL_CHANNEL)
        levlPtr = csoundObj.getInputChannelPtr("volume", channelType: CSOUND_CONTROL_CHANNEL)
        filtPtr = csoundObj.getInputChannelPtr("ratio", channelType: CSOUND_CONTROL_CHANNEL)
    }

    func updateValuesToCsound() {
        verbPtr?.pointee = verb
        blurPtr?.pointee = blurAmt
        levlPtr?.pointee = volume
        filtPtr?.pointee = filt
    }
}



