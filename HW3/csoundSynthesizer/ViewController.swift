//
//  ViewController.swift
//  csoundSynthesizer
//
//  Copyright © 2017 Berklee EP-P453. All rights reserved.
//

import UIKit
import SafariServices
import CsoundiOS

enum SigType: Int {
    case sin = 1
    case saw = 2
    case sqr = 3
    case tri = 4
}

class ViewController: UIViewController {
    
    // Declarations
    var sig: SigType = .saw
    var sum: Int = 4
    var vol = 0.8
    var csound: CsoundObj!
    var csoundUI: CsoundUI!  //comes from the library
    
    // IBOutlets
    @IBOutlet var sinButton: UIButton!
    @IBOutlet var sqrButton: UIButton!
    @IBOutlet var sawButton: UIButton!
    @IBOutlet var triButton: UIButton!
    
    @IBOutlet var levelSlider: UISlider!
    @IBOutlet var fbSlider: UISlider!
    @IBOutlet var resSlider: UISlider!
    @IBOutlet var frqSlider: UISlider!
    
    @IBOutlet var upButton: UIButton!
    @IBOutlet var downButton: UIButton!
    
    @IBOutlet var resLabel: UILabel!
    @IBOutlet var frqLabel: UILabel!
    @IBOutlet var fbLabel: UILabel!
    @IBOutlet var levelLabel: UILabel!
    
    @IBOutlet var OctaveText: UILabel!
    
    @IBOutlet var keyboardView: CsoundVirtualKeyboard!
    
    func incrWith (op: ((Int,Int)->Int), num: Int) -> Int {
        var x = num
        guard x >= 1 else {
            x = 1
            return x
        }
        guard x <= 8 else {
            x = 8
            return x
        }
        x = op(num,1)
        print(x)
        return x
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.lightGray
        
        // Initialize CsoundObj and CsoundUI objects
        csound = CsoundObj()
        csoundUI = CsoundUI(csoundObj: csound)

        csoundUI.add(levelSlider, forChannelName:"amp") // Bind to a UISlider
        csoundUI.add(fbSlider, forChannelName:"fb")
        csoundUI.add(frqSlider, forChannelName:"frqM")
        csoundUI.add(resSlider, forChannelName:"resM")
        csound.play(Bundle.main.path(forResource:"csoundSynth", ofType: "csd")) // Play .csd
        
        keyboardView.keyboardDelegate = self
        didSelectSigtype(sinButton)
        levelChange(levelSlider) // Initialize slider properties
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: IBActions
    @IBAction func levelChange(_ sender: UISlider) {
        // Mock level meter with minimum track color of slider
        let color = UIColor(hue: CGFloat(1/3 - (sender.value/3)), saturation: 1, brightness: 1, alpha: 1)
        sender.minimumTrackTintColor = color
        levelLabel.text = String(format: "Level: %.2f", sender.value)
        
    }
    
    @IBAction func fbChange(_ sender: UISlider) {
        // Mock fb meter with minimum track color of slider
        let color = UIColor(hue: CGFloat(1/3 - (sender.value/3)), saturation: 1, brightness: 1, alpha: 1)
        sender.minimumTrackTintColor = color
          fbLabel.text = String(format: "FeedBack: %.2f", sender.value)
    }
    @IBAction func resChange(_ sender: UISlider) {
        // Mock fb meter with minimum track color of slider
        let color = UIColor(hue: CGFloat(1/3 - (sender.value/3)), saturation: 1, brightness: 1, alpha: 1)
        sender.minimumTrackTintColor = color
        resLabel.text = String(format: "Resonance: %.2f", sender.value)
    }
    @IBAction func frqChange(_ sender: UISlider) {
        // Mock fb meter with minimum track color of slider
        let color = UIColor(hue: CGFloat(1/3 - (sender.value/3)), saturation: 1, brightness: 1, alpha: 1)
        sender.minimumTrackTintColor = color
        frqLabel.text = String(format: "Cutoff frequency: %.0f Hz", sender.value)
    }
    
    // Show csound.github.io in an SFSafariViewController
    @IBAction func showSite(_ sender: UIButton) {
        let csoundURL = URL(string: "http://csound.github.io")
        let safariVC = SFSafariViewController(url: csoundURL!)
        present(safariVC, animated: true, completion: nil)
    }
    
    // sig is set according to which button is touched
    @IBAction func didSelectSigtype(_ sender: UIButton) {
        // Set all other buttons to false, sender to true
        for button in [sinButton, sawButton, sqrButton, triButton] {
            if button == sender {
                button?.isSelected = true
            } else {
                button?.isSelected = false
            }
        }
        
        // Set sig depending on identity of sender
        switch sender {
        case sinButton: sig = .sin
        case sawButton: sig = .saw
        case sqrButton: sig = .sqr
        case triButton: sig = .tri
        default: break
        }
    
    }
    @IBAction func changOct(_ sender:UIButton) {
        switch sender {
        case upButton:
            sum = incrWith(op: +,num: sum)
            
        case downButton:
            sum = incrWith(op: -, num: sum)
        default: break
        }
        OctaveText.text = String(format: "C%d", sum)
    }

}

// MARK: Keyboard delegate methods
extension ViewController: CsoundVirtualKeyboardDelegate {
    func keyDown(_ keybd: CsoundVirtualKeyboard, keyNum: Int) {
        // Key touched
        let score = String(format: "i1.%003d 0 -1 %d %d", keyNum+(sum*12), keyNum+(sum*12), sig.rawValue)
        csound.sendScore(score)
    }
    
    func keyUp(_ keybd: CsoundVirtualKeyboard, keyNum: Int) {
        // Key released
        let score = String(format: "i-1.%003d 0 -1 %d %d", keyNum+(sum*12), keyNum+(sum*12), sig.rawValue)
        csound.sendScore(score)
    }
}

