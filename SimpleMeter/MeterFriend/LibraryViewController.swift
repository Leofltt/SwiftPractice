//
//  LibraryViewController.swift
//  PhonoCam
//
//  Created by Akito van Troyer on 11/26/18.
//  Copyright © 2018 Akito van Troyer. All rights reserved.
//

import UIKit

class LibraryViewController: UITableViewController {
 
    var fileURL:URL!
    var recordings = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRecordingNames()
    }
    
    func getRecordingNames(){
        let filePaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        fileURL = filePaths[0]
        do {
            try recordings = FileManager.default.contentsOfDirectory(atPath: fileURL.path)
        } catch {
            print("Failed to load contents of directory")
            print(error)
        }
        for recording in recordings {
            print(recording)
        }
    }
}

//UITableViewController specifics
extension LibraryViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordings.count //same name picture and audio file
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell" // you need to name your cell
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if(cell == nil){
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        } // guarantees at this point the cell exists
        
        let url = URL(fileURLWithPath: recordings[indexPath.row])
        cell?.textLabel?.text = url.deletingPathExtension().lastPathComponent //without extension
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Opening playback view with: \(fileURL.path+recordings[indexPath.row])")
        let vc = PlaybackViewController.create(filePath: fileURL.path+"/"+recordings[indexPath.row])
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

