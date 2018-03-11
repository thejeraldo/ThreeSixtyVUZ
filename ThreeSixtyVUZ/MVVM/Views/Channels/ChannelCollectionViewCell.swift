//
//  ChannelCollectionViewCell.swift
//  ThreeSixtyVUZ
//
//  Created by Jerald Abille on 2/21/18.
//  Copyright © 2018 Jeraldo Abille. All rights reserved.
//

import UIKit
import AlamofireImage

class ChannelCollectionViewCell: UICollectionViewCell {

  // MARK: - IBOutlets

  @IBOutlet weak var imageView: UIImageView! {
    didSet {
      imageView.layer.cornerRadius = 4
      imageView.clipsToBounds = true
    }
  }
  @IBOutlet weak var lockImageView: UIImageView! {
    didSet {
      let lockImage = UIImage(named: "lock", in: Bundle.main, compatibleWith: nil)
      let lockImageTemplateRender = lockImage!.withRenderingMode(.alwaysTemplate)
      lockImageView.image = lockImageTemplateRender
      lockImageView.alpha = 0.75
      lockImageView.backgroundColor = UIColor(named: "ActionButton")
      lockImageView.clipsToBounds = true
      lockImageView.layer.cornerRadius = 4
    }
  }
  @IBOutlet weak var subscribeLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!

  // MARK: -

  func setupWithChannel(_ channel: Channel) {
    let url = URL(string: channel.image!)
    self.imageView.af_setImage(withURL: url!)
    self.nameLabel.text = channel.title
    self.lockImageView.isHidden = channel.liveType == "free"
    self.subscribeLabel.isHidden = channel.liveType == "free"
  }
}
