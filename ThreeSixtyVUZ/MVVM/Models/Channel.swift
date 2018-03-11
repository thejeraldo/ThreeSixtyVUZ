//
//  Channel.swift
//  ThreeSixtyVUZ
//
//  Created by Jerald Abille on 2/21/18.
//  Copyright © 2018 Jeraldo Abille. All rights reserved.
//

import Foundation

struct Channel: Codable {
  var channelId: String?
  var title: String?
  var image: String?
  var liveType: String?

  enum CodingKeys: String, CodingKey {
    case channelId = "id"
    case title
    case image
    case liveType = "live_type"
  }
}

struct ChannelList: Codable {
  var channels: [Channel]?

  enum CodingKeys: String, CodingKey {
    case channels = "channel_list"
  }
}

// MARK: - HTTP Requests

extension Channel {
  typealias failureHandler = (_ error: Error) -> Void

  static func fetchAll(_ success: @escaping (_ channels: [Channel]?) -> Void, failure: @escaping failureHandler) {
    let url = NetworkClient.baseURL!.appendingPathComponent("channel_list_homepage")
    NetworkClient.fetch(url: url, method: .post, parameters: [:], responseType: ChannelList.self, success: { (channelList: ChannelList?) in
      DispatchQueue.main.async { () -> Void in
        if let _ = channelList {
          success(channelList?.channels)
        }
      }
    }, failure: { error in
      DispatchQueue.main.async { () -> Void in
        failure(error!)
      }
    })
  }
}