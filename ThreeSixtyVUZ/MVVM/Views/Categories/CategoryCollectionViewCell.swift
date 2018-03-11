//
//  CategoryCollectionViewCell.swift
//  ThreeSixtyVUZ
//
//  Created by Jerald Abille on 2/21/18.
//  Copyright © 2018 Jeraldo Abille. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class CategoryCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  
  func setupWithViewModel(_ viewModel: CategoryViewModel) {
    self.backgroundColor = UIColor.groupTableViewBackground
    self.layer.borderWidth = 1
    self.layer.borderColor = UIColor.lightGray.cgColor
    self.layer.cornerRadius = 4
    self.clipsToBounds = true
    
    self.nameLabel.text = viewModel.nameText
    if let imageURL = viewModel.imageURL {
      self.imageView.af_setImage(withURL: imageURL)
    } else {
      self.imageView.image = nil
    }
  }

  func setupWithCategory(_ category: Category) {
    self.backgroundColor = UIColor.groupTableViewBackground
    self.layer.borderWidth = 1
    self.layer.borderColor = UIColor.lightGray.cgColor
    self.layer.cornerRadius = 4
    self.clipsToBounds = true

    self.nameLabel.text = category.name
    let url = URL(string: category.image!)
    self.imageView.af_setImage(withURL: url!)
  }
}
