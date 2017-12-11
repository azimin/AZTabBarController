//
//  AZTabBarController.swift
//  AZTabBarController
//
//  Created by Alex Zimin on 15/11/2016.
//  Copyright © 2016 Alexander Zimin. All rights reserved.
//

import Foundation

private let defaultHeight: CGFloat = 49

open class AZTabBarItemView: UIView {
  public var heightValue: CGFloat?
  var preferedHeight: CGFloat {
    return heightValue ?? _preferedHeight
  }

  fileprivate var _preferedHeight: CGFloat = defaultHeight
  fileprivate weak var heightConstraint: NSLayoutConstraint!

  fileprivate(set) var index: Int = 0

  private var _isSelected: Bool = false
  public var isSelected: Bool {
    return _isSelected
  }

  /// DON"T CALL IT MANUALLY, JUST FOR OVERRIDING
  open func setSelected(_ selected: Bool, animated: Bool) {
    _isSelected = selected
  }

  public static func loadViewFromNib() -> Self {
    return self.init().az_loadFromNibIfEmbeddedInDifferentNib()
  }
}

public class AZTabBarItem: UITabBarItem {
  fileprivate var containerView: AZTabBarItemView!

  public var index: Int {
    return containerView.index
  }

  public var isSelected: Bool {
    get {
      return containerView.isSelected
    }
  }

  fileprivate func setSelected(_ selected: Bool, animated: Bool) {
    containerView.setSelected(selected, animated: animated)
  }
}

public class AZTabBar: UITabBar {
  fileprivate var preferedHeight: CGFloat = defaultHeight
  fileprivate weak var az_tabBarController: AZTabBarController?

  // MARK: - Override default methods

  override public func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    for item in az_tabBarController?.az_items ?? [] {
      if item.containerView.frame.contains(point) {
        return true
      }
    }
    return super.point(inside: point, with: event)
  }

  override public func sizeThatFits(_ size: CGSize) -> CGSize {
    var size = super.sizeThatFits(size)
    size.height = preferedHeight
    return size
  }

  override public var alpha: CGFloat {
    didSet {
      for view in subviews {
        if view is AZTabBarItemView {
          view.alpha = alpha
        } else {
          view.alpha = 0.0
        }
      }
    }
  }

  override public func addSubview(_ view: UIView) {
    if view is AZTabBarItemView {
      super.addSubview(view)
    } else {
      super.insertSubview(view, at: 0)
    }
  }
}

extension UIViewController {
  @objc open func az_tabBarItemContentView() -> AZTabBarItemView {
    fatalError("Must be implemented in subclass")
  }

  public var az_tabBarController: AZTabBarController? {
    return self.tabBarController as? AZTabBarController
  }
}

public class AZTabBarController: UITabBarController {

  @IBInspectable public var preferedHeight: CGFloat = defaultHeight {
    didSet {
      az_tabBar.preferedHeight = preferedHeight
      view.setNeedsLayout()
      selectedViewController?.view.setNeedsLayout()
    }
  }

  public var az_tabBar: AZTabBar {
    return self.tabBar as! AZTabBar
  }

  public var az_items: [AZTabBarItem] {
    let items = tabBar.items as? [AZTabBarItem]
    assert(items != nil, "All tab bar items must be `AZTabBarItem` class")
    return items ?? []
  }

  override public func viewDidLoad() {
    super.viewDidLoad()
    assert(tabBar is AZTabBar, "tabBar class must be `AZTabBar` class")
    az_tabBar.az_tabBarController = self
    az_createViewContainers()
  }

  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()

    for item in az_items {
      item.containerView._preferedHeight = self.preferedHeight
      item.containerView.heightConstraint.constant = item.containerView.preferedHeight
    }
  }

  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
  }

  // MARK: - Setup

  private func az_createViewContainers() {
    for (index, item) in az_items.enumerated() {
      let viewContainer = az_setupView(onItem: item, index: index)

      if index == selectedIndexOrZero {
        item.setSelected(true, animated: false)
      } else {
        item.setSelected(false, animated: false)
      }

      tabBar.addSubview(viewContainer)
      tabBar.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor).isActive = true

      if index > 0 {
        az_items[index - 1].containerView.rightAnchor.constraint(equalTo: viewContainer.leftAnchor).isActive = true
        az_items[index - 1].containerView.widthAnchor.constraint(equalTo: viewContainer.widthAnchor).isActive = true
      }
    }

    if let firstItem = az_items.first, let lastItem = az_items.last {
      tabBar.leftAnchor.constraint(equalTo: firstItem.containerView.leftAnchor).isActive = true
      tabBar.rightAnchor.constraint(equalTo: lastItem.containerView.rightAnchor).isActive = true
    }

    tabBar.alpha = 1
    tabBar.shadowImage = UIImage()
    tabBar.backgroundImage = UIImage()
    selectedIndex = selectedIndexOrZero
  }

  private func az_setupView(onItem item: AZTabBarItem, index: Int) -> AZTabBarItemView {
    let viewContainer = az_tabBarItem(forViewController: self.viewControllers![index])
    viewContainer.index = index
    viewContainer._preferedHeight = self.preferedHeight

    let tapGesture = UILongPressGestureRecognizer(target: self, action: #selector(AZTabBarController.az_tapHandler(_:)))
    tapGesture.minimumPressDuration = 0
    viewContainer.addGestureRecognizer(tapGesture)

    viewContainer.heightConstraint = viewContainer.heightAnchor.constraint(equalToConstant: viewContainer.preferedHeight)
    viewContainer.heightConstraint.isActive = true

    item.containerView = viewContainer
    return viewContainer
  }

  private func az_tabBarItem(forViewController viewController: UIViewController) -> AZTabBarItemView {
    if let navigationController = viewController as? UINavigationController {
      return navigationController.viewControllers.first?.az_tabBarItemContentView() ?? viewController.az_tabBarItemContentView()
    }
    return viewController.az_tabBarItemContentView()
  }

  // MARK: - Actions

  @objc private func az_tapHandler(_ gesture: UIGestureRecognizer) {
    let currentIndex = (gesture.view as! AZTabBarItemView).index
    az_setSelectedIndex(currentIndex, oldIndex: selectedIndex)
  }

  var selectedIndexOrZero: Int {
    return selectedIndex < (viewControllers?.count ?? 0) ? selectedIndex : 0
  }

  public override var selectedIndex: Int {
    didSet {
      // If inicialize value is wrong, don't unselect anything
      if oldValue < (viewControllers?.count ?? 0) {
        az_setSelectedIndex(selectedIndex, oldIndex: oldValue)
      }
    }
  }

  private func az_setSelectedIndex(_ currentIndex: Int, oldIndex: Int?) {
    if oldIndex != currentIndex {
      let selectedItem: AZTabBarItem = az_items[currentIndex]
      selectedItem.setSelected(true, animated: true)

      if let oldIndex = oldIndex {
        let deselectedItem = az_items[oldIndex]
        deselectedItem.setSelected(false, animated: true)
      }

      selectedIndex = currentIndex
    }
  }
}
