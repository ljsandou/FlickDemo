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
  var scaleToWidth = 0.95
  var dataArray = [["image":"first","label":"first"],["image":"more","label":"more"],["image":"picture","label":"picture"],["image":"star","label":"star"]]
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
        cardLoadedNumber += 1
        loadedCards.append(flickview)
      }
    }
    for i in 0..<loadedCards.count{
      if i>0{
         self.insertSubview(loadedCards[i], belowSubview: loadedCards[i-1])
        loadedCards[i].snp_makeConstraints(closure: { (make) in
          make.centerX.equalTo(self.snp_centerX)
          make.centerY.equalTo(self.snp_centerY).offset(i*5)
          make.width.equalTo(cardWidth*CGFloat(pow((scaleToWidth), Double(i))))
          make.height.equalTo(cardHeight)
        })
      }else{
        self.addSubview(loadedCards[i])
        loadedCards[i].snp_makeConstraints(closure: { (make) in
          make.center.equalTo(self.snp_center)
          make.width.equalTo(cardWidth)
          make.height.equalTo(cardHeight)
        })
      }
      
    }
  }
  
  func removeCards(tag: Int, likeOrNot: Bool) {
    if cardLoadedNumber < dataArray.count{
      loadedCards.removeAtIndex(tag)
      let flickview = makeFlickView(cardLoadedNumber)
      self.insertSubview(flickview, belowSubview: loadedCards[maxCardsNumber-2])
      loadedCards.append(flickview)
      cardLoadedNumber += 1
      UIView.animateWithDuration(0.2, animations: {
        self.loadedCards[self.loadedCards.count-1].snp_makeConstraints(closure: { (make) in
          make.centerX.equalTo(self.snp_centerX)
          make.centerY.equalTo(self.snp_centerY).offset(self.cardLoadedNumber*5)
          make.width.equalTo(self.cardWidth*CGFloat(pow((self.scaleToWidth), Double(self.cardLoadedNumber))))
          make.height.equalTo(self.cardHeight)
        })
        }, completion: { (finish) in
      })
      
    }
  }
  
  func makeFlickView(index:Int) -> FlickView{
    let flickview = FlickView()
    flickview.datasource = self
    flickview.configWithData(dataArray[index])
    flickview.tag = cardLoadedNumber
    return flickview
  }
  
}
