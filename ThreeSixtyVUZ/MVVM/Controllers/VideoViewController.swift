//
//  VideoViewController.swift
//  ThreeSixtyVUZ
//
//  Created by Jerald Abille on 2/22/18.
//  Copyright © 2018 Jeraldo Abille. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class VideoViewController: UIViewController {

  var videoViewModel: VideoViewModel?
  var avPlayer: AVPlayer?
  var avController: AVPlayerViewController?
  @IBOutlet weak var videoContainerView: UIView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var likesLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var closeButton: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    avPlayer = AVPlayer(url: (videoViewModel?.videoURL)!)
    avController = AVPlayerViewController()
    avController!.player = avPlayer
    avController!.view.frame = self.videoContainerView.bounds
    avController!.showsPlaybackControls = false
    self.addChildViewController(avController!)
    self.videoContainerView.addSubview(avController!.view)
    avController!.didMove(toParentViewController: self)
    avPlayer!.play()
    
    do {
      try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: [])
    } catch {
      print(error)
    }

    closeButton.addTarget(self, action: #selector(close(_:)), for: .touchUpInside)

    self.titleLabel.text = videoViewModel?.titleText
    self.likesLabel.text = videoViewModel?.likesText
    self.likesLabel.isHidden = (videoViewModel?.likesText.isEmpty == true)
    self.descriptionLabel.text = videoViewModel?.descriptionText
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.isHidden = true
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    setNeedsStatusBarAppearanceUpdate()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func close(_ sender: Any) {
    self.dismiss(animated: true)
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  override var prefersStatusBarHidden: Bool {
    return (Common.isIPhoneX() == false)
  }
  override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
    return .fade
  }
}
