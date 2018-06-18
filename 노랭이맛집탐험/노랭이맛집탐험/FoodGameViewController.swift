//
//  ViewController.swift
//  testcamera
//
//  Created by kpugame on 2018. 5. 28..
//  Copyright © 2018년 JiinMin. All rights reserved.
//

import UIKit
import AVFoundation

class FoodGameViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    //  카메라 영상 표시 위한 뷰

    @IBOutlet weak var StartButton: UIButton!
    @IBOutlet weak var TimerLabel: UILabel!
    @IBOutlet weak var cameraView: UIImageView!
    @IBOutlet weak var FinishPopUp: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var frontView: UIView!
    @IBOutlet weak var ExplainLable: UILabel!
    @IBOutlet weak var CircleView: CircleView!
    
    var audiocontroller:AudioController = AudioController()
    var location : String = ""
    var mymap = GeographicPoint()
    var count = 0
    var seconds = 0.0
    var circleTimer = Timer()
    var timer = Timer()
    var ExplainTimer = Timer()
    var foods : [UIImageView] = []
    var foodCount : [Int] = [0, 0, 0, 0, 0, 0, 0, 0]
    var resultFood = 0
    var scaleValue = CGPoint(x : 0, y: 0)
    var setUpTime = 0
    var circleTime = 0
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toResult" {
            if let todayFoodViewController = segue.destination as? TodayFoodViewController {
                todayFoodViewController.resultFood = self.resultFood
                todayFoodViewController.location = self.location
                todayFoodViewController.mymap = self.mymap
            }
        }
    }
    
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        if let view = recognizer.view {
            var center = CGPoint(x:view.center.x + translation.x,
                                 y:view.center.y + translation.y)
            if(center.x <= backgroundView.frame.minX + 45) {
                center.x = backgroundView.frame.minX + 45
            }
            else if(center.x >= backgroundView.frame.maxX - 45) {
                center.x = backgroundView.frame.maxX - 45
            }
            if(center.y <= backgroundView.frame.minY + (backgroundView.frame.size.height / 2) + 45) {
                center.y = backgroundView.frame.minY + (backgroundView.frame.size.height / 2) + 45
            }
            else if(center.y >= backgroundView.frame.maxY - 45) {
                center.y = backgroundView.frame.maxY - 45
            }
            view.center = center
        }
        
        recognizer.setTranslation(CGPoint.zero, in: self.view)
        CircleView.center = cameraView.center
        
        DispatchQueue.main.async(execute: {
            self.checkCollision()
        })
    }
    
    @IBAction func NextAction(_ sender: Any) {
        audiocontroller.playerEffect(name: SoundDing)
    }
    
    @IBAction func StartAction(_ sender: UIButton) {
        audiocontroller.playerEffect(name: SoundDing)
        setupGame()
        StartButton.isUserInteractionEnabled = false
    }
    
    func setupGame() {
        ExplainTimer.invalidate()
        circleTimer.invalidate()
        CircleView.alpha = 0
        ExplainLable.alpha = 0
        seconds = 30
        count = 0
        
        TimerLabel.text = "Time: \(Int(seconds))"
        
        timer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(self.subtractTime), userInfo: nil, repeats: true)
    }
    
    @objc func circleAnimation() {
        if(circleTime % 2 == 0) {
            CircleView.alpha = 0
        } else {
            CircleView.alpha = 1
        }
        circleTime += 1
    }
    
    @objc func increaseTime() {
        if(setUpTime == 40) {
            setUpTime = 0
        }
        
        if(setUpTime < 20) {
        scaleValue.x += 0.01
        scaleValue.y += 0.01
        }
        else if(setUpTime >= 20 && setUpTime < 40){
            scaleValue.x -= 0.01
            scaleValue.y -= 0.01
        }
        setUpTime += 1
        
        StartButton.transform = CGAffineTransform(scaleX: 1 + scaleValue.x, y: 1 + scaleValue.y);
    }
    
    @objc func subtractTime() {
        seconds -= 0.25
        TimerLabel.text = "Time: \(Int(seconds.rounded()))"
        
        initItem()
        checkCollision()
        
        if(seconds == 0) {
            audiocontroller.playerEffect(name: SoundWrong)
            timer.invalidate()
            
            var cnt = resultFood
            var foodcnt = foodCount[0]
            
            while(cnt < 8) {
                if(foodcnt < foodCount[cnt]) {
                    foodcnt = foodCount[cnt]
                    resultFood = cnt
                }
                cnt += 1
            }
            
            FinishPopUp.isUserInteractionEnabled = true
            FinishPopUp.alpha = 1
        }
    }
    
    func randomCGFloat(min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * (max - min) + min
    }
    
    func initItem() {
        let startX: CGFloat = randomCGFloat(min: backgroundView.center.x - (backgroundView.frame.size.width / 2), max: backgroundView.center.x + (backgroundView.frame.size.width / 2 - 100))
        let startY: CGFloat = randomCGFloat(min: backgroundView.center.y - (backgroundView.frame.size.height / 2) - 50, max: backgroundView.center.y - (backgroundView.frame.size.height / 2) - 70)
        let endY : CGFloat = backgroundView.center.y + (backgroundView.frame.size.height / 2) - 100
        let imageNum = arc4random_uniform(8)
        var image : UIImage
        switch imageNum {
        case 0:
            image = UIImage(named: "food1")!
            break
        case 1:
            image = UIImage(named: "food2")!
            break
        case 2:
            image = UIImage(named: "food3")!
            break
        case 3:
            image = UIImage(named: "food4")!
            break
        case 4:
            image = UIImage(named: "food5")!
            break
        case 5:
            image = UIImage(named: "food6")!
            break
        case 6:
            image = UIImage(named: "food7")!
            break
        case 7:
            image = UIImage(named: "food8")!
            break
        default:
            image = UIImage(named: "food4")!
            break
        }
        
        let food = UIImageView(image: image)
        food.frame = CGRect(x: startX, y: startY, width: 50, height: 50)
        frontView.addSubview(food)
        frontView.sendSubview(toBack: food)
        foods.append(food)
        
        UIView.animate(withDuration: TimeInterval(randomCGFloat(min: 1, max: 7)),
                       delay: TimeInterval(randomCGFloat(min: 0, max: 0.25)),
                       options: UIViewAnimationOptions.curveEaseIn,
                       animations: {
                        food.center = CGPoint(x: startX, y: endY)
                        food.transform = CGAffineTransform(rotationAngle: self.randomCGFloat(min: 0, max: 30))
        }, completion: {(value:Bool) in
            food.removeFromSuperview()
        })
    }
    
    func checkCollision()
    {
        var cnt = 0
        while(cnt < foods.count)
        {
            if(frontView.contains(foods[cnt]))
            {
                let currentLocation = foods[cnt].layer.presentation()?.frame
                
                if(currentLocation != nil) {
                    if((currentLocation?.origin.y)! + 25 >= cameraView.frame.origin.y - cameraView.frame.height) {
                        if((currentLocation?.origin.y)! - 25 <= cameraView.frame.origin.y + (cameraView.frame.height / 2)) {
                            if((currentLocation?.origin.x)! + 25 >= cameraView.frame.origin.x - (cameraView.frame.width / 2) && (currentLocation?.origin.x)! - 25 <= cameraView.frame.origin.x + (cameraView.frame.width / 2)) {
                                audiocontroller.playerEffect(name: SoundParticle)
                                let explore = ExplodeView(frame: CGRect(x: (currentLocation?.midX)!,
                                                                    y: (currentLocation?.midY)!,
                                                                    width: 5, height: 5))
                                frontView.addSubview(explore)
                                frontView.sendSubview(toBack: explore)
                                switch(foods[cnt].image)
                                {
                                case #imageLiteral(resourceName: "food1.png"):
                                    foodCount[0] += 1
                                    break
                                case #imageLiteral(resourceName: "food2.png"):
                                    foodCount[1] += 1
                                    break
                                case #imageLiteral(resourceName: "food3.png"):
                                    foodCount[2] += 1
                                    break
                                case #imageLiteral(resourceName: "food4.png"):
                                    foodCount[3] += 1
                                    break
                                case #imageLiteral(resourceName: "food5.png"):
                                    foodCount[4] += 1
                                    break
                                case #imageLiteral(resourceName: "food6.png"):
                                    foodCount[5] += 1
                                    break
                                case #imageLiteral(resourceName: "food7.png"):
                                    foodCount[6] += 1
                                    break
                                case #imageLiteral(resourceName: "food8.png"):
                                    foodCount[7] += 1
                                    break
                                default:
                                    break
                                }
                                foods[cnt].stopAnimating()
                                foods[cnt].removeFromSuperview()
                                foods.remove(at: cnt)
                            }
                        }
                    }
                }
            }
            cnt = cnt + 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        cameraView.layer.cornerRadius = 10
        cameraView.clipsToBounds = true
        cameraView.layer.borderWidth = 3
        cameraView.layer.borderColor = UIColor.orange.cgColor
        audiocontroller.preloadAudioEffects(audioFileNames: AudioEffectFiles)
        FinishPopUp.isUserInteractionEnabled = false
        cameraView.center = backgroundView.center
        CircleView.center = cameraView.center
        cameraView.isUserInteractionEnabled = true
        CircleView.awakeFromNib()
        
        ExplainTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.increaseTime), userInfo: nil, repeats: true)
        circleTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.circleAnimation), userInfo: nil, repeats: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
}

