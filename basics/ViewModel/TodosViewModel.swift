//
//  TodosViewModel.swift
//  basics
//
//  Created by Linus Widing on 07.10.24.
//

import Foundation

protocol TodoDelegate: AnyObject {
    func didUpdateTodos()
    func didFailWithError(_ error: Error)
}

class TodosViewModel {
    
    weak var delegate: TodoDelegate?
    
    var todos: [ToDo] = []
    var selectedTodoIndex: Int?
    
    init() {
        fetchTodos()
    }
    
    func fetchTodos() {
        Task{
            do {
                let todoResponse = try await APIService.shared.fetchUserTodos()
                todos = todoResponse
                delegate?.didUpdateTodos()
            } catch {
                print("Fetching todos failed: \(error.localizedDescription)")
                delegate?.didFailWithError(error)
            }
        }
    }
    
    func addTodo(todo: ToDo) {
        todos.append(todo)
        delegate?.didUpdateTodos()
    }
    
    func deleteSelectedTodo(){
        guard let index = selectedTodoIndex else{
            return
        }
        todos.remove(at: index)
        delegate?.didUpdateTodos()
    }
    
    func getTodoCount() -> Int{
        return todos.count
    }
    
    func getTodoForIndex(_ index: Int) -> ToDo{
        return todos[index]
    }
}
