//
//  layoverView.swift
//  FlickDemo
//
//  Created by 三斗 on 6/15/16.
//  Copyright © 2016 com.streamind. All rights reserved.
//

import UIKit

enum GestureDirection{
  case Left,Right
}
class LayoverView: UIView {
  var imageview = UIImageView()
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(frame:CGRect) {
    super.init(frame:frame)
    self.addSubview(imageview)
  }
  
  
  //MARK:- judge gesture left or right
  func setMode(mode:GestureDirection){
    switch mode{
    case .Left:
      imageview.image = UIImage(named: "ok")
    case .Right:
      imageview.image = UIImage(named: "error")
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    imageview.frame = self.frame
  }
  
}
