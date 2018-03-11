//
//  Video.swift
//  ThreeSixtyVUZ
//
//  Created by Jerald Abille on 2/21/18.
//  Copyright © 2018 Jeraldo Abille. All rights reserved.
//

import Foundation
import Alamofire

struct Video: Codable {
  var videoId: String?
  var title: String?
  var image: String?
  var link: String?
  var videoDescription: String?
  var likes: Int?
  var views: Int?

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

struct LiveVideos: Codable {
  var videos: [Video]?

  enum CodingKeys: String, CodingKey {
    case videos = "live_video"
  }
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

  static func fetchLive360Videos(_ success: @escaping (_ liveVideos: [Video]?) -> Void, failure: @escaping failureHandler) {
    let url = NetworkClient.baseURL!.appendingPathComponent("scroll_list")
    let parameters: Parameters = [
      "user_id": Constants.userId,
      "page": "live_video",
      "tab": "live_video"
    ]
    Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
      guard response.error == nil else {
        DispatchQueue.main.async {
          failure(response.error!)
        }
        return
      }

      guard response.result.error == nil else {
        DispatchQueue.main.async {
          failure(response.result.error!)
        }
        return
      }

      let value = response.result.value
      let json = value as! [String:Any]
      let liveVideos = json["live_video"] as! [[String:Any]]
      var videos = [Video]()
      for item in liveVideos {
        var video = Video()
        video.title = (item["title"] as! String)
        video.videoId = (item["id"] as! String)
        video.image = (item["image"] as! String)
        video.link = (item["video_link"] as! String)
        // video.views = (item["viewcount"] as! Int)
        // video.likes = (item["likecount"] as! Int)
        video.videoDescription = (item["description"] as! String)
        videos.append(video)
      }
      DispatchQueue.main.async {
        success(videos)
      }
    }
  }
}
