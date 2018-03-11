//
//  VideoViewModel.swift
//  ThreeSixtyVUZ
//
//  Created by Jerald Abille on 3/5/18.
//  Copyright © 2018 Jeraldo Abille. All rights reserved.
//

import Foundation

class VideoViewModel {
  public let video: Video
  
  public let titleText: String
  public let imageURL: URL?
  public let videoURL: URL?
  public let likesText: String
  public let descriptionText: String
  
  public init(video: Video) {
    self.video = video
    titleText = video.title!
    imageURL = URL(string: video.image!)
    videoURL = URL(string: video.link!)
    let viewsString = VideoViewModel.formatNumber(video.views)
    let likesString = VideoViewModel.formatNumber(video.likes)
    likesText = String(format: "%@ views · %@ likes", viewsString, likesString)
    descriptionText = video.videoDescription ?? ""
  }
  
  class func formatNumber(_ num: Int) -> String {
    let number = Double(num)
    let thousand = number / 1000
    let million = number / 1000000
    if million >= 1.0 {
      return "\(round(million*10)/10)M"
    } else if thousand >= 1.0 {
      return "\(round(thousand*10)/10)K"
    } else {
      return "\(Int(number))"
    }
  }
}
