//
//  Category.swift
//  ThreeSixtyVUZ
//
//  Created by Jerald Abille on 2/21/18.
//  Copyright © 2018 Jeraldo Abille. All rights reserved.
//

import Foundation
import Alamofire

struct Category: Codable {
  var categoryId: String?
  var name: String?
  var image: String?

  enum CodingKeys: String, CodingKey {
    case categoryId = "id"
    case name = "category_name"
    case image = "image"
  }
}

struct CategoryList: Codable {
  let categories: [Category]?

  enum CodingKeys: String, CodingKey {
    case categories = "category"
  }
}

// MARK: - API Requests

extension Category {
  typealias failureHandler = (_ error: Error) -> Void

  static func fetchAll(_ success: @escaping (_ categories: [Category]?) -> Void, failure: @escaping failureHandler) {
    let url = NetworkClient.baseURL!.appendingPathComponent("category_list_homepage")
    NetworkClient.fetch(url: url, method: .post, parameters: [:], responseType: CategoryList.self, success: { (categoryList: CategoryList?) in
      DispatchQueue.main.async { () -> Void in
        if let _ = categoryList {
          success(categoryList?.categories)
        }
      }
    }, failure: { error in
      DispatchQueue.main.async { () -> Void in
        failure(error!)
      }
    })
  }

  static func fetchVideosForCategory(_ category: Category, success: @escaping (_ videos: [Video]?) -> Void, failure: @escaping failureHandler) {
    let url = NetworkClient.demoURL!.appendingPathComponent("video_list.php")
    let params: Parameters = [ "id": Int(Constants.userId)!, "category_id": category.categoryId! ]
    Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
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
      let result = json["result"] as! [String:Any]
      let videoslist = result["videoslist"] as! [[String:Any]]
      var videos = [Video]()
      for item in videoslist {
        var video = Video()
        video.title = (item["video_title"] as! String)
        video.videoId = (item["video_id"] as! String)
        video.image = (item["video_thumbnail"] as! String)
        video.link = (item["video_link"] as! String)
        video.views = (item["viewcount"] as! Int)
        video.likes = (item["likecount"] as! Int)
        var videoDescription: String?
        if item["description"] != nil {
          videoDescription = item["description"] as? String
        } else if item["video_description"] != nil {
          videoDescription = item["video_description"] as? String
        }
        video.videoDescription = videoDescription
        videos.append(video)
      }
      DispatchQueue.main.async {
        success(videos)
      }
    }
  }
}
