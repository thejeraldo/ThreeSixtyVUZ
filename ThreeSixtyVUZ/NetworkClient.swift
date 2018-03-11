//
//  NetworkClient.swift
//  ThreeSixtyVUZ
//
//  Created by Jerald Abille on 2/25/18.
//  Copyright © 2018 Jeraldo Abille. All rights reserved.
//

import UIKit
import Alamofire

class NetworkClient: NSObject {
  static let baseURL = URL(string: "http://360vuz.com/360admin/api")
  static let demoURL = URL(string: "http://www.360vuz.com/demonew/api/")

  typealias failureHandler = (_ error: Error?) -> Void

  class func fetch<T: Codable>(url: URL, method: HTTPMethod, parameters: [String: Any], responseType: T.Type?, success: @escaping (_ t: T?) -> Void, failure: @escaping failureHandler) {
    Alamofire.request(url.absoluteString, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
      guard response.error == nil else {
        print(response.error ?? "")
        failure(response.error)
        return
      }

      guard response.result.isFailure == false else {
        print(response.result.error ?? "")
        failure(response.result.error)
        return
      }

      do {
        if let data = response.data, let responseType = responseType {
          let decoder = JSONDecoder()
          let result = try decoder.decode(responseType, from: data)
          DispatchQueue.main.async { () -> Void in
            success(result)
          }
        }
      } catch let dataError {
        failure(dataError)
      }
    }.resume()
  }

  class func fetch<T: Codable>(url: URL, responseType: T.Type?, success: @escaping (_ t: T?) -> Void, failure: @escaping failureHandler) {
    guard url == url else {
      return
    }

    Alamofire.request(url.absoluteString).responseJSON { response in
      guard response.error == nil else {
        failure(response.error)
        return
      }

      guard response.result.isFailure == false else {
        failure(response.result.error)
        return
      }

      do {
        if let data = response.data, let responseType = responseType {
          let decoder = JSONDecoder()
          let result = try decoder.decode(responseType, from: data)
          DispatchQueue.main.async { () -> Void in
            success(result)
          }
        }
      } catch let dataError {
        failure(dataError)
      }
    }.resume()
  }
}
