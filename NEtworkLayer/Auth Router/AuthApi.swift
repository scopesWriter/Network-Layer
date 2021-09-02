//
//  AuthApi.swift
//  Kenany-Group
//
//  Created by OSX on 20/07/2021.
//

import Foundation

protocol AuthProtocol {
    
    func login(email: String, password: String, completion: @escaping (Result<AuthModel?, NSError>) -> Void)
    func register(email: String, name: String, phone: String, password: String, deviceToken: String, completion: @escaping (Result<AuthModel?, NSError>) -> Void)
    
}

class AuthApi: BaseAPI<AuthNetworking>, AuthProtocol {
    
    func login(email: String, password: String, completion: @escaping (Result<AuthModel?, NSError>) -> Void) {
        fetchData(target: .login(email: email, password: password), responseClass: AuthModel.self) { result in
            completion(result)
        }
    }
    
    func register(email: String, name: String, phone: String, password: String, deviceToken: String, completion: @escaping (Result<AuthModel?, NSError>) -> Void) {
        fetchData(target: .register(email: email, name: name, phone: phone, password: password, deviceToken: deviceToken), responseClass: AuthModel.self) { result in
            completion(result)
        }
    }
    
}
