//
//  RandomExplodeView.swift
//  노랭이맛집탐험
//
//  Created by kpugame on 2018. 6. 9..
//  Copyright © 2018년 hwawonhan. All rights reserved.
//

import UIKit

class RandomExplodeView: UIView {
    //CAEmitterLayer 변수
    private var emitter: CAEmitterLayer!
    //UIView class 메소드 : CALayer 가 아니라 CAEmitterLayer 리턴
    override class var layerClass: AnyClass {
        return CAEmitterLayer.self
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init(frame: ")
    }
    
    func randomFloat(min: Float, max: Float) -> Float {
        return Float(Float(arc4random()) / Float(UINT32_MAX)) * (max - min) + min
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //파티클 표현을 위해서 emitter cell을 생성하고 설정
        emitter = self.layer as! CAEmitterLayer
        emitter.emitterPosition = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
        emitter.emitterSize = self.bounds.size
        emitter.emitterMode = kCAEmitterLayerAdditive
        emitter.emitterShape = kCAEmitterLayerRectangle
    }
    
    override func didMoveToSuperview() {
        //1. 부모의 didMoveToSuperView()를 호출하고 superview가 없다면 exit
        super.didMoveToSuperview()
        if self.superview == nil {
            return
        }
        //2. particle.png 파일 UIImage로 로딩
        let texture: UIImage? = UIImage(named: "starParticle")
        assert(texture != nil, "particle image not found")
        //3. emitterCell 생성, 뒤에는 설정
        let emitterCell = CAEmitterCell()
        
        emitterCell.name = "cell"               //name 설정
        emitterCell.contents = texture?.cgImage //contents는 texture 이미지로
        emitterCell.birthRate = 200     //1초에 200개 생성
        emitterCell.lifetime = randomFloat(min: 0.5, max: 1.25)     //1개 particle는 0.75초 동안 생존
        emitterCell.redRange = randomFloat(min: 0.1, max: 1.0)          //랜덤색깔 rgb(1,1,1) ~ (1,1,0.67)white~orange
        emitterCell.greenRange = randomFloat(min: 0.1, max: 1.0)    //랜덤색깔 rgb(1,1,1) ~ (1,1,0.67)white~orange
        emitterCell.blueRange = randomFloat(min: 0.1, max: 1.0)    //랜덤색깔 rgb(1,1,1) ~ (1,1,0.67)white~orange
        emitterCell.redSpeed = randomFloat(min: -0.99, max: -0.09)   //시간이 지나면서 blue 색을 줄인다.
        emitterCell.greenSpeed = randomFloat(min: -0.99, max: -0.09)   //시간이 지나면서 blue 색을 줄인다.
        emitterCell.blueSpeed = randomFloat(min: -0.99, max: -0.09)   //시간이 지나면서 blue 색을 줄인다.
        emitterCell.velocity = 100      //셀의 속도 범위 160-40 ~ 160+40
        emitterCell.velocityRange = 30
        emitterCell.scaleRange = 0.5   //셀크기 1.0-0.5 ~ 1.0+0.5
        emitterCell.scaleSpeed = -0.2   //셀크기 감소 속도
        emitterCell.emissionRange = CGFloat(Double.pi * 2)  //셀생성 방향 360도
        emitter.emitterCells = [emitterCell] //emitterCell 배열에 넣는다.
        //2초 후에 파티클 remove
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.removeFromSuperview()
        })
    }
    
}

