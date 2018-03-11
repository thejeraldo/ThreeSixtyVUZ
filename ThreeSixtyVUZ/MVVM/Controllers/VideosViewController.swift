//
//  VideosViewController.swift
//  ThreeSixtyVUZ
//
//  Created by Jerald Abille on 3/5/18.
//  Copyright © 2018 Jeraldo Abille. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class VideosViewController: UITableViewController {
  
  // MARK: - Properties
  
  var videos: [Video]?
  
  // MARK: - Initializations
  
  init(category: Category) {
    super.init(nibName: nil, bundle: Bundle.main)
    
    self.title = category.name
    
    SVProgressHUD.show()
    Category.fetchVideosForCategory(category, success: { videos in
      SVProgressHUD.dismiss()
      self.videos = videos
      self.tableView.reloadData()
    }) { error in
      SVProgressHUD.showError(withStatus: "Something went wrong.")
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - View Controller Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let videoTableViewCellNib = UINib(nibName: "VideoTableViewCell", bundle: Bundle.main)
    tableView.register(videoTableViewCellNib, forCellReuseIdentifier: "videoCell")
    tableView.separatorStyle = .none
    tableView.tableFooterView = UIView()
    tableView.reloadData()
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

// MARK: - UITableViewDataSource

extension VideosViewController {
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let count = self.videos?.count {
      return count
    }
    return 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: VideoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "videoCell") as! VideoTableViewCell
    let video = self.videos?[indexPath.row]
    let viewModel = VideoViewModel(video: video!)
    cell.setupWithViewModel(viewModel)
    cell.selectionStyle = .none
    return cell
  }
  
  
}

// MARK: - UITableViewDelegate

extension VideosViewController {
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 88
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let video = self.videos?[indexPath.row] {
      print("\(video)")
      let videoViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
      videoViewController.videoViewModel = VideoViewModel(video: video)
      self.present(videoViewController, animated: true, completion: nil)
    }
  }
}
