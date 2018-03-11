//
//  CategoryViewModel.swift
//  ThreeSixtyVUZ
//
//  Created by Jerald Abille on 3/5/18.
//  Copyright © 2018 Jeraldo Abille. All rights reserved.
//

import Foundation

class CategoryViewModel {
  public let category: Category
  
  public let nameText: String
  public let imageURL: URL?
  
  public init(category: Category) {
    self.category = category
    nameText = category.name!
    imageURL = URL(string: category.image!)
  }
}
