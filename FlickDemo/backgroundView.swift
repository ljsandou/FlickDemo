//
//  backgroundView.swift
//  FlickDemo
//
//  Created by 三斗 on 6/15/16.
//  Copyright © 2016 com.streamind. All rights reserved.
//

import UIKit

class backgroundView: UIView,CardSource{
  var maxCardsNumber = 3
  var cardLoadedNumber = 0
  var cardHeight:CGFloat = 300
  var cardWidth:CGFloat = 200
  var scaleToWidth:CGFloat = 0.95
  var dataArray = [["image":"first","label":"first"],["image":"more","label":"more"],["image":"picture","label":"picture"],["image":"star","label":"star"],["image":"location","label":"location"]]
  var loadedCards = [FlickView]()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    loadCards()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func  loadCards(){
    if dataArray.count >= maxCardsNumber{
      for index in 0..<maxCardsNumber{
        let flickview = makeFlickView(index)
        // print(flickview.tag)
        cardLoadedNumber += 1
        loadedCards.append(flickview)
      }
    }
    for i in 0..<loadedCards.count{
      if i>0{
        self.insertSubview(loadedCards[i], belowSubview: loadedCards[i-1])
      }else{
        self.addSubview(loadedCards[i])
      }
      UIView.animateWithDuration(0.2, delay: 0, usingSpringWithDamping: 0, initialSpringVelocity: 0, options: .CurveEaseIn, animations: {
        self.makeFlickViewWithFlag(i)
        }, completion: { (finish) in
      })
    }
  }
 //MARK:- Common Func
  
  func makeFlickViewWithFlag(i:Int){
    loadedCards[i].snp_makeConstraints(closure: { (make) in
      make.centerX.equalTo(self.snp_centerX)
      make.centerY.equalTo(self.snp_centerY)
      make.width.equalTo(cardWidth)
      make.height.equalTo(cardHeight)
    })
    UIView.animateWithDuration(0.2) {
      let scale = CGFloat(pow(Double(self.scaleToWidth), Double(i)))
      let transform = CGAffineTransformMakeScale(scale,scale)
      self.loadedCards[i].transform = CGAffineTransformTranslate(transform, 0, 15*CGFloat(i))
    }
  }
  
  
  func makeFlickView(index:Int) -> FlickView{
    let flickview = FlickView()
    flickview.datasource = self
    flickview.configWithData(dataArray[index])
    flickview.tag = cardLoadedNumber
    return flickview
  }
  
  // MARK:- realize Protrol
  func postScaleToBackgroundView(scale: CGFloat) {
    for i in 0..<loadedCards.count - 1{
      let scaleValue = CGFloat(pow(Double(scale), Double(i+1)))
      let transform = CGAffineTransformMakeScale(scaleValue,scaleValue)
      self.loadedCards[i+1].transform = CGAffineTransformTranslate(transform, 0, CGFloat(i+1)*scale*15)
    }
  }
  
  func removeCards(tag: Int, likeOrNot: Bool) {
    loadedCards.removeFirst()
    if cardLoadedNumber < dataArray.count{
      let flickview = makeFlickView(cardLoadedNumber)
      loadedCards.append(flickview)
      cardLoadedNumber += 1
    }
    
    UIView.animateWithDuration(0.2, delay: 0, usingSpringWithDamping: 0, initialSpringVelocity: 0, options: .CurveEaseIn, animations: {
      for i in 0..<self.loadedCards.count{
        if i>0{
          self.insertSubview(self.loadedCards[i], belowSubview: self.loadedCards[i-1])
        }else{
          self.addSubview(self.loadedCards[i])
        }
        UIView.animateWithDuration(0.2, delay: 0, usingSpringWithDamping: 0, initialSpringVelocity: 0, options: .CurveEaseIn, animations: {
          self.makeFlickViewWithFlag(i)
          }, completion: { (finish) in
        })
      }
      }, completion: { (finish) in
    })
  }
  
}
