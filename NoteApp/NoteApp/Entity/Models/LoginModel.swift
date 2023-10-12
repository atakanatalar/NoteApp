//
//  LoginModel.swift
//  NoteApp
//
//  Created by Atakan Atalar on 12.10.2023.
//

import Foundation

struct LoginModel: Codable {
    let email: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case email = "email"
        case password = "password"
    }
}

struct LoginResponse: Codable {
    let code: String
    let data: DataClass?
    let message: String
}

struct DataClass: Codable {
    let accessToken, tokenType: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
    }
}
