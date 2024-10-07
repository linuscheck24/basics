//
//  APIService.swift
//  basics
//
//  Created by Linus Widing on 07.10.24.
//
import Foundation

class APIService {
    static let shared = APIService()
    private let baseURL = "http://localhost:8000"
    
    private var authToken: String? {
        get { KeychainService.shared.getAccessToken() }
        set { if let newValue = newValue { KeychainService.shared.saveAccessToken(newValue) } else { KeychainService.shared.delete(key: "accessToken") } }
    }
    
    func login(username: String, password: String) async throws -> TokenResponse{
        guard let url = URL(string: "\(baseURL)/token/") else{
            throw APIServiceError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let bodyParams = "username=\(username)&password=\(password)&grant_type=password"
        request.httpBody = bodyParams.data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
            throw APIServiceError.invalidResponse
        }
        
        let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
        self.authToken = tokenResponse.access_token
        
        return tokenResponse
    }
    
    func fetchUserTodos() async throws -> [ToDo]{
        guard let url = URL(string: "\(baseURL)/todos/") else{
            throw APIServiceError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            throw APIServiceError.unauthenticatedRequest
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
            throw APIServiceError.invalidResponse
        }
        
        let todoResponse = try JSONDecoder().decode([ToDo].self, from: data)
        
        
        return todoResponse
    }
}


enum APIServiceError: Error{
    case invalidURL
    case invalidResponse
    case unauthenticatedRequest
}
