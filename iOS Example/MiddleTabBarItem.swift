//
//  MiddleTabBarItem.swift
//  AZTabBarController
//
//  Created by Alex Zimin on 15/11/2016.
//  Copyright © 2016 Alexander Zimin. All rights reserved.
//

import UIKit
import CoreGraphics
import AZTabBarController

class MiddleTabBarItem: AZTabBarItemView {
  @IBOutlet weak var textLabel: UILabel!
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    textLabel.textColor = selected ? UIColor.black : UIColor.black.withAlphaComponent(0.6)
    backgroundColor = selected ? UIColor.green : UIColor.lightGray
  }
}
