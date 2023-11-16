//
//  PersistenceManager.swift
//  NoteApp
//
//  Created by Atakan Atalar on 22.10.2023.
//

import Foundation

enum PersistenceActionType {
    case add, remove, update
}

enum PersistenceManager {
    static private let defaults = UserDefaults.standard
    
    static func getUserID() -> String {
        let userID = "\(String(describing: APIManager.sharedInstance.getMeResponse?.data.id))"
        return userID
    }
    
    static func updateWith(favoriteNote: GetNoteDataClass, actionType: PersistenceActionType, completed: @escaping (NAError?) -> Void) {
        retrieveFavorites { result in
            switch result {
            case .success(var favoriteNotes):
                switch actionType {
                case .add:
                    guard !favoriteNotes.contains(favoriteNote) else {
                        completed(.alreadyInFavorites)
                        return
                    }
                    favoriteNotes.append(favoriteNote)
                case .remove:
                    favoriteNotes.removeAll { $0.id == favoriteNote.id }
                case .update:
                    favoriteNotes.removeAll { $0.id == favoriteNote.id }
                    favoriteNotes.append(favoriteNote)
                }
                completed(save(favoriteNotes: favoriteNotes))
            case .failure(let error):
                completed(error)
            }
        }
    }
    
    static func retrieveFavorites(completed: @escaping (Result<[GetNoteDataClass], NAError>) -> Void) {
        guard let favoriteNotesData = defaults.object(forKey: getUserID()) as? Data else {
            completed(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let favoriteNotes = try decoder.decode([GetNoteDataClass].self, from: favoriteNotesData)
            completed(.success(favoriteNotes))
        } catch {
            completed(.failure(.unableToFavorite))
        }
    }
    
    static func save(favoriteNotes: [GetNoteDataClass]) -> NAError? {
        do {
            let encoder = JSONEncoder()
            let encodedFavoriteNotes = try encoder.encode(favoriteNotes)
            defaults.set(encodedFavoriteNotes, forKey: getUserID())
            return nil
        } catch {
            return .unableToFavorite
        }
    }
}
