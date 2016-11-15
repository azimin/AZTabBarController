//
//  ThirdViewController.swift
//  AZTabBarController
//
//  Created by Alex Zimin on 15/11/2016.
//  Copyright © 2016 Alexander Zimin. All rights reserved.
//

import UIKit
import AZTabBarController

class ThirdViewController: UIViewController {
  
  // You have to override this method for custom tab bar items
  override func az_tabBarItemContentView() -> AZTabBarItemView {
    
    // Now supports only class + xib pairs
    let tab = FashionTabBarItem.loadViewFromNib()
    
    tab.imageView.image = UIImage(named: "img_fave")
    tab.bottomLabel.text = "Fave"
    
    return tab
  }
  
}
