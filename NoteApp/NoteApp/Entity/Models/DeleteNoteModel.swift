//
//  DeleteNoteModel.swift
//  NoteApp
//
//  Created by Atakan Atalar on 13.10.2023.
//

import Foundation

struct DeleteNoteModel: Codable {
    
}

struct DeleteNoteResponse: Codable {
    let code: String
    let data: DeleteNoteJSONNull?
    let message: String
}

class DeleteNoteJSONNull: Codable, Hashable {

    public static func == (lhs: DeleteNoteJSONNull, rhs: DeleteNoteJSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(DeleteNoteJSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

