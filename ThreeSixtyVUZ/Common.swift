//
//  Common.swift
//  ThreeSixtyVUZ
//
//  Created by Jerald Abille on 2/21/18.
//  Copyright © 2018 Jeraldo Abille. All rights reserved.
//

import Foundation
import UIKit

class Common {
  class func appTitleLabel() -> UILabel {
    let label = UILabel()
    let string = NSMutableAttributedString(string: "360VUZ")
    string.addAttribute(NSAttributedStringKey.font, value: UIFont(name: Font.monofonto, size: 24), range: NSMakeRange(0, 6))
    string.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range: NSMakeRange(0, 3))
    string.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor(named: Color.primaryLight), range: NSMakeRange(3, 3))
    label.attributedText = string
    label.sizeToFit()
    return label
  }

  class func isIPhoneX() -> Bool {
    return UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436
  }
}

extension UINavigationController {
  open override var childViewControllerForStatusBarStyle: UIViewController? {
    return self.topViewController
  }
  open override var childViewControllerForStatusBarHidden: UIViewController? {
    return self.topViewController
  }
}

extension UITabBarController {
  open override var childViewControllerForStatusBarStyle: UIViewController? {
    return self.childViewControllers.first
  }
  open override var childViewControllerForStatusBarHidden: UIViewController? {
    return self.childViewControllers.first
  }
}