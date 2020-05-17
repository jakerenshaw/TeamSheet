//
//  StarRatingImages.swift
//  TeamSheet
//
//  Created by Jake Renshaw on 17/05/2020.
//  Copyright © 2020 Jake Renshaw. All rights reserved.
//

import Foundation
import UIKit

class StarRatingImages: NSObject {
    
    static func imageOfStars(starRating: NSDecimalNumber?) -> UIImage? {
      guard let rating = starRating?.doubleValue else {
        return nil
      }
      if rating >= 5 {
        return UIImage(named: "stars_5")
      } else if rating >= 4.5 {
        return UIImage(named: "stars_4_5")
      } else if rating >= 4 {
        return UIImage(named: "stars_4")
      } else if rating >= 3.5 {
        return UIImage(named: "stars_3_5")
      } else {
        return nil
      }
    }
    
}
