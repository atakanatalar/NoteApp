//
//  APIManager.swift
//  NoteApp
//
//  Created by Atakan Atalar on 12.10.2023.
//

import Alamofire

class APIManager {
    
    static let sharedInstance = APIManager()
    
    let baseUrl = "https://basicnoteapp.mobillium.com/api/"
    
    var loginResponse: LoginResponse?
    var registerResponse: RegisterResponse?
    var forgotPasswordResponse: ForgotPasswordResponse?
    var getMyNotesModelResponse: GetMyNotesModelResponse?
    var getNoteResponse: GetNoteResponse?
    var deleteNoteResponse: DeleteNoteResponse?
    
    func callingLoginAPI(loginModel: LoginModel, completionHandler: @escaping (Bool) -> ()) {
        let headers: HTTPHeaders = [.contentType("application/json")]
        
        AF.request("\(baseUrl)auth/login", method: .post, parameters: loginModel, encoder: JSONParameterEncoder.default, headers: headers).response { response in
            switch response.result {
            case.success(let data):
                guard let data = data else { return }
                
                let response = LoginResponse.self
                
                if let loginResponse = try? JSONDecoder().decode(response, from: data) {
                    KeychainManager().saveAccessTokenToKeychain(loginResponse.data?.accessToken)
                    self.loginResponse = loginResponse
                    completionHandler(true)
                } else {
                    completionHandler(false)
                }
            case.failure(let error):
                print(error.localizedDescription)
                completionHandler(false)
            }
        }
    }
    
    func callingRegisterAPI(registerModel: RegisterModel, completionHandler: @escaping (Bool) -> ()) {
        let headers: HTTPHeaders = [.contentType("application/json")]
        
        AF.request("\(baseUrl)auth/register", method: .post, parameters: registerModel, encoder: JSONParameterEncoder.default, headers: headers).response { response in
            switch response.result {
            case.success(let data):
                guard let data = data else { return }
                
                let response = RegisterResponse.self
                
                if let registerResponse = try? JSONDecoder().decode(response, from: data) {
                    KeychainManager().saveAccessTokenToKeychain(registerResponse.data?.accessToken)
                    self.registerResponse = registerResponse
                    completionHandler(true)
                } else {
                    completionHandler(false)
                }
            case.failure(let error):
                print(error.localizedDescription)
                completionHandler(false)
            }
        }
    }
    
    func callingForgotPasswordAPI(forgotPasswordModel: ForgotPasswordModel, completionHandler: @escaping (Bool) -> ()) {
        let headers: HTTPHeaders = [.contentType("application/json")]
        
        AF.request("\(baseUrl)auth/forgot-password", method: .post, parameters: forgotPasswordModel, encoder: JSONParameterEncoder.default, headers: headers).response { response in
            switch response.result {
            case.success(let data):
                guard let data = data else { return }
                
                let response = ForgotPasswordResponse.self
                
                if let forgotPasswordResponse = try? JSONDecoder().decode(response, from: data) {
                    self.forgotPasswordResponse = forgotPasswordResponse
                    completionHandler(true)
                } else {
                    completionHandler(false)
                }
            case.failure(let error):
                print(error.localizedDescription)
                completionHandler(false)
            }
        }
    }
    
    func callingGetMyNotesAPI(getMyNotesModel: GetMyNotesModel, completionHandler: @escaping (Bool) -> ()) {
        let headers: HTTPHeaders = [.contentType("application/json"), .authorization(bearerToken: KeychainManager().getAccessToken())]
        
        AF.request("\(baseUrl)users/me/notes?page=1", method: .get, parameters: getMyNotesModel.asDictionary(), encoding: URLEncoding(destination: .queryString), headers: headers).response { response in
            switch response.result {
            case .success(let data):
                guard let data = data else { return }
                
                let response = GetMyNotesModelResponse.self
                
                if let getMyNotesModelResponse = try? JSONDecoder().decode(response, from: data) {
                    self.getMyNotesModelResponse = getMyNotesModelResponse
                    completionHandler(true)
                } else {
                    completionHandler(false)
                }
            case .failure(let error):
                print("Request failed with error: \(error.localizedDescription)")
                completionHandler(false)
            }
        }
    }
    
    func callingGetNoteAPI(noteId: Int, getNoteModel: GetNoteModel, completionHandler: @escaping (Bool) -> ()) {
        let headers: HTTPHeaders = [.contentType("application/json"), .authorization(bearerToken: KeychainManager().getAccessToken())]
        
        AF.request("\(baseUrl)notes/\(noteId)", method: .get, parameters: getNoteModel.asDictionary(), encoding: URLEncoding(destination: .queryString), headers: headers).response { response in
            switch response.result {
            case .success(let data):
                guard let data = data else { return }
                
                let response = GetNoteResponse.self
                
                if let getNoteResponse = try? JSONDecoder().decode(response, from: data) {
                    self.getNoteResponse = getNoteResponse
                    completionHandler(true)
                } else {
                    completionHandler(false)
                }
            case .failure(let error):
                print("Request failed with error: \(error.localizedDescription)")
                completionHandler(false)
            }
        }
    }
    
    func callingDeleteNoteAPI(noteId: Int, deleteNoteModel: DeleteNoteModel, completionHandler: @escaping (Bool) -> ()) {
            let headers: HTTPHeaders = [.contentType("application/json"), .authorization(bearerToken: KeychainManager().getAccessToken())]
        
        AF.request("\(baseUrl)notes/\(noteId)", method: .delete, parameters: deleteNoteModel, encoder: JSONParameterEncoder.default, headers: headers).response { response in
            switch response.result {
            case.success(let data):
                guard let data = data else { return }
                
                let response = DeleteNoteResponse.self
                
                if let deleteNoteResponse = try? JSONDecoder().decode(response, from: data) {
                    self.deleteNoteResponse = deleteNoteResponse
                    completionHandler(true)
                } else {
                    completionHandler(false)
                }
            case.failure(let error):
                print(error.localizedDescription)
                completionHandler(false)
            }
        }
    }
}
