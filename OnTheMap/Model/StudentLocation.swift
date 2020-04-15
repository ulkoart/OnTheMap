//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by user on 15.04.2020.
//  Copyright © 2020 ulkoart. All rights reserved.
//

import Foundation

struct StudentLocation: Codable {
    let firstName: String
    let lastName: String
    let longitude: Double
    let latitude: Double
    let mapString: String
    let mediaURL: String
    let uniqueKey: String
}
