//
//  RewriteViewController.swift
//  FlickDemo
//
//  Created by 三斗 on 6/15/16.
//  Copyright © 2016 com.streamind. All rights reserved.
//

import UIKit

class RewriteViewController: UIViewController {
  var rewriteView = backgroundView()
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(rewriteView)
    rewriteView.snp_makeConstraints { (make) in
      make.edges.equalTo(view)
    }
  }
}
