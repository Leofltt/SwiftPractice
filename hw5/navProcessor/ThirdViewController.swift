//
//  ThirdViewController.swift
//  navProcessor
//
//  Copyright © 2017 Berklee EP-P453. All rights reserved.
//

import UIKit
import CsoundiOS

class ThirdViewController: UIViewController {
    
    // IBOutlets
    @IBOutlet var volSlider: UISlider!
    @IBOutlet var fbSlider: UISlider!
    @IBOutlet var durSlider: UISlider!
    @IBOutlet var rateSlider: UISlider!
    @IBOutlet var pitchSlider: UISlider!
    
    
    // Declarations
    let csound = SharedInstances.csound
    var fbPtr: UnsafeMutablePointer<Float>? //Define pointer.
    var levlPtr: UnsafeMutablePointer<Float>?
    var durPtr: UnsafeMutablePointer<Float>?
    var ratePtr: UnsafeMutablePointer<Float>?
    var pitchPtr: UnsafeMutablePointer<Float>?
    var vol: Float = 0
    var grainFb: Float = 0
    var grainDur: Float = 0
    var grainRate: Float = 0
    var transpose: Float = 0


    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        csound.addBinding(self)
        
        // The .forEach method allows us to quickly perform some process on elements of a collection (denoted by $0, generally)
        // Here we use it to quickly initialize our temp values to whatever the sliders are set to
        [volSlider, fbSlider, durSlider, pitchSlider, rateSlider].forEach { anyValueChanged($0) } //$0 is just a place holder to get whatever comes.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // kill all instruments, turn on granular
        csound.sendScore("i-2.1 0 1")
        csound.sendScore("i-1.1 0 1")
        csound.sendScore("i-3.1 0 1")
        csound.sendScore("i-3.1 0 1")
        csound.sendScore("i4.1  0 -1")
        csound.sendScore("i5.1  0 -1")
        
    }
    
    @IBAction func anyValueChanged(_ sender: UISlider) {
        switch sender {
        case fbSlider: grainFb = sender.value
        case volSlider: vol = sender.value
        case durSlider: grainDur = sender.value
        case pitchSlider: transpose = sender.value
        case rateSlider: grainRate = sender.value
        default: break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// CsoundBinding methods
extension ThirdViewController: CsoundBinding { //CsoundBiding is in the framework.
    func setup(_ csoundObj: CsoundObj) {
        // Setup channel pointers for manual Csound binding
        fbPtr = csoundObj.getInputChannelPtr("grainFb", channelType: CSOUND_CONTROL_CHANNEL)
        pitchPtr = csoundObj.getInputChannelPtr("tranScaling", channelType: CSOUND_CONTROL_CHANNEL)
        ratePtr = csoundObj.getInputChannelPtr("grainRate", channelType: CSOUND_CONTROL_CHANNEL)
        durPtr = csoundObj.getInputChannelPtr("grainDur", channelType: CSOUND_CONTROL_CHANNEL)
        levlPtr = csoundObj.getInputChannelPtr("levl", channelType: CSOUND_CONTROL_CHANNEL)
    }
    
    func updateValuesToCsound() {
        // Update values at channel pointer addresses
        fbPtr?.pointee = grainFb
        levlPtr?.pointee = vol
        durPtr?.pointee = grainDur
        pitchPtr?.pointee = transpose
        ratePtr?.pointee = grainRate
    }
}


