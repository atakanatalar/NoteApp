//
//  ForgotPasswordModel.swift
//  NoteApp
//
//  Created by Atakan Atalar on 12.10.2023.
//

import Foundation

struct ForgotPasswordModel: Codable {
    let email: String
    
    enum CodingKeys: String, CodingKey {
        case email = "email"
    }
}
    
struct ForgotPasswordResponse: Codable {
    let code: String
    let data: JSONNull?
    let message: String
}

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
