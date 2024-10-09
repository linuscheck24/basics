//
//  APIServiceError.swift
//  basics
//
//  Created by Linus Widing on 09.10.24.
//

import Foundation

enum APIServiceError: Error{
    case invalidURL
    case invalidResponse
    case unauthorized
}
