//
//  TodayFoodViewController.swift
//  노랭이맛집탐험
//
//  Created by kpugame on 2018. 6. 9..
//  Copyright © 2018년 hwawonhan. All rights reserved.
//

import UIKit

class TodayFoodViewController: UIViewController {
    var location : String = ""
    var mymap = GeographicPoint()
    var resultFood : Int = 0
    var foodName : String!
    var image : [UIImage] = [
        #imageLiteral(resourceName: "food1.png"),
        #imageLiteral(resourceName: "food2.png"),
        #imageLiteral(resourceName: "food3.png"),
        #imageLiteral(resourceName: "food4.png"),
        #imageLiteral(resourceName: "food5.png"),
        #imageLiteral(resourceName: "food6.png"),
        #imageLiteral(resourceName: "food7.png"),
        #imageLiteral(resourceName: "food8.png")
    ]
    var timer = Timer()
    var audiocontroller:AudioController = AudioController()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        timer.invalidate()
        if segue.identifier == "toInfo" {
            if let navController = segue.destination as? UINavigationController {
                if let wordviewController = navController.topViewController as?
                    WordViewController {
                    wordviewController.foodtype = self.foodName
                    wordviewController.location = self.location
                    wordviewController.mymap = self.mymap
                }
            }
        }
        
        if segue.identifier == "toReGame" {
            if let foodGameViewController = segue.destination as? FoodGameViewController {
                foodGameViewController.location = self.location
                foodGameViewController.mymap = self.mymap
            }
        }
    }
    
    @IBAction func EatAction(_ sender: Any) {
        audiocontroller.playerEffect(name: SoundDing)
    }
    
    @IBAction func NotEatAction(_ sender: Any) {
        audiocontroller.playerEffect(name: SoundDing)
    }
    
    func setupGame() {
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.subtractTime), userInfo: nil, repeats: true)
    }
    
    @objc func subtractTime() {
        audiocontroller.playerEffect(name: SoundParticle)
        let explore = RandomExplodeView(frame: CGRect(x: randomFloat(min: 20.0, max: backgroundView.frame.maxX - 20.0),
                                                      y: randomFloat(min: 20.0, max: backgroundView.frame.maxY - 20.0),
                                                      width: randomFloat(min: 3, max: 20), height: randomFloat(min: 3, max: 20)))
        backgroundView.addSubview(explore)
        backgroundView.sendSubview(toBack: explore)
    }
    
    func randomFloat(min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * (max - min) + min
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        audiocontroller.preloadAudioEffects(audioFileNames: AudioEffectFiles)
        imageView.image = image[resultFood]
        switch resultFood {
        case 0:
            foodName = "한식"
        case 1:
            foodName = "일식"
        case 2:
            foodName = "중식"
        case 3:
            foodName = "치킨"
        case 4:
            foodName = "피자"
        case 5:
            foodName = "분식"
        case 6:
            foodName = "디저트"
        case 7:
            foodName = "야식"
        default:
            foodName = "음식"
        }
        setupGame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
