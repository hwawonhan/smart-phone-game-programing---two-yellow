//
//  ViewController.swift
//  노랭이맛집탐험
//
//  Created by kpugame on 2018. 5. 7..
//  Copyright © 2018년 hwawonhan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var audiocontroller:AudioController = AudioController()
    override func viewDidLoad() {
        super.viewDidLoad()
        audiocontroller.preloadAudioEffects(audioFileNames: AudioEffectFiles)
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func Action7(_ sender: Any) {
        audiocontroller.playerEffect(name: SoundDing)
    }
    
    @IBAction func Action8(_ sender: Any) {
        audiocontroller.playerEffect(name: SoundDing)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

