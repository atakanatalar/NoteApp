//
//  GetMeModel.swift
//  NoteApp
//
//  Created by Atakan Atalar on 19.10.2023.
//

import Foundation

struct GetMeModel: Encodable { }

struct GetMeResponse: Codable {
    let code: String
    let data: GetMeDataClass
    let message: String
}

struct GetMeDataClass: Codable {
    let id: Int
    let name, email: String

    enum CodingKeys: String, CodingKey {
        case id
        case name = "full_name"
        case email
    }
}

extension GetMeModel {
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
