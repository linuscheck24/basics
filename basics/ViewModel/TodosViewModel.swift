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
    private let apiService: APIService
    
    var todos: [ToDo] = []
    var selectedTodoIndex: Int?
    
    init(apiService: APIService = APIService.shared) {
        self.apiService = apiService
    }
    
    func fetchTodos() async{
        do {
            let todoResponse = try await apiService.fetchUserTodos()
            todos = todoResponse
            delegate?.didUpdateTodos()
        } catch {
            delegate?.didFailWithError(error)
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
