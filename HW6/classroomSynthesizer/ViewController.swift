//
//  ViewController.swift
//  classroomSynthesizer
//
//  Created by Nikhil Singh on 12/22/17.
//  Copyright © 2017 Berklee EP-P453. All rights reserved.
//

import UIKit
import CsoundiOS

// Enum to associate waveshape with f-table number
enum SigType: Int {
    case sin = 1, saw = 2, sqr = 3, tri = 4
}

class ViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet var keyboard: CsoundVirtualKeyboard!
    // UISliders
    @IBOutlet var attSlider: UISlider!
    @IBOutlet var decSlider: UISlider!
    @IBOutlet var susSlider: UISlider!
    @IBOutlet var relSlider: UISlider!
    @IBOutlet var rvbSlider: UISlider!
    @IBOutlet var sizeSlider: UISlider!
    @IBOutlet var filtSlider: UISlider!
    @IBOutlet var volSlider: UISlider!
    @IBOutlet var modSlider: UISlider!
    @IBOutlet var indxSlider: UISlider!
    
    // UIStepper for octave displacement
    @IBOutlet var octStepper: UIStepper!
    
    // UIButtons for sigType selection
    @IBOutlet var sinButton: UIButton!
    @IBOutlet var sawButton: UIButton!
    @IBOutlet var sqrButton: UIButton!
    @IBOutlet var triButton: UIButton!

    // UILabel objects
    @IBOutlet var octLabel: UILabel!
    @IBOutlet var filtLabel: UILabel!
    @IBOutlet var volLabel: UILabel!
    @IBOutlet var attLabel: UILabel!
    @IBOutlet var decLabel: UILabel!
    @IBOutlet var susLabel: UILabel!
    @IBOutlet var relLabel: UILabel!
    @IBOutlet var indxLabel: UILabel!
    @IBOutlet var modLabel: UILabel!
    
    //UIButtons for recording
    @IBOutlet var recButton : UIButton!
    @IBOutlet var stopButton: UIButton!
    
    // MARK: Declarations
    let csound = CsoundObj()
    lazy var csoundUI = CsoundUI(csoundObj: csound)
    var sig: SigType = .sin
    // Dictionary to map from sliders to associated labels
    lazy var sliderToLabel: [UISlider: UILabel] = [attSlider: attLabel,
                                                             decSlider: decLabel,
                                                             susSlider: susLabel,
                                                             relSlider: relLabel,
                                                             filtSlider: filtLabel,
                                                             volSlider: volLabel,
                                                             modSlider: modLabel,
                                                             indxSlider: indxLabel]
    // Dictionary to map from sliders to associated labels
    lazy var buttonToSig: [UIButton: SigType] = [sinButton: .sin,
                                                           sawButton: .saw,
                                                           sqrButton: .sqr,
                                                           triButton: .tri]

    // MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //  If we have an image named WALL.jpg, use it as our background image
        //  if let image = UIImage(named: "WALL.jpg") {
        //  view.backgroundColor = UIColor(patternImage: image)
        //  }
        view.backgroundColor = UIColor.lightGray
        // Allow MIDI input
        csound.midiInEnabled = true
        
        // Set Csound channels for sliders
        csoundUI?.add(attSlider, forChannelName: "attack")
        csoundUI?.add(decSlider, forChannelName: "decay")
        csoundUI?.add(susSlider, forChannelName: "sustain")
        csoundUI?.add(relSlider, forChannelName: "release")
        csoundUI?.add(filtSlider, forChannelName: "cutoff")
        csoundUI?.add(volSlider, forChannelName: "volume")
        csoundUI?.add(rvbSlider, forChannelName: "level")
        csoundUI?.add(sizeSlider, forChannelName: "reverb")
        csoundUI?.add(indxSlider, forChannelName: "indx")
        csoundUI?.add(modSlider, forChannelName: "mod")
        
        // Initialize slider values
        [attSlider, decSlider, susSlider, relSlider, filtSlider, volSlider, rvbSlider, sizeSlider, indxSlider, modSlider].forEach { $0?.sendActions(for: .valueChanged) }
        
        csound.setMessageCallback(#selector(printMessage(_:)), withListener: self)
        let csdPath = Bundle.main.path(forResource: "synth", ofType: "csd")
        csound.play(csdPath)
        
        // Set this ViewController to be the keyboard's delegate (to receive the keyDown and keyUp method calls)
        keyboard.keyboardDelegate = self
    }
    
    // MARK: IBActions
    @IBAction func anyValueChanged(_ sender: UISlider) {
        var val: Float = sender.value
        
        // If we have a predefined mapping in our dictionary
        if let label = sliderToLabel[sender] {
            var text = String(format: "%.1f", val)  // Create variable for labelText in the majority of cases
            
            // Special cases: filtSlider and volSlider will override the default text
            if sender == filtSlider {
                val = powf(10, val)
                if val < 1000 {
                    text = String(format: "%.0fHz", val)
                } else {
                    text = String(format: "%.1fk", val/1000.0)
                }
            } else if sender == volSlider {
                text = String(format: "%.0f", val)
            }
            label.text = text
        }
    }
    
    @IBAction func changeSigType(_ sender: UIButton) {
        for button in [sinButton, sawButton, sqrButton, triButton] {
            if button == sender {
                button?.isSelected = true
            } else {
                button?.isSelected = false
            }
            
            // Set the waveshape to the corresponding type or to sin if we don't have a mapping for the button in question
            sig = buttonToSig[sender] ?? .sin
        }
    }
    
    @IBAction func doRec(_ sender: UIButton) {
        for button in [recButton, stopButton] {
            if button == recButton  {
                csound.sendScore("i200 0 -1")
            } else if button == stopButton {
                   csound.sendScore("i-200 0 1")
            }
        }
   
    }
    
    @IBAction func octaveDisplace(_ sender: UIStepper) {
        octLabel.text = "\(Int(sender.value))"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Sample callback function for console output from CsoundObj
    @objc func printMessage(_ infoObj: NSValue) {
        var info = Message()    // Create instance of Message (a C Struct)
        infoObj.getValue(&info) // Store the infoObj value in Message
        let message = UnsafeMutablePointer<Int8>.allocate(capacity: 1024) // Create an empty C-String
        let va_ptr: CVaListPointer = CVaListPointer(_fromUnsafeMutablePointer: &(info.valist)) // Get reference to variable argument list
        vsnprintf(message, 1024, info.format, va_ptr)   // Store in our C-String
        let output = String(cString: message)
        // Create String object with C-String
        print(output)
    }
}

// MARK: Extensions
// Keyboard delegate methods
extension ViewController: CsoundVirtualKeyboardDelegate {
    func keyUp(_ keybd: CsoundVirtualKeyboard, keyNum: Int) {
        let key = (Int(octStepper.value) * 12) + 60 + keyNum
        csound.sendScore(String(format: "i-1.%003d 0 10 %d", key, sig.rawValue))
    }
    
    func keyDown(_ keybd: CsoundVirtualKeyboard, keyNum: Int) {
        let key = (Int(self.octStepper.value) * 12) + 60 + keyNum
        csound.sendScore(String(format: "i1.%003d 0 -1 %d %d", key, sig.rawValue, key))
    }
}
