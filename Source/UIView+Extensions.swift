//
//  UIView+Extensions.swift
//  AZTabBarController
//
//  Created by Alex Zimin on 15/11/2016.
//  Copyright © 2016 Alexander Zimin. All rights reserved.
//

import UIKit

internal extension UIView {
  class func az_viewFromNib() -> Self {
    return self.az_viewFromNib(withOwner: nil)
  }
  
  class func az_viewFromNib(withOwner owner: Any?) -> Self {
    let name = NSStringFromClass(self as! AnyClass).components(separatedBy: ".").last!
    let view = UINib(nibName: name, bundle: nil).instantiate(withOwner: owner, options: nil).first!
   // assert((view is self), nil)
    return cast(view)!
  }
  
  func az_loadFromNibIfEmbeddedInDifferentNib() -> Self {
    // based on: http://blog.yangmeyer.de/blog/2012/07/09/an-update-on-nested-nib-loading
    let isJustAPlaceholder = self.subviews.count == 0
    if isJustAPlaceholder {
      let theRealThing = type(of: self).az_viewFromNib(withOwner: nil)
      theRealThing.frame = self.frame
      self.translatesAutoresizingMaskIntoConstraints = false
      theRealThing.translatesAutoresizingMaskIntoConstraints = false
      return theRealThing
    }
    return self
  }
}

private func cast<T, U>(_ value: T) -> U? {
  return value as? U
}
