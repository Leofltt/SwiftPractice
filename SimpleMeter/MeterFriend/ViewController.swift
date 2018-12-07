//
//  ViewController.swift
//  PhonoCam
//
//  Created by Akito van Troyer on 11/26/18.
//  Copyright © 2018 Akito van Troyer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var libraryButton:UIButton!
    @IBOutlet var startStop:UISwitch!
    @IBOutlet var dBLabel: UILabel!
    
    @IBOutlet var levelmet:LevelMeterView!
    
    var imagePickerController:UIImagePickerController!
    var audioRecorder:AudioRecorder!
    var libraryViewController:LibraryViewController!
    var timer: Timer!
    var vol = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //performSelector(onMainThread: #selector(openCamera), with: nil, waitUntilDone: true)
        deleteAllFiles()
        audioRecorder = AudioRecorder()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        if(imagePickerController != nil){
            imagePickerController.view.isHidden = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
      //  record() //Start recording sound when view shows up
    }
    
    
//    @objc func openCamera(){
//       //imagePickerController = UIImagePickerController()
//        //if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
//       //     imagePickerController.sourceType = UIImagePickerController.SourceType.camera
//        //    imagePickerController.delegate = self
//            imagePickerController.showsCameraControls = false
//
//            //Adjust the camera view
//            let screenSize = UIScreen.main.bounds.size
//            let cameraAspectRatio = Float(4.0 / 3.0);
//            let imageWidth = floorf(Float(screenSize.width) * cameraAspectRatio);
//            let scale = ceilf((Float(screenSize.height) / imageWidth) * 10.0) / 10.0;
//            self.imagePickerController.cameraViewTransform = CGAffineTransform(scaleX: CGFloat(scale), y: CGFloat(scale));
//
//            self.view.addSubview(imagePickerController.view)
//            self.view.sendSubviewToBack(imagePickerController.view)
//        }
//    }
//
//    @IBAction func takePicture(){
//        audioRecorder.stop()
//        imagePickerController.takePicture()
//    }
//
    @IBAction func openLibrary(){
        audioRecorder.delete()
       // imagePickerController.view.isHidden = true
        if(libraryViewController == nil){
            
        }
    }
    
    @IBAction func startStop(_sender:UISwitch) {
        if _sender.isOn == true {
            timer = Timer.scheduledTimer(timeInterval: Double(1/60), target: self, selector: #selector(self.updateMeter), userInfo: nil, repeats: true)

            record()
            
        } else if _sender.isOn == false {
            audioRecorder.stop()
            timer.invalidate()
            dBLabel.text = "0 dBFS"
        }
        
    }
    
    
    @objc func updateMeter() {
        DispatchQueue.main.async {
            self.vol = pow(2,self.audioRecorder.volume/6)
            self.levelmet.channelValue = Float(self.vol)
            self.levelmet.setNeedsDisplay()
                        }
        dBLabel.text = String(format:"%.2f dBFS", audioRecorder.volume)
    }

    func record(){
        audioRecorder.record()
    }
    
    func deleteAllFiles(){
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let fileManager = FileManager.default
        do {
            let files = try fileManager.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            
            var recordings = files.filter({ (name: URL) -> Bool in
                return name.pathExtension == "m4a" //|| name.pathExtension == "jpg"
            })
            
            for i in 0 ..< recordings.count {
                print("Removing \(recordings[i])")
                do {
                    try fileManager.removeItem(at: recordings[i])
                } catch {
                    print("Failed to remove \(recordings[i])")
                    print(error.localizedDescription)
                }
            }
            
        } catch {
            print("Failed to get contents of directory at \(documentsDirectory)")
            print(error.localizedDescription)
        }
    }
}

//extension ViewController: UIImagePickerControllerDelegate {
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
////        let image = info[.originalImage] as! UIImage //UIImage
////        let imageURL = audioRecorder.fileURL.appendingPathExtension("jpg") //Give the same name as the recorded sound file
////        let data = image.jpegData(compressionQuality: 0.5)!
////        do {
////            print("Saving image: \(imageURL.path)")
////            try data.write(to: imageURL)
////        } catch {
////            print("Failed to write image on disk")
////            print(error)
////        }
//        record()
//   }
//}

extension ViewController: UINavigationControllerDelegate {
    
}

