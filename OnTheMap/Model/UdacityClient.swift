//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by user on 13.04.2020.
//  Copyright © 2020 ulkoart. All rights reserved.
//

import Foundation
import UIKit


class UdacityClient {
    
    enum Endpoints {
        static let apiVersion = 1
        static let baseUrl = "https://onthemap-api.udacity.com/v\(apiVersion)/"
        
        case login
        case studentLocations
        case logout
        case addLocation
        case userInfo(String)
        
        var url: URL {
            return URL(string: self.stringValue)!
        }
        
        var stringValue: String {
            switch self {
            case .login:
                return UdacityClient.Endpoints.baseUrl + "session"
            case .studentLocations:
                return UdacityClient.Endpoints.baseUrl + "StudentLocation?order=-updatedAt&limit=100"
            case .logout:
                return UdacityClient.Endpoints.baseUrl + "session"
            case .addLocation:
                return UdacityClient.Endpoints.baseUrl + "StudentLocation"
            case .userInfo(let userId):
                return UdacityClient.Endpoints.baseUrl + "users/" + userId
            }
        }
    }
    
    class func addLocation(studentLocation: StudentLocation, completionHandler: @escaping (Bool, Error?) -> Void) {
        
        taskPOSTRequest(url: Endpoints.addLocation.url, skipСharacters: true, responseType: StudentLocationResponse.self, body: studentLocation) { response, error in
            
            guard let _ = response else {
                completionHandler(false, error)
                return
            }
            completionHandler(true, nil)
            
        }
        
    }
    
    class func getUserInfo(key: String, completionHandler: @escaping (Student?, Error?) -> Void) {
        taskGETRequest(url: Endpoints.userInfo(key).url, skipСharacters: false, responseType: Student.self) { data, error in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            completionHandler(data, nil)
        }
        
        
    }
    
    class func login(username: String, password: String, completionHandler: @escaping (Bool, Error?) -> Void) {
        let body = LoginRequest(udacity: LoginData(username: username, password: password))
        taskPOSTRequest(url: Endpoints.login.url, skipСharacters: false, responseType: LoginResponse.self, body: body) { response, error in
            if let response = response {
                let key = response.account.key
                
                UdacityClient.getUserInfo(key: key) { (student, error) in
                    guard let student = student else {
                        completionHandler(false, error)
                        return
                    }
                    
                    let object = UIApplication.shared.delegate
                    let appDelegate = object as! AppDelegate
                    appDelegate.student = student
                    
                    completionHandler(true, error)
                }
                
            } else {
                completionHandler(false, error)
            }
        }
    }
    
    class func logout(completionHandler: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.logout.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completionHandler(false, error)
                return
            }
            
            if let _ = data {
                completionHandler(true, error)
            }
        }
        task.resume()
        
    }
    
    class func studentLocations(completionHandler: @escaping ([Location], Error?) -> Void) {
        taskGETRequest(url: Endpoints.studentLocations.url, skipСharacters: true, responseType: LocationsResult.self) { data, error in
            guard let data = data else {
                completionHandler([], error)
                return
            }
            completionHandler(data.results, error)
        }
        
    }
}


extension UdacityClient {
    
    class func taskGETRequest<ResponseType: Decodable>(url: URL, skipСharacters: Bool, responseType: ResponseType.Type, completionHandler: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            
            var newData = data
            
            if (!skipСharacters) {
                let range = 5..<data.count
                newData = data.subdata(in: range)
            }
            
            let responseObject = try! decoder.decode(ResponseType.self, from: newData)
            
            DispatchQueue.main.async {
                completionHandler(responseObject, nil)
            }
            
        }
        task.resume()
        return task
    }
    
    class func taskPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, skipСharacters: Bool, responseType: ResponseType.Type, body: RequestType, completionHandler: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()

            var newData = data
            
            if (!skipСharacters) {
                let range = 5..<data.count
                newData = data.subdata(in: range)
            }
            
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completionHandler(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(LoginError.self, from: newData) as Error
                    DispatchQueue.main.async {
                        completionHandler(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completionHandler(nil, error)
                    }
                }
            }
            
            
        }
        task.resume()
    }
    
}
