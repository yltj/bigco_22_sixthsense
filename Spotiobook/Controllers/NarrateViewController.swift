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
//    let audioFilename = URL(string: "recording.m4a")
    let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

    if !recordingInProgress {
      recordingInProgress = true
      print("RECORDING")
      do {
          audioRecorder = try AVAudioRecorder(url: getFileURL(), settings: settings)
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
  
  func getCacheDirectory() -> String{
      let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
      return paths[0]
  }
  
  func getFileURL() -> URL{
//      let path = getCacheDirectory().appending("recording.m4a")
//      let filePath = NSURL(fileURLWithPath: path)
//      return filePath
    let fileName = "swathiaudio.m4a"
    let docDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    let fileURL = docDirURL.appendingPathComponent(fileName)
    print(fileURL)
    return fileURL
  }
  
  @IBAction func stopRecord(_ sender: Any) {
//    print("STOPPED RECORD")
  }
}

