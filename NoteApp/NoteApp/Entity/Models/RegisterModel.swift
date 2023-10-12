//
//  RegisterModel.swift
//  NoteApp
//
//  Created by Atakan Atalar on 12.10.2023.
//

import Foundation

struct RegisterModel: Codable {
    let name: String
    let email: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case name = "full_name"
        case email = "email"
        case password = "password"
    }
}

struct RegisterResponse: Codable {
    let code: String
    let data: RegisterDataClass?
    let message: String
}

struct RegisterDataClass: Codable {
    let accessToken, tokenType: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
    }
}
