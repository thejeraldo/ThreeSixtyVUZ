//
//  CategoriesTableViewCell.swift
//  ThreeSixtyVUZ
//
//  Created by Jerald Abille on 2/21/18.
//  Copyright © 2018 Jeraldo Abille. All rights reserved.
//

import UIKit

protocol CategoriesTableViewCellDelegate: class {
  func didSelectCategory(category: Category)
}

class CategoriesTableViewCell: UITableViewCell {
  
  weak var delegate: CategoriesTableViewCellDelegate?

  // MARK: Instance Properties

  private var categories: [Category]?
  fileprivate let layout: UICollectionViewFlowLayout = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumInteritemSpacing = 8
    layout.minimumLineSpacing = 8
    layout.itemSize = CGSize(width: 140, height: 97)
    layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    return layout
  }()

  // MARK: - IBOutlets
  
  @IBOutlet weak var collectionView: UICollectionView! {
    didSet {
      collectionView.dataSource = self as UICollectionViewDataSource
      collectionView.delegate = self as UICollectionViewDelegate
      collectionView.showsHorizontalScrollIndicator = false
    }
  }

  // MARK: -

  override func awakeFromNib() {
    super.awakeFromNib()
    self.collectionView.collectionViewLayout = layout
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

  func setupWithCategories(_ categories: [Category]?) {
    self.categories = categories
    self.collectionView.reloadData()
  }
}

// MARK: - UICollectionViewDataSource

extension CategoriesTableViewCell: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if let count = self.categories?.count {
      return count
    }
    return 0
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCollectionViewCell
    if let category = self.categories?[indexPath.row] {
      let categoryViewModel = CategoryViewModel(category: category)
      cell.setupWithViewModel(categoryViewModel)
    }
    return cell
  }
}

extension CategoriesTableViewCell: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if let category = self.categories?[indexPath.row] {
      self.delegate?.didSelectCategory(category: category)
    }
  }
}
