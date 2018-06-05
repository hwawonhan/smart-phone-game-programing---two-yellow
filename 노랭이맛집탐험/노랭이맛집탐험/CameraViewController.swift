//
//  ViewController.swift
//  testcamera
//
//  Created by kpugame on 2018. 5. 28..
//  Copyright © 2018년 JiinMin. All rights reserved.
//

import UIKit
import AVFoundation
import CoreImage

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate{
    //  카메라 영상 표시 위한 뷰

    @IBOutlet weak var TimerLabel: UILabel!
    @IBOutlet weak var ScoreLabel: UILabel!
    var count = 0
    var seconds = 0
    var timer = Timer()
    
    @IBOutlet weak var FinishPopUp: UIStackView!
    
    @IBOutlet weak var Food1: UIImageView!
    @IBOutlet weak var Food2: UIImageView!
    @IBOutlet weak var Food3: UIImageView!
    @IBOutlet weak var Food4: UIImageView!
    @IBOutlet weak var Food5: UIImageView!
    @IBOutlet weak var Food6: UIImageView!
    @IBOutlet weak var Food7: UIImageView!
    @IBOutlet weak var Food8: UIImageView!
    
    @IBOutlet weak var cameraView: UIView!
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    @IBAction func StartAction(_ sender: UIButton) {
        setupGame()
    }
    
    func setupGame() {
        seconds = 30
        count = 0
        
        TimerLabel.text = "Time: \(seconds)"
        ScoreLabel.text = "Score: \n\(count)"
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.subtractTime), userInfo: nil, repeats: true)
    }
    
    @objc func subtractTime() {
        seconds -= 1
        TimerLabel.text = "Time: \(seconds)"
        
        if(seconds == 0) {
            timer.invalidate()
            
            FinishPopUp.alpha = 1
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        captureSession = AVCaptureSession()
        stillImageOutput = AVCapturePhotoOutput()
        
        //captureSession.sessionPreset = AVCaptureSession.Preset.hd1920x1080 // 해상도설정
        let device = AVCaptureDevice.default(.builtInWideAngleCamera , for: .video, position: .front)
        
        captureSession.beginConfiguration()
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        do {
            let input = try AVCaptureDeviceInput(device: device!)
            
            // 입력
            if (captureSession.canAddInput(input)) {
                captureSession.addInput(input)
                
                // 출력
                if (captureSession.canAddOutput(stillImageOutput!)) {
                    captureSession.addOutput(stillImageOutput!)
                    captureSession.commitConfiguration()
                    // Add video preview layer
                    previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                    previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspect //화면 조절
                    previewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait // 카메라 방향
                    cameraView.layer.addSublayer(previewLayer!)
                    
                    // 뷰 크기 조절
                    previewLayer?.position = CGPoint(x: self.cameraView.frame.width / 2, y: self.cameraView.frame.height / 2)
                    previewLayer?.bounds = cameraView.frame
                    
                    captureSession.startRunning() // 카메라 시작
                    
                }
            }
        }
        catch {
            print(error)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
  
}

