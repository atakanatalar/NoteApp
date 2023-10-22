//
//  NAError.swift
//  NoteApp
//
//  Created by Atakan Atalar on 22.10.2023.
//

import Foundation

enum NAError: String, Error {
    
    case unableToFavorite = "There was an error favoriting this note."
    case alreadyInFavorites = "You have already favorited this note."
}
