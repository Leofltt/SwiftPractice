//
//  ViewController.swift
//  navProcessor
//
//  Copyright © 2017 Berklee EP-P453. All rights reserved.
//

import UIKit
import AVFoundation
import CsoundiOS

class ViewController: UIViewController {
    
    // IBOutlets
    @IBOutlet var loadingProgress: UIProgressView!
    @IBOutlet var loadingLabel: UILabel!
    @IBOutlet var firstProcessorButton: UIButton!
    
    // Declarations
    var counter = 0
    let csound = SharedInstances.csound //Shared instances. Different view controllers can acess the same Csound instance.

    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstProcessorButton.isHidden = true
        loadingProgress.progress = 0
        
        let loadingTimer = Timer.scheduledTimer(timeInterval: 0.02, target:self, selector:#selector(updateLoading(_:)), userInfo: nil, repeats: true)
        loadingTimer.fire() //Interval of timer is 0.02. Selecting methods withing the class. As soon as viewdidload is called, fire is running.
        
        let csdPath = Bundle.main.path(forResource: "processor", ofType: "csd")
        csound.useAudioInput = true //Enable audio input from Csound.
        csound.play(csdPath)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Return a BOOL signifying whether or not headphones are connected to the current device
    func headphonesPlugged() -> Bool {
        let availableOutputs = AVAudioSession.sharedInstance().currentRoute.outputs
        for out in availableOutputs {
            if out.portType == AVAudioSessionPortHeadphones {
                return true
            }
        }
        return false
    }
    
    // Method to periodically update the "loading" UIProgressView
    @objc func updateLoading(_ timer: Timer) { //@objc make it comparable with objective C
        if counter <= 100 {
            loadingLabel.text = "Loading: \(counter) %"
            counter += 1
            loadingProgress.progress = Float(counter)/100.0;
        } else {
            firstProcessorButton.isHidden = false //After loading, it shows.
            timer.invalidate() //Timer stops/
        }
    }
}
