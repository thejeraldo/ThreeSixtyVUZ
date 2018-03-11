//
//  CategoriesHeaderView.swift
//  ThreeSixtyVUZ
//
//  Created by Jerald Abille on 2/21/18.
//  Copyright © 2018 Jeraldo Abille. All rights reserved.
//

import UIKit

class CategoriesHeaderView: UITableViewHeaderFooterView {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var seeAllButton: UIButton!
  var shouldHideSeeAllButton: Bool! = true {
    didSet {
      self.seeAllButton.isHidden = shouldHideSeeAllButton
    }
  }

  func setup() {
    let seeAll = "\("See All")  \u{f105}"
    let string: NSMutableAttributedString = NSMutableAttributedString(string: seeAll)
    string.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 13), range: NSMakeRange(0, "See All".count + 1))
    string.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "FontAwesome", size: 15)!, range: NSMakeRange("See All".count + 2, 1))
    self.seeAllButton.setAttributedTitle(string, for: .normal)
  }
}