import Foundation
import UIKit
import AVFoundation


class NarrateViewController: UIViewController, AVAudioRecorderDelegate {

  
  @IBOutlet weak var RecordButton: UIButton!
  //  @IBOutlet weak var RecordButton: UIButton!
  var recordingSession: AVAudioSession!
  var audioRecorder: AVAudioRecorder!
  var recordingInProgress: Bool = false
  
  // MARK: UIViewController Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    recordingSession = AVAudioSession.sharedInstance()
    do {
        try recordingSession.setCategory(.playAndRecord, mode: .default)
        try recordingSession.setActive(true)
        recordingSession.requestRecordPermission() { [unowned self] allowed in
            DispatchQueue.main.async {
                if allowed {
                    print("ALLOWED RECORDING")
                } else {
                    print("FAILED TO RECORD")
                }
            }
        }
    } catch {
      print("FAILED")
    }
  }
  @IBAction func recordTouched(_ sender: Any) {
    let audioFilename = URL(string: "recording.m4a")
    let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
    
    if !recordingInProgress {
      recordingInProgress = true
      print("RECRODING")
      do {
          audioRecorder = try AVAudioRecorder(url: audioFilename!, settings: settings)
          audioRecorder.delegate = self
          audioRecorder.record()
        } catch {
          print("ERROR RECORDING")
        }
    } else {
      print("RECORDING STOP")
      recordingInProgress = false
      audioRecorder.stop()
    }

  }
  
  @IBAction func stopRecord(_ sender: Any) {
//    print("STOPPED RECORD")
  }
}

