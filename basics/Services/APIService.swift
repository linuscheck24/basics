//
//  APIService.swift
//  basics
//
//  Created by Linus Widing on 07.10.24.
//
import Foundation

// TODOd: - Refactor this class to make it reusable for any API call, not just specific ones like login or fetching todos.
// Suggestions:
// 1. Generalize the `makeRequest` method further by allowing dynamic HTTP methods, flexible headers, and body data.
// 2. Avoid hardcoding endpoints; consider passing baseURL or endpoints as parameters or configuring them externally.
// 3. Add support for query parameters if needed for GET requests.
// 4. Ensure proper error handling for all kinds of API responses and status codes.
// 5. Structure the class in a way that adding new API calls only requires defining the endpoint and the expected response type.
class APIService {
    static let shared = APIService()
    
    // TODOd: - Move the `baseURL` and all endpoint paths to a centralized class or enum.
    // This will allow for easier management of API routes, and it ensures that all endpoint URLs are handled in one place.
    // Consider creating a class or enum like `APIEndpoints` where you define all the paths,
    // making it easier to update or modify them as needed
    
    // Helper method to make a request
    func makeRequest(
        Endpoint: APIPath,
        HTTPMethod: String,
        contentType: String? = nil,
        queryParams: [String: String]? = nil,
        bodyParams: [String: String]? = nil,
        body: Codable? = nil,
        authToken: String? = nil
    ) async throws -> Data {
        
        // Construct URL with query parameters if provided
        guard var urlComponents = URLComponents(string: "\(APIPath.baseURL.rawValue)\(Endpoint.rawValue)") else{
            throw APIServiceError.invalidURL
        }
        
        if let queryParams = queryParams {
            urlComponents.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let url = urlComponents.url else {
            throw APIServiceError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod
        
        if let contentType = contentType {
            request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        }
        
        // Handle different body types (form-urlencoded or JSON)
        if let bodyParams = bodyParams {
            // Encode as application/x-www-form-urlencoded
            let bodyString = bodyParams
                .map { "\($0.key)=\($0.value)" }
                .joined(separator: "&")
            
            request.httpBody = bodyString.data(using: .utf8)
        }
        else if let body = body {
            // Encode as JSON
            let jsonData = try JSONEncoder().encode(body)
            request.httpBody = jsonData
        }
        
        // Set auth token if available
        if let authToken = authToken{
            request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        }
        
        // Execute the request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Check for valid response (status code 2xx)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw APIServiceError.invalidResponse
        }
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
            throw APIServiceError.unauthorized
        }
        
        return data
    }

}
