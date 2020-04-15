//
//  LoginResponse.swift
//  OnTheMap
//
//  Created by user on 13.04.2020.
//  Copyright © 2020 ulkoart. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    let account: Account
    let session: Session
}

struct Account: Codable {
    let registered: Bool
    let key: String
}

struct Session: Codable {
    let id: String
    let expiration: String
}

struct LoginError: Codable {
    let status: Int
    let error: String
}

extension LoginError: LocalizedError {
    var errorDescription: String? {
        return error
    }
}
