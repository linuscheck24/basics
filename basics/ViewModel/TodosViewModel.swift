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
    private let todoAPIService: TodoAPIService
    
    var todos: [ToDo] = []
    var selectedTodoIndex: Int?
    var todosAreLoaded: Bool = false
    
    init(todoAPIService: TodoAPIService = TodoAPIService.shared) {
        self.todoAPIService = todoAPIService
    }
    
    func fetchTodos() async{
        if !todosAreLoaded{
            do {
                let todoResponse = try await todoAPIService.fetchUserTodos()
                todos = todoResponse
                delegate?.didUpdateTodos()
                todosAreLoaded = true
            } catch {
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
