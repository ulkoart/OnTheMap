//
//  LocationsResponse.swift
//  OnTheMap
//
//  Created by user on 13.04.2020.
//  Copyright © 2020 ulkoart. All rights reserved.
//

import Foundation

struct Location: Codable {
    let firstName: String
    let lastName: String
    let longitude: Double
    let latitude: Double
    let mapString: String
    let mediaURL: String
    let uniqueKey: String
}

struct LocationsResult: Codable {
    let results: [Location]
}
