//
//  AuthNetworking.swift
//  Kenany-Group
//
//  Created by OSX on 20/07/2021.
//

import Foundation
import Alamofire

enum AuthNetworking: TargetType {
    
    case login(email: String, password: String)
    case register(email: String, name: String, phone: String, password: String, deviceToken: String)
    
    var baseURL: String {
        switch self {
        default: return Constants.BaseURL
        }
    }
    
    var path: String {
        switch self {
        case .login:
            return Constants.Authentication.login.rawValue
        case .register:
            return Constants.Authentication.register.rawValue
        }
    }
    
    var method: HTTPMethod {
        switch self {
        default: return .post
        }
    }
    
    var task: Task {
        switch self {
        case .login(email: let email, password: let password):
            return .requestParameters(parameters: ["email": email,
                                                   "password": password], encoding: JSONEncoding.default)
        case .register(email: let email, name: let name, phone: let phone, password: let password, deviceToken: let deviceToken):
            return .requestParameters(parameters: ["email": email,
                                                   "name": name,
                                                   "phone": phone,
                                                   "password": password,
                                                   "device_token": deviceToken], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default: return ["Accept": "application/json"]
        }
    }

}
