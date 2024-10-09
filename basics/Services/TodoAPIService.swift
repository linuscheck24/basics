//
//  LoginAPIService.swift
//  basics
//
//  Created by Linus Widing on 09.10.24.
//

import Foundation

class TodoAPIService{
    
    static let shared = TodoAPIService()
    
    func fetchUserTodos() async throws -> [ToDo]{
        // Ensure the user is authorized
        guard let token = AuthAPIService.shared.authToken else {
            throw APIServiceError.unauthorized
        }
        
        let contentType = "application/json"
        
        let data = try await APIService.shared.makeRequest(
            Endpoint: APIPath.todo,
            HTTPMethod: "GET",
            contentType: contentType,
            authToken: token
        )
        

        let todos = try JSONDecoder().decode([ToDo].self, from: data)
        
        return todos
    }
}
