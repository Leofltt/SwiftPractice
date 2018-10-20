//
//  FirstViewController.swift
//  navProcessor
//
//  Copyright © 2017 Berklee EP-P453. All rights reserved.
//

import UIKit
import CsoundiOS

class FirstViewController: UIViewController {
    
    // IBOutlets
    @IBOutlet var volSlider: UISlider!
    @IBOutlet var verbSlider: UISlider!
    @IBOutlet var distSlider: UISlider!
    
    // Declarations
    let csound = SharedInstances.csound
    var verbPtr: UnsafeMutablePointer<Float>? //Define pointer.
    var distPtr: UnsafeMutablePointer<Float>?
    var levlPtr: UnsafeMutablePointer<Float>?
    var verb: Float = 0
    var dist: Float = 0
    var vol: Float = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.lightGray
        
        csound.addBinding(self)
        
        // The .forEach method allows us to quickly perform some process on elements of a collection (denoted by $0, generally)
        // Here we use it to quickly initialize our temp values to whatever the sliders are set to
        [volSlider, verbSlider, distSlider].forEach { anyValueChanged($0) } //$0 is just a place holder to get whatever comes.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Start corresponding instrument and stop the other instrument if it is running
        csound.sendScore("i-2.1 0 1") //Second instrument is quiet when first one is on!
        csound.sendScore("i-3.1 0 1")
        csound.sendScore("i1.1 0 -1")
        csound.sendScore("i-4.1 0 1")
        csound.sendScore("i-5.1 0 1")
    }
    
    @IBAction func anyValueChanged(_ sender: UISlider) {
        switch sender {
        case verbSlider: verb = sender.value
        case distSlider: dist = sender.value
        case volSlider: vol = sender.value
        default: break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// CsoundBinding methods
extension FirstViewController: CsoundBinding { //CsoundBiding is in the framework.
    func setup(_ csoundObj: CsoundObj) {
        // Setup channel pointers for manual Csound binding
        verbPtr = csoundObj.getInputChannelPtr("verb", channelType: CSOUND_CONTROL_CHANNEL)
        distPtr = csoundObj.getInputChannelPtr("dist", channelType: CSOUND_CONTROL_CHANNEL)
        levlPtr = csoundObj.getInputChannelPtr("levl", channelType: CSOUND_CONTROL_CHANNEL)
    }
    
    func updateValuesToCsound() {
        // Update values at channel pointer addresses
        verbPtr?.pointee = verb
        distPtr?.pointee = dist
        levlPtr?.pointee = vol
    }
}
