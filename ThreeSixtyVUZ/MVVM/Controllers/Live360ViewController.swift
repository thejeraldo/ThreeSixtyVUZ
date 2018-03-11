//
//  Live360ViewController.swift
//  ThreeSixtyVUZ
//
//  Created by Jerald Abille on 3/11/18.
//  Copyright © 2018 Jeraldo Abille. All rights reserved.
//

import UIKit
import SVProgressHUD

class Live360ViewController: UITableViewController {

  var videos: [Video]?

  override func viewDidLoad() {
    super.viewDidLoad()

    self.navigationItem.title = "Live 360 Videos".uppercased()

    let videoTableViewCellNib = UINib(nibName: "VideoTableViewCell", bundle: Bundle.main)
    tableView.register(videoTableViewCellNib, forCellReuseIdentifier: "videoCell")
    tableView.separatorStyle = .none
    tableView.tableFooterView = UIView()
    tableView.reloadData()

    SVProgressHUD.show()
    Video.fetchLive360Videos({ videos in
      SVProgressHUD.dismiss()
      self.videos = videos
      self.tableView.reloadData()
    }, failure: { error in
      SVProgressHUD.showError(withStatus: "Something went wrong.")
    })
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

// MARK: - UITableViewDataSource

extension Live360ViewController {
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

extension Live360ViewController {
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