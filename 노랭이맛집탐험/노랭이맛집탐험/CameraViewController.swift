//
//  FoodGameViewController.swift
//  노랭이맛집탐험
//
//  Created by kpugame on 2018. 6. 9..
//  Copyright © 2018년 hwawonhan. All rights reserved.
//
import UIKit
import AVFoundation
import Vision

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate{
    //  카메라 영상 표시 위한 뷰
    @IBOutlet weak var cameraView: UIImageView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGame" {
            if let imageViewController = segue.destination as? ImageViewController {
                imageViewController.image = self.faceImage
            }
        }
    }
    
    @IBAction func detectAction(_ sender: Any) {
        captureSession.stopRunning()
        /*imageView.image = faceImage
         
         guard let image = imageView.image else { return }
         
         imageView.contentMode = .scaleAspectFit
         
         let scaledHeight = imageView.frame.width / image.size.width * image.size.height
         
         imageView.frame = CGRect(x: imageView.frame.minX, y: imageView.frame.minY, width: imageView.frame.width, height: scaledHeight)
         imageView.backgroundColor = .blue
         
         let request = VNDetectFaceRectanglesRequest { (req, err) in
         if let err = err {
         print("Failed to detect faces: ", err)
         return
         }
         
         req.results?.forEach({(res) in
         guard let faceObservation = res as? VNFaceObservation else { return }
         
         let x = self.imageView.frame.width * faceObservation.boundingBox.origin.x
         let height = scaledHeight * faceObservation.boundingBox.height
         
         let y = scaledHeight * (1 - faceObservation.boundingBox.origin.y) - height
         let width = self.imageView.frame.width * faceObservation.boundingBox.width
         print(x)
         print(y)
         let redView = UIView()
         redView.backgroundColor = .red
         redView.alpha = 0.4
         redView.frame = CGRect(x: x, y: y, width: width, height: height)
         self.imageView.addSubview(redView)
         })
         print("finish")
         }
         
         guard let cgImage = image.cgImage else { return }
         let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
         do {
         try handler.perform([request])
         } catch let reqErr {
         print("Failed to perform request", reqErr)
         }*/
    }
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer?
    var dataOutput: AVCaptureVideoDataOutput?
    var videoDataOutputQueue: DispatchQueue?
    
    var faceImage : UIImage!
    
    func captureOutput(_ captureOutput: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        let image : UIImage = captureImage(sampleBuffer)
        
        DispatchQueue.main.async {
            self.faceImage = image
        }
    }
    
    func captureImage(_ sampleBuffer:CMSampleBuffer) -> UIImage{
        
        // Sampling Bufferから画像を取得
        let imageBuffer:CVImageBuffer =
            CMSampleBufferGetImageBuffer(sampleBuffer)!
        
        // pixel buffer のベースアドレスをロック
        CVPixelBufferLockBaseAddress(imageBuffer,
                                     CVPixelBufferLockFlags(rawValue: CVOptionFlags(0)))
        
        let baseAddress:UnsafeMutableRawPointer =
            CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0)!
        
        let bytesPerRow:Int = CVPixelBufferGetBytesPerRow(imageBuffer)
        let width:Int = CVPixelBufferGetWidth(imageBuffer)
        let height:Int = CVPixelBufferGetHeight(imageBuffer)
        
        let colorSpace:CGColorSpace = CGColorSpaceCreateDeviceRGB()
        
        let newContext:CGContext = CGContext(data: baseAddress,
                                             width: width, height: height, bitsPerComponent: 8,
                                             bytesPerRow: bytesPerRow, space: colorSpace,
                                             bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue|CGBitmapInfo.byteOrder32Little.rawValue)!
        
        let imageRef:CGImage = newContext.makeImage()!
        let resultImage = UIImage(cgImage: imageRef,
                                  scale: 1.0, orientation: UIImageOrientation.leftMirrored)
        
        return resultImage
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        captureSession = AVCaptureSession()
        dataOutput = AVCaptureVideoDataOutput()
        
        let device = AVCaptureDevice.default(.builtInWideAngleCamera , for: .video, position: .front)
        
        captureSession.beginConfiguration()
        captureSession.sessionPreset = AVCaptureSession.Preset.high
        
        do {
            let input = try AVCaptureDeviceInput(device: device!)
            
            // 입력
            if (captureSession.canAddInput(input)) {
                captureSession.addInput(input)
            }
            try device?.lockForConfiguration()
            device?.activeVideoMinFrameDuration = CMTimeMake(1, 15)
            device?.unlockForConfiguration()
            
            dataOutput?.videoSettings = [kCVPixelBufferPixelFormatTypeKey as AnyHashable as!
                String : Int(kCVPixelFormatType_32BGRA)]
            dataOutput?.connection(with: .video)?.isEnabled = true
            if let captureConnection = dataOutput?.connection(with: AVMediaType.video) {
                if captureConnection.isCameraIntrinsicMatrixDeliverySupported {
                    captureConnection.isCameraIntrinsicMatrixDeliveryEnabled = true
                }
            }
            
            if(captureSession.canAddOutput(dataOutput!)) {
                captureSession.addOutput(dataOutput!)
            }
            
            let queue = DispatchQueue(label: "myqueue")
            dataOutput?.setSampleBufferDelegate(self, queue: queue)
            dataOutput?.alwaysDiscardsLateVideoFrames = true
            videoDataOutputQueue = queue
            
            for connection in (dataOutput?.connections)! {
                if let conn = connection as? AVCaptureConnection {
                    if conn.isVideoOrientationSupported {
                        conn.videoOrientation = AVCaptureVideoOrientation.landscapeLeft
                    }
                }
            }
            
            // Add video preview layer
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill //화면 조절
            previewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait // 카메라 방향
            cameraView.layer.addSublayer(previewLayer!)
            
            // 뷰 크기 조절
            previewLayer?.position = CGPoint(x: self.cameraView.frame.width / 2, y: self.cameraView.frame.height / 2)
            previewLayer?.bounds = cameraView.frame
            
            captureSession.commitConfiguration()
            captureSession.startRunning() // 카메라 시작
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


