//
//  ChannelsTableViewCell.swift
//  ThreeSixtyVUZ
//
//  Created by Jerald Abille on 2/21/18.
//  Copyright © 2018 Jeraldo Abille. All rights reserved.
//

import UIKit

class ChannelsTableViewCell: UITableViewCell {

  // MARK: - Instance Properties

  private var channels: [Channel]?
  fileprivate let layout: UICollectionViewFlowLayout = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumInteritemSpacing = 8
    layout.minimumLineSpacing = 8
    layout.itemSize = CGSize(width: 66, height: 102)
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

  func setupWithChannel(_ channels: [Channel]?) {
    self.channels = channels
    self.collectionView.reloadData()
  }
}

// MARK: - UICollectionViewDataSource

extension ChannelsTableViewCell: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if let count = self.channels?.count {
      return count
    }
    return 0
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChannelCell", for: indexPath) as! ChannelCollectionViewCell
    if let channel = self.channels?[indexPath.row] {
      cell.setupWithChannel(channel)
    }
    return cell
  }
}

// MARK: - UICollectionViewDelegate

extension ChannelsTableViewCell: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if let channel = self.channels?[indexPath.row] {
      print(channel.title ?? "")
    }
  }
}