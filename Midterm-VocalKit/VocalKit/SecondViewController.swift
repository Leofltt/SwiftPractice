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

    @IBOutlet var keyboard: CsoundVirtualKeyboard!

    @IBOutlet var reverbSlider: UISlider!
    @IBOutlet var volumeSlider: UISlider!
    @IBOutlet var volValue: UILabel!
    
    // Declarations
    let wavPath = Bundle.main.resourceURL!.appendingPathComponent("WAVs")
    var wavFiles = [String]()
    var file = 0
    var loop = true
    
    //Pointers
    
    var reverbPtr: UnsafeMutablePointer<Float>?
    var levelPtr: UnsafeMutablePointer<Float>?
    
    var reverb: Float = 0
    var level: Float = 0
    
    let csound = SharedInstances.csound
    var csoundUI: CsoundUI!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        csound.addBinding(self)
        csound.play(Bundle.main.path(forResource:"VocalHarmonizer", ofType: "csd")) 
        
        [volumeSlider, reverbSlider].forEach { ValueChanged($0) }
        
        volumeSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))
    }

    override func viewDidAppear(_ animated: Bool) {
        // Start corresponding instrument and stop the other instrument if it is running
        csound.sendScore("i-1.1 0 1")
        
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

// Get 1 or 0 from Bool
extension Bool {
    func toInt() -> Int {
        return (self == true) ? 1 : 0
    }
}

extension SecondViewController: CsoundBinding{
    func setup(_ csoundObj: CsoundObj) {
        reverbPtr = csoundObj.getInputChannelPtr("reverb", channelType: CSOUND_CONTROL_CHANNEL)
        levelPtr = csoundObj.getInputChannelPtr("level", channelType: CSOUND_CONTROL_CHANNEL)
    }
    
    func updateValuesToCsound() {
        reverbPtr?.pointee = reverb
        levelPtr?.pointee = level
    }
}

extension SecondViewController: CsoundVirtualKeyboardDelegate {
    func keyUp(_ keybd: CsoundVirtualKeyboard, keyNum: Int) {
        let score = String(format: "")
        csound.sendScore(score)
    }

    func keyDown(_ keybd: CsoundVirtualKeyboard, keyNum: Int) {
        let score = String(format: "")
        csound.sendScore(score)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "keyboard" {
            (segue.destination.view as? CsoundVirtualKeyboard)?.keyboardDelegate = self
        }
    }
}


