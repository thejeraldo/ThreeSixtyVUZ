//
//  VideoTableViewCell.swift
//  ThreeSixtyVUZ
//
//  Created by Jerald Abille on 3/4/18.
//  Copyright © 2018 Jeraldo Abille. All rights reserved.
//

import UIKit

class VideoTableViewCell: UITableViewCell {
  @IBOutlet weak var videoImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var likesLabel: UILabel!
  @IBOutlet weak var viewsLabel: UILabel!

  
  func setupWithViewModel(_ viewModel: VideoViewModel) {
    self.titleLabel.text = viewModel.titleText
    self.likesLabel.text = viewModel.likesText
    if let imageURL = viewModel.imageURL {
      self.videoImageView.af_setImage(withURL: imageURL)
    } else {
      self.videoImageView.image = nil
    }
    
    self.videoImageView.layer.cornerRadius = 2
    self.videoImageView.clipsToBounds = true
    self.videoImageView.layer.borderColor = UIColor.lightGray.cgColor
    self.videoImageView.layer.borderWidth = 1
  }
}
