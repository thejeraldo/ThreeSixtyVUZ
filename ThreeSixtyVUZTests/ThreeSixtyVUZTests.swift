//
//  ThreeSixtyVUZTests.swift
//  ThreeSixtyVUZTests
//
//  Created by Jerald Abille on 2/20/18.
//  Copyright © 2018 Jeraldo Abille. All rights reserved.
//

import XCTest
@testable import ThreeSixtyVUZ

class ThreeSixtyVUZTests: XCTestCase {

  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testExample() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
  }

  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }

  func testChannelList() {
    let expectation = XCTestExpectation(description: "Download channel list.")

    Channel.fetchAll({ channels in
      print(channels ?? "")
      if let count = channels?.count {
       XCTAssert(count > 0, "Unable to get channels.")
      }
      expectation.fulfill()
    }, failure: { error in
      print(error)
      expectation.fulfill()
    })

    wait(for: [expectation], timeout: 60)
  }

  func testTrendingVideos() {
    let expectation = XCTestExpectation(description: "Download channel list.")

    Video.fetchTrendingVideos({ videos in
      print(videos ?? "")
      if let count = videos?.count {
        XCTAssert(count > 0, "Unable to get trending videos.")
      }
      expectation.fulfill()
    }, failure: { error in
      print(error)
      expectation.fulfill()
    })

    wait(for: [expectation], timeout: 60)
  }
}
