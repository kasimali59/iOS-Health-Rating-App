//
//  Rating.swift
//  Assignment
//
//  Created by Kasim Ali on 20/02/2018.
//  Copyright © 2018 Kasim Ali. All rights reserved.
//

import Foundation

class Rating: Codable{
    var BusinessName: String
    var AddressLine1: String
    var AddressLine2: String?
    var AddressLine3: String?
    var PostCode: String
    var RatingValue: String
    var RatingDate: String
    var Latitude: String
    var Longitude: String
    var DistanceKM: String?
}
