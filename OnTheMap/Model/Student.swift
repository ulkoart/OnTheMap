//
//  Student.swift
//  OnTheMap
//
//  Created by user on 15.04.2020.
//  Copyright © 2020 ulkoart. All rights reserved.
//

import Foundation

struct Student: Codable {
    let key: String
    let lastName: String
    let firstName: String
    
    enum CodingKeys: String, CodingKey {
        case lastName = "last_name"
        case firstName = "first_name"
        case key
    }
}
