//
//  SecondViewController.swift
//  iOS Example
//
//  Created by Alex Zimin on 15/11/2016.
//  Copyright © 2016 Alexander Zimin. All rights reserved.
//

import UIKit
import AZTabBarController

class SecondViewController: UIViewController {
  
  // You have to override this method for custom tab bar items
  override func az_tabBarItemContentView() -> AZTabBarItemView {

    // Now supports only class + xib pairs
    let tab = MiddleTabBarItem.loadViewFromNib()

    // You can setup specific height for elements
    tab.heightValue = 50

    return tab
  }

  @IBAction func changeTabBarSizeAction(_ sender: UIButton) {
    // You can change prefered height in code (default can be set up on storyboard as @IBInspectable proprty of AZTabBarController
    self.az_tabBarController?.preferedHeight = 125
  }

}
