//
//  Video.swift
//  ThreeSixtyVUZ
//
//  Created by Jerald Abille on 2/21/18.
//  Copyright © 2018 Jeraldo Abille. All rights reserved.
//

import Foundation

struct Video: Codable {
  var videoId: String?
  var title: String?
  var image: String?
  var link: String?
  var videoDescription: String?
  var likes: Int = 0
  var views: Int = 0

  enum CodingKeys: String, CodingKey {
    case videoId = "id"
    case title = "video_title"
    case image = "video_thumbnail"
    case link = "video_link"
    case likes = "likecount"
    case views = "viewcount"
    case videoDescription = "description"
  }
}

struct TrendingVideos: Codable {
  var videos: [Video]?

  enum CodingKeys: String, CodingKey {
    case videos = "trending_360_video"
  }
}

struct VideosByCategoriesResult: Codable {
  var result: [String: [Video]]
}

// MARK: - HTTP Requests

extension Video {
  typealias failureHandler = (_ error: Error) -> Void

  static func fetchTrendingVideos(_ success: @escaping (_ trendingVideos: [Video]?) -> Void, failure: @escaping failureHandler) {
    let url = NetworkClient.baseURL!.appendingPathComponent("trending_360_video_list_homepage")
    NetworkClient.fetch(url: url, method: .post, parameters: [:], responseType: TrendingVideos.self, success: { (trendingVideos: TrendingVideos?) in
      DispatchQueue.main.async { () -> Void in
        if let _ = trendingVideos {
          success(trendingVideos?.videos)
        }
      }
    }, failure: { error in
      DispatchQueue.main.async { () -> Void in
        failure(error!)
      }
    })
  }
}
