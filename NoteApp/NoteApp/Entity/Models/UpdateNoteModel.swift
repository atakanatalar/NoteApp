//
//  UpdateNoteModel.swift
//  NoteApp
//
//  Created by Atakan Atalar on 16.10.2023.
//

import Foundation

struct UpdateNoteModel: Codable {
    let title: String
    let note: String
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case note = "note"
    }
}

struct UpdateNoteResponse: Codable {
    let code: String
    let data: UpdateNoteDataClass
    let message: String
}

struct UpdateNoteDataClass: Codable {
    let id: Int
    let title, note: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case note = "note"
    }
}
