//
//  GetNoteModel.swift
//  NoteApp
//
//  Created by Atakan Atalar on 13.10.2023.
//

import Foundation

struct GetNoteModel: Encodable {
    
}
    
struct GetNoteResponse: Codable {
    let code: String
    let data: GetNoteDataClass
    let message: String
}

struct GetNoteDataClass: Codable {
    let title, note: String
    let id: Int

    enum CodingKeys: String, CodingKey {
        case title = "title"
        case note = "note"
        case id = "id"
    }
}

extension GetNoteModel {
    func asDictionary() -> [String: Any] {
        let mirror = Mirror(reflecting: self)
        var dict: [String: Any] = [:]
        for child in mirror.children {
            if let label = child.label {
                dict[label] = child.value
            }
        }
        return dict
    }
}
