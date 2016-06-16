//
//  FlickView.swift
//  FlickDemo
//
//  Created by 三斗 on 6/15/16.
//  Copyright © 2016 com.streamind. All rights reserved.
//

import UIKit
import SnapKit

protocol CardSource {
  func removeCards(tag:Int,likeOrNot:Bool)
  func postScaleToBackgroundView(scale:CGFloat)
}

class FlickView: UIView {
  
  var imageView = UIImageView()
  var label = UILabel()
  var layView = LayoverView()
  var panGesture:UIPanGestureRecognizer!
  var orginPoint:CGPoint!
  var distanceToPush:CGFloat = 120
  var datasource:CardSource!
  var scaleRatio:CGFloat = 0.95
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUpView()
    setPanGesture()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setUpView(){
    addSubview(imageView)
    layer.masksToBounds = true
    layer.cornerRadius = 3
    layer.borderWidth = 1
    layer.borderColor = UIColor.lightGrayColor().CGColor
    backgroundColor = UIColor.groupTableViewBackgroundColor()
    imageView.snp_makeConstraints { (make) in
      make.bottom.equalTo(self).offset(-40)
      make.left.top.equalTo(self).offset(20)
      make.right.equalTo(self).offset(-20)
    }
    
    self.addSubview(label)
    label.textAlignment = .Center
    label.snp_makeConstraints { (make) in
      make.left.right.bottom.equalTo(self)
      make.top.equalTo(imageView.snp_bottom)
      // make.height.equalTo(40)
    }
    
    self.addSubview(layView)
    
    layView.snp_makeConstraints { (make) in
      make.top.left.right.equalTo(self)
      make.height.equalTo(100)
    }
  }
  
  func setPanGesture(){
    panGesture = UIPanGestureRecognizer(target: self, action: #selector(FlickView.makeAnimate(_:)))
    self.addGestureRecognizer(panGesture)
  }
  
  func configWithData(data:[String:String]){
    imageView.image = UIImage(named: data["image"]!)
    label.text = data["label"]
  }
  
  func makeAnimate(sender:UIPanGestureRecognizer){
    let location = sender.translationInView(self)
    switch sender.state {
    case .Began:  orginPoint = self.center
    case .Changed:
      let rotationStrength = min(location.x/320, 1)
      let rotationAngle = (2*CGFloat(M_PI)*rotationStrength/16)
      let scaleStrength = 1 - fabs(rotationAngle)/4
      let scale = max(scaleStrength, 0.93)
      self.center = CGPointMake(orginPoint.x + location.x, orginPoint.y + location.y)
      let transform = CGAffineTransformMakeRotation(rotationAngle)
      let scaleTransform = CGAffineTransformScale(transform, scale, scale)
      self.transform = scaleTransform
      
      let  scaleForBakcgroundView = min(max(fabs(location.x/(distanceToPush*20))+scaleRatio,scaleRatio),0.97)
      datasource.postScaleToBackgroundView(scaleForBakcgroundView)
      updateLayoverView(location.x)
    case .Ended:
      pendViewStatus(location)
      datasource.postScaleToBackgroundView(scaleRatio)
    default: break
    }
  }
  
  func updateLayoverView(distance:CGFloat){
    let alpha = min((fabs(distance)/100),0.6)
    layView.alpha = alpha
    if distance > 0{
      layView.setMode(GestureDirection.Left)
    }else if distance<0{
      layView.setMode(GestureDirection.Right)
    }
  }
  
  func pendViewStatus(distance:CGPoint){
    if distance.x > distanceToPush{
      leftAction(distance)
    }else if distance.x < -distanceToPush{
      rightAction(distance)
    }else{
      UIView.animateWithDuration(0.2, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.8, options: .CurveEaseInOut, animations: {
        self.center = self.orginPoint
        self.layView.alpha = 0
        self.transform = CGAffineTransformIdentity
      }) { (finish) in
        
      }
    }
  }
  
  
  //MARK: you can do something in Below Func
  func leftAction(distance:CGPoint){
    UIView.animateWithDuration(0.5, animations: {
      self.center = CGPointMake(1000,distance.y*1000/distance.x)
    }) { (finish) in
      self.removeFromSuperview()
      if let dataSource = self.datasource{
        dataSource.removeCards(self.tag, likeOrNot: true)
      }
    }
  }
  
  func rightAction(distance:CGPoint){
    UIView.animateWithDuration(0.5, animations: {
      self.center = CGPointMake(-1000,distance.y*(-1000)/distance.x)
    }) { (finish) in
      self.removeFromSuperview()
      if let dataSource = self.datasource{
        dataSource.removeCards(self.tag, likeOrNot: false)
      }
    }
  }
}
