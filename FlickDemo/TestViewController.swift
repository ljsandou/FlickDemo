//
//  TestViewController.swift
//  FlickDemo
//
//  Created by 三斗 on 6/14/16.
//  Copyright © 2016 com.streamind. All rights reserved.
//

import UIKit
import Koloda

class TestViewController: UIViewController {

  @IBOutlet weak var flickView: KolodaView!
  var dataArray = [["title":"justTest","imageName":"123"],["title":"justTest","imageName":"dance"],["title":"justTest","imageName":"location"]]
  override func viewDidLoad() {
    super.viewDidLoad()
    flickView.delegate = self
    flickView.dataSource = self
  }
  
}
extension TestViewController:KolodaViewDelegate,KolodaViewDataSource{
  func kolodaNumberOfCards(koloda: KolodaView) -> UInt {
    return UInt(dataArray.count)
  }
  
  func koloda(koloda: KolodaView, viewForCardAtIndex index: UInt) -> UIView {
    let imageName = dataArray[Int(index)]["imageName"]
    return UIImageView(image: UIImage(named: imageName!))
  }
  
  func koloda(koloda: KolodaView, viewForCardOverlayAtIndex index: UInt) -> OverlayView? {
    return NSBundle.mainBundle().loadNibNamed("overLayView", owner: self, options: nil)[0] as? OverlayView
  }
  
}