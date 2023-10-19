//
//  UserUpdateMeModel.swift
//  NoteApp
//
//  Created by Atakan Atalar on 19.10.2023.
//

import Foundation

struct UserUpdateMeModel: Codable {
    let name: String
    let email: String
    
    enum CodingKeys: String, CodingKey {
        case name = "full_name"
        case email = "email"
    }
}
    
struct UserUpdateMeResponse: Codable {
    let code: String
    let data: UserUpdateMeDataClass?
    let message: String
}

struct UserUpdateMeDataClass: Codable {
    let id: Int
    let name, email: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "full_name"
        case email
    }
}
