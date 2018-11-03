//
//  FirstViewController.swift
//  VocalKit
//
//  Created by Alexis Soto on 10/29/18.
//  Copyright © 2018 Alexis Soto. All rights reserved.
//

import UIKit
import CsoundiOS

class FirstViewController: UIViewController {
    
    //UI Sliders
    @IBOutlet var HarmonySlider: UISlider!
    @IBOutlet var DistSlider: UISlider!
    
    @IBOutlet var FilterSlider: UISlider!
    @IBOutlet var ReverbSlider: UISlider!
    @IBOutlet var VolumeSlider: UISlider!
    
    // UI Labels
    @IBOutlet var HarmonyValue: UILabel!
    @IBOutlet var DistValue: UILabel!
    
    @IBOutlet var FilterValue: UILabel!
    @IBOutlet var ReverbValue: UILabel!
    @IBOutlet var VolumeValue: UILabel!
    
    //UI Switch
    @IBOutlet var VSlider: UISwitch!
    
    //Pointers
    
    var verbPtr: UnsafeMutablePointer<Float>? //Define pointer.
    var harPtr: UnsafeMutablePointer<Float>?
    var disPtr: UnsafeMutablePointer<Float>?
    var levlPtr: UnsafeMutablePointer<Float>?
    var filtPtr: UnsafeMutablePointer<Float>?
    
    var verb: Float = 0
    var harmony: Float = 0
    var volume: Float = 0
    var dist: Float = 0
    var filt: Float = 0
    
    let csound = SharedInstances.csound
    var csoundUI: CsoundUI!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        csoundUI = CsoundUI(csoundObj: csound)
        csound.addBinding(self)
        
        csound.useAudioInput = true
        
        csound.play(Bundle.main.path(forResource:"VocalHarmonizer", ofType: "csd"))
        
        [VolumeSlider, HarmonySlider, ReverbSlider, DistSlider, FilterSlider].forEach { ValueChanged($0) }

        VolumeSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))
        
        view.backgroundColor = UIColor.lightGray
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        csound.sendScore("i-1 0 1")
        csound.sendScore("i-100 0 1")
    }
    
    @IBAction func OnOff(_ sender:UISwitch){
        if VSlider.isOn == false{
            csound.sendScore("i-1 0 1")
            csound.sendScore("i-100 0 1")
        }else{
            csound.sendScore("i1 0.1 -1")
            csound.sendScore("i100 0 -1")
        }
    }
    
    lazy var sliderToLabel: [UISlider: UILabel] = [HarmonySlider: HarmonyValue,
                                                   VolumeSlider: VolumeValue,
                                                   DistSlider: DistValue,
                                                   FilterSlider: FilterValue,
                                                   ReverbSlider: ReverbValue]
    
    @IBAction func ValueChanged(_ sender: UISlider){
        if let label = sliderToLabel[sender] {
            label.text = String(format: "%.2f", sender.value)
        }
        switch sender{
        case ReverbSlider: verb = sender.value
        case HarmonySlider: harmony = sender.value
        case VolumeSlider: volume = sender.value
        case DistSlider: dist = sender.value
        case FilterSlider: filt = sender.value
        default:
            break
        }
    }
    
}

extension FirstViewController: CsoundBinding {
    func setup(_ csoundObj: CsoundObj) {
        verbPtr = csoundObj.getInputChannelPtr("reverb", channelType: CSOUND_CONTROL_CHANNEL)
        harPtr = csoundObj.getInputChannelPtr("harmony", channelType: CSOUND_CONTROL_CHANNEL)
        levlPtr = csoundObj.getInputChannelPtr("volume", channelType: CSOUND_CONTROL_CHANNEL)
        disPtr = csoundObj.getInputChannelPtr("distortion", channelType: CSOUND_CONTROL_CHANNEL)
        filtPtr = csoundObj.getInputChannelPtr("ratio", channelType: CSOUND_CONTROL_CHANNEL)
    }
    
    func updateValuesToCsound() {
        verbPtr?.pointee = verb
        harPtr?.pointee = harmony
        levlPtr?.pointee = volume
        disPtr?.pointee = dist
        filtPtr?.pointee = filt
    }
}



