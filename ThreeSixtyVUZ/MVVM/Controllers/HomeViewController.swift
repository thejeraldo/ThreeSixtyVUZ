//
//  HomeViewController.swift
//  ThreeSixtyVUZ
//
//  Created by Jerald Abille on 2/20/18.
//  Copyright © 2018 Jeraldo Abille. All rights reserved.
//

import UIKit
import SVProgressHUD

class HomeViewController: UIViewController {
  
  // MARK: - Enums
  
  enum Section: Int {
    case categories = 0
    case channels = 1
    case videos = 2
  }
  
  // MARK: - Constants
  
  private let categoriesCellId = "CategoriesCell"
  
  // MARK: - Instance Properties
  
  var categories: [Category]?
  var channels: [Channel]?
  var trendingVideos: [Video]?
  
  private var refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.tintColor = UIColor(named: Color.primaryLight)
    refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    return refreshControl
  }()
  
  // MARK: - IBOutlets
  
  @IBOutlet weak var tableView: UITableView! {
    didSet {
      tableView.dataSource = self as UITableViewDataSource
      tableView.delegate = self as UITableViewDelegate
      tableView.backgroundColor = UIColor.white
      tableView.separatorStyle = .none
      tableView.tableFooterView = UIView()
      tableView.addSubview(refreshControl)
    }
  }
  
  // MARK: - View Controller Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationItem.titleView = Common.appTitleLabel()
    // self.automaticallyAdjustsScrollViewInsets = false
    
    let nib = UINib(nibName: "CategoriesHeaderView", bundle: Bundle.main)
    self.tableView.register(nib, forHeaderFooterViewReuseIdentifier: "CategoriesHeaderView")
    
    refreshData()
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - Load Data
  
  @objc func refreshData() {
    Category.fetchAll({ [weak self] categories in
      guard let strongSelf = self else {
        return
      }
      
      if let _ = categories {
        strongSelf.refreshControl.endRefreshing()
        strongSelf.categories = categories
        let indexPath = IndexPath(row: 0, section: Section.categories.rawValue)
        strongSelf.tableView.reloadRows(at: [ indexPath ], with: .fade)
      }
      
      Channel.fetchAll({ [weak self] channels in
        guard let strongSelf = self else {
          return
        }
        
        if let _ = channels {
          strongSelf.refreshControl.endRefreshing()
          strongSelf.channels = channels
          let indexPath = IndexPath(row: 0, section: Section.channels.rawValue)
          strongSelf.tableView.reloadRows(at: [ indexPath ], with: .fade)
        }
        
        Video.fetchTrendingVideos({ [weak self] videos in
          guard let strongSelf = self else {
            return
          }
          
          if let _ = videos {
            strongSelf.refreshControl.endRefreshing()
            strongSelf.trendingVideos = videos
            strongSelf.tableView.reloadSections(IndexSet(2...2), with: .fade)
          }
          }, failure: { [weak self] error in
            guard let strongSelf = self else {
              return
            }
            strongSelf.refreshControl.endRefreshing()
            SVProgressHUD.showError(withStatus: "Something went wrong.")
        })
        
        }, failure: { [weak self] error in
          guard let strongSelf = self else {
            return
          }
          strongSelf.refreshControl.endRefreshing()
          SVProgressHUD.showError(withStatus: "Something went wrong.")
      })
      
      }, failure: { [weak self] error in
        guard let strongSelf = self else {
          return
        }
        strongSelf.refreshControl.endRefreshing()
        SVProgressHUD.showError(withStatus: "Something went wrong.")
    })
  }
}

// MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == Section.categories.rawValue {
      return 1
    }
    
    if section == Section.channels.rawValue {
      return 1
    }
    
    if section == Section.videos.rawValue {
      if let count = self.trendingVideos?.count {
        return count
      }
    }
    
    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == Section.categories.rawValue {
      let cell: CategoriesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CategoriesCell", for: indexPath) as! CategoriesTableViewCell
      cell.setupWithCategories(self.categories)
      cell.collectionView.tag = indexPath.section + 100
      cell.selectionStyle = .none
      if cell.delegate == nil {
        cell.delegate = self
      }
      return cell
    } else if indexPath.section == Section.channels.rawValue {
      let cell: ChannelsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ChannelsCell", for: indexPath) as! ChannelsTableViewCell
      cell.setupWithChannel(self.channels)
      cell.collectionView.tag = indexPath.section + 100
      cell.selectionStyle = .none
      return cell
    } else {
      let cell: VideoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath) as! VideoTableViewCell
      if let video = self.trendingVideos?[indexPath.row] {
        let videoViewModel = VideoViewModel(video: video)
        cell.setupWithViewModel(videoViewModel)
        cell.selectionStyle = .none
      }
      return cell
    }
  }
}

// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == Section.videos.rawValue {
      let video = self.trendingVideos?[indexPath.row]
      let videoViewModel = VideoViewModel(video: video!)
      let videoViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
      videoViewController.videoViewModel = videoViewModel
      self.present(videoViewController, animated: true)
    }
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 36
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let categoriesHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CategoriesHeaderView") as! CategoriesHeaderView
    categoriesHeaderView.titleLabel.textColor = UIColor(named: "DarkText")
    categoriesHeaderView.setup()
    let view = UIView(frame: categoriesHeaderView.frame)
    view.backgroundColor = UIColor.white
    categoriesHeaderView.backgroundView = view
    switch section {
    case 0:
      categoriesHeaderView.titleLabel.text = "Categories".uppercased()
      break
    case 1:
      categoriesHeaderView.titleLabel.text = "Channels".uppercased()
      break
    case 2:
      categoriesHeaderView.titleLabel.text = "Trending".uppercased()
      categoriesHeaderView.shouldHideSeeAllButton = true
      break
    default: break
    }
    return categoriesHeaderView
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.section {
    case Section.categories.rawValue, Section.channels.rawValue:
      return 116
    case Section.videos.rawValue:
      return 88
    default:
      break
    }
    return 44
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return .leastNormalMagnitude
  }
}

// MARK: - CategoriesTableViewCellDelegate

extension HomeViewController: CategoriesTableViewCellDelegate {
  func didSelectCategory(category: Category) {
    let videosViewController = VideosViewController(category: category)
    self.navigationController?.pushViewController(videosViewController, animated: true)
  }
}


