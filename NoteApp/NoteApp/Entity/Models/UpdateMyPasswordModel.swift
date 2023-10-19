//
//  UpdateMyPasswordModel.swift
//  NoteApp
//
//  Created by Atakan Atalar on 19.10.2023.
//

import Foundation

struct UpdateMyPasswordModel: Codable {
    let password: String
    let newPassword: String
    let confirmPassword: String
    
    enum CodingKeys: String, CodingKey {
        case password = "password"
        case newPassword = "new_password"
        case confirmPassword = "new_password_confirmation"
    }
}

struct UpdateMyPasswordResponse: Codable {
    let code: String
    let data: UpdateMyPasswordJSONNull?
    let message: String
}

class UpdateMyPasswordJSONNull: Codable, Hashable {

    public static func == (lhs: UpdateMyPasswordJSONNull, rhs: UpdateMyPasswordJSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(UpdateMyPasswordJSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
