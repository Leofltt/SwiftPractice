//  SecondViewController.swift
//  navProcessor
//
//  Copyright © 2017 Berklee EP-P453. All rights reserved.
//

import UIKit
import CsoundiOS

class SecondViewController: UIViewController {
    
    // IBOutlets
    @IBOutlet var xyPad: XYPad!
    @IBOutlet var volSlider: UISlider!
    
    // Declarations
    let csound = SharedInstances.csound
    var crossPtr: UnsafeMutablePointer<Float>?
    var filtrPtr: UnsafeMutablePointer<Float>?
    var levelPtr: UnsafeMutablePointer<Float>?
    var xloc: Float = 0
    var yloc: Float = 0
    var vol: Float = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.lightGray
        
        // Initialize pan gesture recognizer and add it to xyPad
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:))) //UIPanGestureRecognizer comes with Swift.
        xyPad.addGestureRecognizer(pan)
        
        xloc = 1
        yloc = 10000
        
        csound.addBinding(self)
        levelChanged(volSlider) // Initialize value
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Start corresponding instrument and end other instrument if it's running
        csound.sendScore("i-1.1 0 1")
        csound.sendScore("i-3.1 0 1")
        csound.sendScore("i2.1 0 -1")
        csound.sendScore("i-4.1 0 1")
        csound.sendScore("i-5.1 0 1")
    }
    
    @IBAction func levelChanged(_ sender: UISlider) {
        vol = sender.value
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Handle pan gesture
    @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
        // Draw circle to follow finger during pan gesture in XYPad
        let loc = recognizer.location(in: xyPad)
    
        // Ensure panning is only used to draw circle and update xloc and yloc if it does not stray outside the XYPad
        if xyPad.bounds.contains(loc) {
            xyPad.drawTouchCircle(loc)
            xloc = Float(loc.x/xyPad.frame.width)
            yloc = Float((1.0 - (loc.y/xyPad.frame.height)) * 20000.0)
        }
    }
}

extension SecondViewController: CsoundBinding {
    func setup(_ csoundObj: CsoundObj) {
        // Set up channel pointers so we can pass values to addresses Csound has access to
        crossPtr = csoundObj.getInputChannelPtr("blur", channelType: CSOUND_CONTROL_CHANNEL)
        filtrPtr = csoundObj.getInputChannelPtr("cutoff", channelType: CSOUND_CONTROL_CHANNEL)
        levelPtr = csoundObj.getInputChannelPtr("level", channelType: CSOUND_CONTROL_CHANNEL)
    }
    
    func updateValuesToCsound() {
        // Update channel values to Csound so it can use them
        crossPtr?.pointee = xloc
        filtrPtr?.pointee = yloc
        levelPtr?.pointee = vol
    }
}
