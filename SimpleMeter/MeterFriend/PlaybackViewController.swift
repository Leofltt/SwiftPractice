//
//  PlaybackViewController.swift
//  PhonoCam
//
//  Created by Akito van Troyer on 11/26/18.
//  Copyright © 2018 Akito van Troyer. All rights reserved.
//

import UIKit

class PlaybackViewController: UIViewController {
    
    //@IBOutlet var imageView:UIImageView!
    
    
    
    var audioPlayer:AudioPlayer!
    var filePath = ""
    
    // it's a class method: only the class can access it, but not the instance
    class func create(filePath:String) -> PlaybackViewController {
        let vc = UIStoryboard(name: "Playback", bundle: nil).instantiateViewController(withIdentifier: "playback") as! PlaybackViewController
        vc.filePath = filePath
        return vc
    }
    
    override func viewDidLoad() {
        let url = URL(fileURLWithPath: filePath)
        
      //  imageView.image = UIImage(contentsOfFile: url.path)
        
        audioPlayer = AudioPlayer()
        audioPlayer.setup(fileURL: URL(fileURLWithPath: url.deletingPathExtension().path+".m4a"))
        audioPlayer.play()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        audioPlayer.stop()
    }
}
