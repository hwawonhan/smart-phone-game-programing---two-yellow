//
//  ExplodeView.swift
//  Anagrams
//
//  Created by KIMYOUNG SIK on 2018. 2. 13..
//  Copyright © 2018년 Caroline. All rights reserved.
//

import UIKit

class ExplodeView: UIView {
    //CAEmitterLayer 변수
    private var emitter: CAEmitterLayer!
    //UIView class 메소드 : CALayer 가 아니라 CAEmitterLayer 리턴
    override class var layerClass: AnyClass {
        return CAEmitterLayer.self
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init(frame: ")
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
        emitterCell.lifetime = 0.25     //1개 particle는 0.75초 동안 생존
        emitterCell.blueRange = 0.99
        emitterCell.blueSpeed = -0.99   //시간이 지나면서 blue 색을 줄인다.
        emitterCell.greenRange = 0.99    //랜덤색깔 rgb(1,1,1) ~ (1,1,0.67)white~orange
        emitterCell.greenSpeed = -0.99   //시간이 지나면서 blue 색을 줄인다.
        emitterCell.velocity = 160      //셀의 속도 범위 160-40 ~ 160+40
        emitterCell.velocityRange = 40
        emitterCell.scaleRange = 0.25   //셀크기 1.0-0.5 ~ 1.0+0.5
        emitterCell.scaleSpeed = -0.05   //셀크기 감소 속도
        emitterCell.emissionRange = CGFloat(Double.pi * 2)  //셀생성 방향 360도
        emitter.emitterCells = [emitterCell] //emitterCell 배열에 넣는다.
        //2초 후에 파티클 remove
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.removeFromSuperview()
        })
    }

}

