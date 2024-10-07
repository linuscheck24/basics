//
//  ToDo.swift
//  basics
//
//  Created by Linus Widing on 06.10.24.
//

import Foundation

struct ToDo: Identifiable, Codable {
    let id: Int
    let title: String
    let text: String?
    var isDone: Bool
    let ownerId: Int
    let position: Int
    var category: Category?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case text
        case isDone = "is_done"
        case ownerId = "owner_id"
        case position
        case category
    }
}

struct Category: Identifiable, Codable, Hashable {
    var id: Int
    var name: String
    var userId: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case userId = "user_id"
    }
}

extension ToDo {
    static let mockData: [ToDo] = [
        ToDo(id: 1, title: "Buy groceries", text: "Milk, Bread, Eggs", isDone: false, ownerId: 1, position: 1),
        ToDo(id: 2, title: "Meeting with Bob", text: "Discuss project details", isDone: false, ownerId: 1, position: 2),
        ToDo(id: 3, title: "Read a book", text: "Finish reading '1984' by George Orwell", isDone: true, ownerId: 1, position: 3),
        ToDo(id: 4, title: "Workout", text: "30 minutes of cardio", isDone: false, ownerId: 1, position: 4),
        ToDo(id: 5, title: "Cook dinner", text: "Prepare pasta for dinner", isDone: false, ownerId: 1, position: 5)
    ]
}
