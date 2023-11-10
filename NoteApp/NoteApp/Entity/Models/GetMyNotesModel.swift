//
//  GetMyNotesModel.swift
//  NoteApp
//
//  Created by Atakan Atalar on 13.10.2023.
//

import Foundation

struct GetMyNotesModel: Encodable {
    
}
    
struct GetMyNotesModelResponse: Codable {
    let code: String
    let data: GetMyNotesDataClass
    let message: String
}

struct GetMyNotesDataClass: Codable {
    let currentPage: Int
    let data: [Datum]?
    let firstPageURL: String
    let from, lastPage: Int?
    let lastPageURL: String
    let links: [Link]
    let nextPageURL: GetMyNotesJSONNull?
    let path: String
    let perPage: Int
    let prevPageURL: GetMyNotesJSONNull?
    let to, total: Int?
    
    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data
        case firstPageURL = "first_page_url"
        case from
        case lastPage = "last_page"
        case lastPageURL = "last_page_url"
        case links
        case nextPageURL = "next_page_url"
        case path
        case perPage = "per_page"
        case prevPageURL = "prev_page_url"
        case to, total
    }
}

struct Datum: Codable, Hashable {
    let id: Int?
    let title, note: String?
}

struct Link: Codable {
    let url: String?
    let label: String
    let active: Bool
}

class GetMyNotesJSONNull: Codable, Hashable {
    
    public static func == (lhs: GetMyNotesJSONNull, rhs: GetMyNotesJSONNull) -> Bool {
        return true
    }
    
    public var hashValue: Int {
        return 0
    }
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(GetMyNotesJSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

extension GetMyNotesModel {
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
