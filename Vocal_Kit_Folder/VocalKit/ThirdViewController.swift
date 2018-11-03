//
//  ThirdViewController.swift
//  VocalKit
//
//  Created by Alexis Soto on 10/30/18.
//  Copyright © 2018 Alexis Soto. All rights reserved.
//

import UIKit
import CsoundiOS
import AVFoundation

class ThirdViewController: UIViewController{
    
    @IBOutlet var gainSlider: UISlider!
    
    //@IBOutlet var VSwitch: UISwitch!
    //@IBOutlet var gainLavel: UILabel!
    //@IBOutlet var Play: UIButton!
    
    var gainPtr: UnsafeMutablePointer<Float>?
    var gain: Float = 0
    
    let csound = SharedInstances.csound
    var csoundUI: CsoundUI!
    
    var Recorded = false
    var Player = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        csoundUI = CsoundUI(csoundObj: csound)
        csound.addBinding(self)
        
        csound.play(Bundle.main.path(forResource:"VocalHarmonizer", ofType: "csd"))
        
        gainSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        csound.sendScore("i-1.1 0 1")
        csound.sendScore("i-2.1 0 1")
        csound.sendScore("i3.1 0 -1")
    }
    
    func recordingURL() -> URL {
        let docDirPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return docDirPath.appendingPathComponent("recording.wav")
    }
}

extension ThirdViewController: CsoundBinding {
    func setup(_ csoundObj: CsoundObj) {
        gainPtr = csoundObj.getInputChannelPtr("gain", channelType: CSOUND_CONTROL_CHANNEL)
    }
    
    func updateValuesToCsound() {
        gainPtr?.pointee = gain
    }
}
