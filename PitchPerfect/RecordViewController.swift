//
//  RecordViewController.swift
//  Pitch Perfect
//
//  Created by Wejdan on 06/09/1441 AH.
//  Copyright © 1441 Udacity. All rights reserved.
//

import UIKit
import AVFoundation

class RecordViewController: UIViewController ,AVAudioRecorderDelegate {

    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordLabel: UILabel!
    
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func recordAudio(_ sender: UIButton) {
        
        //change label text and disable\enable buttons
        configureUI(isRecording: true)
        
        //record audio
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedAudio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))

        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    @IBAction func stopRecording(_ sender: UIButton) {
        //stop recording audio
        audioRecorder.stop()
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
                
        //change label text and disable\enable buttons
        configureUI(isRecording: false)
    }
    
// MARK: - UI configure Method
    
    func configureUI(isRecording: Bool) {
        if isRecording {
            self.recordButton.isEnabled = false
            self.stopButton.isEnabled = true
            self.recordLabel.text = "Recording in Progress"

        }else{
            self.recordButton.isEnabled = true
            self.stopButton.isEnabled = false
            self.recordLabel.text = "Tap to Record..."
        }
    }
    
// MARK: - Audio Recorder Delegate
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        //move to second screen
        if flag {
            performSegue(withIdentifier: "moveToSecondScreen", sender: audioRecorder.url)
        }
    }

// MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "moveToSecondScreen"{
            let playVC = segue.destination as! PlayViewController
            playVC.recordedAudioURL = sender as! URL
            
        }
       }
}

