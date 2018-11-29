//
//  ViewController.swift
//  AVMIDIPlayerExamples
//
//  Created by Akito van Troyer on 11/13/18.
//  Copyright © 2018 Akito van Troyer. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet var playPauseButton: UIButton!
    @IBOutlet var midiPicker: UIPickerView!
    let midiFolderURL = Bundle.main.resourceURL!.appendingPathComponent("midi")    // URL for .csd storage
    var midiFiles = [String]()   // Array of available .mid names
    var midiFile = ""
    var midiPath = ""
    var isPlaying = false
    var sum = 4

    var midiPlayer: MIDIFilePlayer!
    var midiSampler: MIDISampler!
    @IBOutlet var keyboardView: VirtualKeyboard!
    @IBOutlet var stepper: UIStepper!
    @IBOutlet var instrNumber: UILabel!
    @IBOutlet var reverbLabel: UILabel!
    
    @IBOutlet var Ostepper: UIStepper!
    @IBOutlet var Onumber: UILabel!
    
    @IBOutlet var volSlider: UISlider!
    @IBOutlet var volLabel: UILabel!
    
    @IBOutlet var revSlider: UISlider!
    
    @IBOutlet var pitchSlider: UISlider!
    
    @IBOutlet var resbutton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        midiPicker.delegate = self //Why?
        midiPicker.dataSource = self
        midiPlayer = MIDIFilePlayer(viewController: self)
        midiSampler = MIDISampler()
        midiSampler.loadPatch(gmPatch: 0) //Load general MIDI stuff
        keyboardView.keyboardDelegate = self
    }
    
    @IBAction func playPause(_ sender: UIButton) {
        if(!isPlaying){
            // Get selected element from UIPickerView
            midiFile = midiFiles[midiPicker.selectedRow(inComponent: 0)]
            
            // Get MIDI Path
            midiPath = midiFolderURL.appendingPathComponent(midiFile).path
            
            // Set midi file and play
            midiPlayer?.createAVMIDIPlayerFromMIDIFile(midiFile: midiPath)
            midiPlayer?.play()
            
            //Set label of the button
            sender.setTitle("Stop", for: .normal) //.normal is a UIState.
            isPlaying = true
        } else {
            // stop midi playback
            midiPlayer?.stop()
            sender.setTitle("Play", for: .normal)
            isPlaying = false
        }
    }
    
    func reset(){ 
        if(isPlaying){
            isPlaying = false
            DispatchQueue.main.async { //This line is here because this specific line of code is running somewhere else. Passed as closure, implicit somewhere else.
                self.playPauseButton.setTitle("Play", for: .normal)
            }
        }
    }
    @IBAction func Volume(_ sender: UISlider){
        // Mock fb meter with minimum track color of slider
        let color = UIColor(hue: CGFloat(1/3 - (sender.value/3)), saturation: 1, brightness: 1, alpha: 1)
        sender.minimumTrackTintColor = color
        volLabel.text = String(format: "%d", UInt8(sender.value))
    }
    
    @IBAction func changePatch(_sender: UIStepper){
        if (_sender.value >= 0 && _sender.value <= 127) {
            midiSampler.loadPatch(gmPatch: UInt8(_sender.value))
            instrNumber.text = String(format:"%d", UInt8(_sender.value))
        }
    }
    
    @IBAction func changeOctave(_sender: UIStepper){
        if (_sender.value >= 0 && _sender.value <= 7){
            sum = Int(_sender.value)
            Onumber.text =  String(format: "+ %d Octaves", sum)
        }
    }
    
    @IBAction func reverbSend(_ sender: UISlider){
        midiSampler.reverb.wetDryMix = sender.value
        reverbLabel.text = String(format: "%d percent", UInt8(sender.value))
    }
    
    @IBAction func pitchMod(_ sender: UISlider){
        midiSampler.pitch.pitch = sender.value

    }
    
    @IBAction func restart(_ sender: UIButton){
        volSlider.value = 80
        revSlider.value = 50
        pitchSlider.value = 0
        
        reverbLabel.text = "50 percent"
        volLabel.text = "80"
    }
}

// UIPickerView delegate and data source methods
extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        do {
            midiFiles = try FileManager.default.contentsOfDirectory(atPath: midiFolderURL.path)
        } catch {
            print(error)
            return 0
        }
        return midiFiles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return midiFiles[row]
    }
}

extension ViewController: VirtualKeyboardDelegate {
    func keyDown(_ keybd: VirtualKeyboard, keyNum: Int) {
        midiSampler.noteOn(note: UInt8(keyNum + 12*sum), velocity: UInt8(volSlider!.value))
    }
    
    func keyUp(_ keybd: VirtualKeyboard, keyNum: Int) {
        midiSampler.noteOff(note: UInt8(keyNum + 12*sum))
    }
}

