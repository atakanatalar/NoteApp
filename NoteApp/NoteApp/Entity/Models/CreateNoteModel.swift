//
//  CreateNoteModel.swift
//  NoteApp
//
//  Created by Atakan Atalar on 16.10.2023.
//

import Foundation

struct CreateNoteModel: Codable {
    let title: String
    let note: String
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case note = "note"
    }
}

struct CreateNoteResponse: Codable {
    let code: String
    let data: CreateNoteDataClass
    let message: String
}

struct CreateNoteDataClass: Codable {
    let id: Int
    let title, note: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case note = "note"
    }
}

