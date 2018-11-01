//
//  FirstViewController.swift
//  VocalKit
//
//  Created by Alexis Soto on 10/29/18.
//  Copyright © 2018 Alexis Soto. All rights reserved.
//

import UIKit
import CsoundiOS
import AVFoundation

class FirstViewController: UIViewController {
    
    //UI Sliders
    @IBOutlet var HarmonySlider: UISlider!
    @IBOutlet var FilterSlider: UISlider!
    @IBOutlet var ReverbSlider: UISlider!
    @IBOutlet var VolumeSlider: UISlider!
    @IBOutlet var DistortionSlider: UISlider!
    
    // UI Labels
    @IBOutlet var HarmonyValue: UILabel!
    @IBOutlet var FilterValue: UILabel!
    @IBOutlet var ReverbValue: UILabel!
    @IBOutlet var VolumeValue: UILabel!
    @IBOutlet var DistortionValue: UILabel!
    
    //UI Switch
    @IBOutlet var VSlider: UISwitch!
    
    //Pointers
    
    var verbPtr: UnsafeMutablePointer<Float>? //Define pointer.
    var harPtr: UnsafeMutablePointer<Float>?
    var levlPtr: UnsafeMutablePointer<Float>?
    var distPtr: UnsafeMutablePointer<Float>?
    
    var verb: Float = 0
    var harmony: Float = 0
    var volume: Float = 0
    var dist: Float = 0
    
    let csound = SharedInstances.csound
    var csoundUI: CsoundUI!
    
    lazy var sliderToLabel: [UISlider: UILabel] = [HarmonySlider: HarmonyValue,
                                                   VolumeSlider: VolumeValue,
                                                   FilterSlider: FilterValue,
                                                   DistortionSlider: DistortionValue]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        csoundUI = CsoundUI(csoundObj: csound)
        csound.addBinding(self)
        
        csound.play(Bundle.main.path(forResource:"VocalHarmonizer", ofType: "csd"))
        
        [VolumeSlider, HarmonySlider, ReverbSlider, DistortionSlider].forEach { ValueChanged($0) }

        VolumeSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))
        
        csound.useAudioInput = true
        
        view.backgroundColor = UIColor.lightGray
    }
    
    // Warn user about feedback if headphones are not connected
    func checkForHeadphones() {
        let headphones = headphonesPlugged()
        
        if !headphones {
            let alert = UIAlertController(title:"Feedback Warning!", message:"Without headphones plugged in, you may experience feedback!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title:"OK", style: .default, handler: nil)
            alert.addAction(defaultAction)
            navigationController?.present(alert, animated: true, completion: nil)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        csound.sendScore("i-2 0 1")
        csound.sendScore("i1 0 -1")
    }
    
    @IBAction func ValueChanged(_ sender: UISlider){
        if let label = sliderToLabel[sender] {
            label.text = String (format: "%.2f",sender.value)
        }
    }
    // Return a BOOL signifying whether or not headphones are connected to the current device
    func headphonesPlugged() -> Bool {
        let availableOutputs = AVAudioSession.sharedInstance().currentRoute.outputs
        for out in availableOutputs {
            if out.portType == AVAudioSession.Port.headphones {
                return true
            }
        }
        return false
    }
}

extension FirstViewController: CsoundBinding {
    func setup(_ csoundObj: CsoundObj) {
        verbPtr = csoundObj.getInputChannelPtr("reverb", channelType: CSOUND_CONTROL_CHANNEL)
        harPtr = csoundObj.getInputChannelPtr("harmony", channelType: CSOUND_CONTROL_CHANNEL)
        levlPtr = csoundObj.getInputChannelPtr("volume", channelType: CSOUND_CONTROL_CHANNEL)
        distPtr = csoundObj.getInputChannelPtr("distortion", channelType: CSOUND_CONTROL_CHANNEL)
    }
    
    func updateValuesToCsound() {
        verbPtr?.pointee = verb
        harPtr?.pointee = harmony
        levlPtr?.pointee = volume
        distPtr?.pointee = dist
    }
}



