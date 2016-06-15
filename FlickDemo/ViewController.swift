//
//  ViewController.swift
//  FlickDemo
//
//  Created by 三斗 on 6/14/16.
//  Copyright © 2016 com.streamind. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var flickView: UIView!
  var containerView:UIView!
  var animatior:UIDynamicAnimator!
  var panGesture:UIPanGestureRecognizer!
  var flickThreShold:CGFloat = 500
  var dampValue:CGFloat = 0.5
  var attachmentBehavior:UIAttachmentBehavior!
  var viewCount = 4
  var viewArray = [UIView]()
  var dataArray = [["image":"punch","label":"first"],["image":"image","label":"second"],["image":"dance","label":"third"]]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //setUp()
    configContainerView()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func setUp(){
    animatior = UIDynamicAnimator(referenceView: view)
    panGesture = UIPanGestureRecognizer(target: self, action: #selector(ViewController.handleAttachmentBehavior(_:)))
    flickView.addGestureRecognizer(panGesture)
  }
  
  func handleAttachmentBehavior(gesture:UIPanGestureRecognizer){
    let location = gesture.locationInView(view)
    let boxLocation = gesture.locationInView(flickView)
    switch gesture.state{
    case .Began:
      animatior.removeAllBehaviors()
      let contentOffset = UIOffset(horizontal: boxLocation.x - flickView.bounds.midX, vertical: boxLocation.y - flickView.bounds.midY)
      attachmentBehavior = UIAttachmentBehavior(item: flickView, offsetFromCenter: contentOffset, attachedToAnchor: location)
      animatior.addBehavior(attachmentBehavior)
    case .Ended:
      animatior.removeAllBehaviors()
      let velocity = panGesture.velocityInView(view)
      let threshold = sqrt((velocity.x*velocity.x) + (velocity.y*velocity.y))
      guard threshold > flickThreShold else{
        let snapBehavior = UISnapBehavior(item: flickView, snapToPoint: view.center)
        print(view.center)
        snapBehavior.damping = dampValue
        animatior.addBehavior(snapBehavior)
        return
      }
      let pushBehavior = UIPushBehavior(items: [flickView], mode: .Instantaneous)
      pushBehavior.pushDirection = CGVector(dx: velocity.x, dy: velocity.y)
      //magnitude设置速度大小，分母愈大速度越慢
      pushBehavior.magnitude = threshold/10
      animatior.addBehavior(pushBehavior)
      break
    default:
      attachmentBehavior.anchorPoint = location
      break
    }
    
  }
  
  func configContainerView(){
    for _ in 0..<viewCount{
      let cardView = flickView
      viewArray.append(cardView)
    }
  }
  
}

