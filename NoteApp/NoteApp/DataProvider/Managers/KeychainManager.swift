//
//  KeychainManager.swift
//  NoteApp
//
//  Created by Atakan Atalar on 12.10.2023.
//

import KeychainAccess

class KeychainManager {
    
    func saveAccessTokenToKeychain(_ accessToken: String?) {
        let keychain = Keychain(service: "dev.atakanatalar.BasicNoteApp")
        
        guard let accessToken = accessToken else { return }
        
        do {
            try keychain.set(accessToken, key: "access_token")
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func getAccessToken() -> String {
        var accessToken = String()
        
        let keychain = Keychain(service: "dev.atakanatalar.BasicNoteApp")
        
        do {
            if let token = try keychain.getString("access_token") {
                accessToken = token
            } else {
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        return accessToken
    }
}
