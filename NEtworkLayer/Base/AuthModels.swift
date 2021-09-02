//
//  AuthModels.swift
//  Kenany-Group
//
//  Created by OSX on 20/07/2021.
//

import Foundation

// MARK: - register & Login
struct AuthModel: Codable {
    let message, error: String
    let data: AuthModelData
}

// MARK: - DataClass
struct AuthModelData: Codable {
    let name, email, phone, apiToken: String

    enum CodingKeys: String, CodingKey {
        case name, email, phone
        case apiToken = "api_token"
    }
}
