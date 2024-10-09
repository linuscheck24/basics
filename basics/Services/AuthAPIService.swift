//
//  LoginAPIService.swift
//  basics
//
//  Created by Linus Widing on 09.10.24.
//

import Foundation

class AuthAPIService{
    
    static let shared = AuthAPIService()
    
    var authToken: String? {
        get { KeychainService.shared.getAccessToken() }
        set { if let newValue = newValue { KeychainService.shared.saveAccessToken(newValue) } else { KeychainService.shared.delete(key: "accessToken") } }
    }
    
    func login(username: String, password: String) async throws -> TokenResponse{
        
        let bodyParams = ["username": username, "password": password, "grant_type": "password"]
        
        let responseData = try await APIService.shared.makeRequest(Endpoint: APIPath.login, HTTPMethod: "POST", bodyParams: bodyParams)
        
        let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: responseData)
        self.authToken = tokenResponse.access_token
        
        return tokenResponse
    }
}
