//
//  LoginRequest.swift
//  OnTheMap
//
//  Created by user on 13.04.2020.
//  Copyright © 2020 ulkoart. All rights reserved.
//

import Foundation

struct LoginRequest: Encodable {
    let udacity: LoginData
}

struct LoginData: Encodable {
    let username: String
    let password: String
}
