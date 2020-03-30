//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by José Guilherme Pádua Jr. on 11/03/20.
//  Copyright © 2020 José Guilherme Pádua Jr. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    var audioRecorder:AVAudioRecorder!
    
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
    }

    @IBAction func recordAudio(_ sender: Any) {
        configureUI(true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
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
    
    @IBAction func stopRecording(_ sender: Any) {
        configureUI(false)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    //Essa função é a que sabe exatamente quando o arquivo de audio terminou de ser gravado fisicamente no app.
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag) {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("Erro ao gravar o audio")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    func configureUI(_ isRecording:Bool) {
        recordLabel.text = (isRecording) ? "Gravando..." :  "Aperte para gravar"
        stopRecordingButton.isEnabled = isRecording
        recordButton.isEnabled = !isRecording
    }
}

