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
}
