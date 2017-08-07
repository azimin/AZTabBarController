//
//  FashionTabBarItem.swift
//  AZTabBarController
//
//  Created by Alex Zimin on 15/11/2016.
//  Copyright © 2016 Alexander Zimin. All rights reserved.
//

import UIKit
import CoreGraphics
import AZTabBarController

class FashionTabBarItem: AZTabBarItemView {
  
  @IBOutlet weak var topLabel: UILabel!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var bottomLabel: UILabel!
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    topLabel.text = selected ? "Selected" : "Unselected"
    backgroundColor = selected ? UIColor.green : UIColor.lightGray
    
    if selected && animated {
      imageView.shake(coefficient: 1, duration: 0.35)
    }
  }

  override var accessibilityTitle: String {
    return bottomLabel.text ?? super.accessibilityTitle
  }
}


extension UIView {
  func shake(coefficient: CGFloat = 1, duration: Double = 0.5) {
    let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
    animation.duration = duration
    animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ].map({ (value) -> CGFloat in
      return value * coefficient
    })
    layer.add(animation, forKey: "shake")
  }
}
