//
//  TodoDetailViewModel.swift
//  basics
//
//  Created by Linus Widing on 07.10.24.
//

import Foundation

class TodoDetailViewModel{
    
    var todo: ToDo
    
    init(_ todo: ToDo) {
        self.todo = todo
    }
    
    func getTitle() -> String {
        return todo.title
    }
    
    func getDescription() -> String {
        guard let text = todo.text else{
            return "No description"
        }
        return text
    }
    
}
