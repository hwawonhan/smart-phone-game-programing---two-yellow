//
//  ViewController.swift
//  testcamera
//
//  Created by kpugame on 2018. 5. 28..
//  Copyright © 2018년 JiinMin. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate{
    //  카메라 영상 표시 위한 뷰
    
    @IBOutlet weak var cameraView: UIView!
    
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewWillAppear(_ animated: Bool) {
        captureSession = AVCaptureSession()
        stillImageOutput = AVCapturePhotoOutput()
        
        captureSession.sessionPreset = AVCaptureSession.Preset.hd1920x1080 // 해상도설정
        
        let device = AVCaptureDevice.default(for: .video)
        
        do {
            let input = try AVCaptureDeviceInput(device: device!)
            
            // 입력
            if (captureSession.canAddInput(input)) {
                captureSession.addInput(input)
                
                // 출력
                if (captureSession.canAddOutput(stillImageOutput!)) {
                    captureSession.addOutput(stillImageOutput!)
                    captureSession.startRunning() // 카메라 시작
                    
                    previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                    previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspect //화면 조절
                    previewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait // 카메라 방향
                    
                    cameraView.layer.addSublayer(previewLayer!)
                    
                    // 뷰 크기 조절
                    previewLayer?.position = CGPoint(x: self.cameraView.frame.width / 2, y: self.cameraView.frame.height / 2)
                    previewLayer?.bounds = cameraView.frame
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

