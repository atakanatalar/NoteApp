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
    var updateNoteResponse: UpdateNoteResponse?
    var createNoteResponse: CreateNoteResponse?
    var getMeResponse: GetMeResponse?
    var userUpdateMeResponse: UserUpdateMeResponse?
    var updateMyPasswordResponse: UpdateMyPasswordResponse?
    
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
    
    func callingUpdateNoteAPI(noteId: Int, updateNoteModel: UpdateNoteModel, completionHandler: @escaping (Bool) -> ()) {
        let headers: HTTPHeaders = [.contentType("application/json"), .authorization(bearerToken: KeychainManager().getAccessToken())]
        
        AF.request("\(baseUrl)notes/\(noteId)", method: .put, parameters: updateNoteModel, encoder: JSONParameterEncoder.default,  headers: headers).response { response in
            switch response.result {
            case.success(let data):
                guard let data = data else { return }
                
                let response = UpdateNoteResponse.self
                
                if let updateNoteResponse = try? JSONDecoder().decode(response, from: data) {
                    self.updateNoteResponse = updateNoteResponse
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
    
    func callingCreateNoteAPI(createNoteModel: CreateNoteModel, completionHandler: @escaping (Bool) -> ()) {
        let headers: HTTPHeaders = [.contentType("application/json"), .authorization(bearerToken: KeychainManager().getAccessToken())]
        
        AF.request("\(baseUrl)notes",  method: .post, parameters: createNoteModel, encoder: JSONParameterEncoder.default, headers: headers).response { response in
            switch response.result {
            case.success(let data):
                guard let data = data else { return }
                
                let response = CreateNoteResponse.self
                
                if let createNoteResponse = try? JSONDecoder().decode(response, from: data) {
                    self.createNoteResponse = createNoteResponse
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
    
    func callingGetMeAPI(getMeModel: GetMeModel, completionHandler: @escaping (Bool) -> ()) {
        let headers: HTTPHeaders = [.contentType("application/json"), .authorization(bearerToken: KeychainManager().getAccessToken())]
       
        AF.request("\(baseUrl)users/me", method: .get,  parameters: getMeModel.asDictionary(), encoding: URLEncoding(destination: .queryString), headers: headers).response { response in
            switch response.result {
            case .success(let data):
                guard let data = data else { return }
                
                let response = GetMeResponse.self
                
                if let getMeResponse = try? JSONDecoder().decode(response, from: data) {
                    self.getMeResponse = getMeResponse
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
    
    func callingUserUpdateMeAPI(userUpdateMeModel: UserUpdateMeModel,  completionHandler: @escaping (Bool) -> ()) {
        let headers: HTTPHeaders = [.contentType("application/json"), .authorization(bearerToken: KeychainManager().getAccessToken())]
        
        AF.request("\(baseUrl)users/me", method: .put, parameters: userUpdateMeModel, encoder: JSONParameterEncoder.default, headers: headers).response { response in
            switch response.result {
            case.success(let data):
                guard let data = data else { return }
                
                let response = UserUpdateMeResponse.self
                
                if let userUpdateMeResponse = try? JSONDecoder().decode(response, from: data) {
                    self.userUpdateMeResponse = userUpdateMeResponse
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
    
    func callingUpdateMyPasswordAPI(updateMyPasswordModel: UpdateMyPasswordModel, completionHandler: @escaping (Bool) -> ()) {
        let headers: HTTPHeaders = [.contentType("application/json"), .authorization(bearerToken: KeychainManager().getAccessToken())]
        
        AF.request("\(baseUrl)users/me/password", method: .put, parameters: updateMyPasswordModel, encoder: JSONParameterEncoder.default, headers: headers).response { response in
            switch response.result {
            case.success(let data):
                guard let data = data else { return }
                
                let response = UpdateMyPasswordResponse.self
                
                if let updateMyPasswordResponse = try? JSONDecoder().decode(response, from: data) {
                    self.updateMyPasswordResponse = updateMyPasswordResponse
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
