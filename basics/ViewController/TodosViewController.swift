//
//  TodosViewController.swift
//  basics
//
//  Created by Linus Widing on 02.10.24.
//

import UIKit


class TodosViewController: UIViewController {
    
    let tableView = UITableView()
    let contentArea = UIView()
    
    var viewModel: TodosViewModel!
    
    struct Cells{
        static let todoCell = "ToDoCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        title = "Todos"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        viewModel = TodosViewModel()
        viewModel.delegate = self
        
        contentArea.addToSafeArea(to: view, padding: 20)
        setupTableView()
        
        
        // Load todos
        Task{
            await viewModel.fetchTodos()
        }
    }
    
    func setupTableView(){
        contentArea.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = .zero
        tableView.layoutMargins = .zero
        
        tableView.rowHeight = 100
        tableView.register(TodoTableViewCell.self, forCellReuseIdentifier: Cells.todoCell)
        
        tableView.pin(to: contentArea)
        
    }
    
}

extension TodosViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getTodoCount()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTodo = viewModel.getTodoForIndex(indexPath.row)
        viewModel.selectedTodoIndex = indexPath.row
        let detailViewModel = TodoDetailViewModel(selectedTodo)
        let detailViewController = TodoDetailViewController()
        detailViewController.viewModel = detailViewModel
        detailViewController.delegate = self
        
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.todoCell) as! TodoTableViewCell
        let todo = viewModel.getTodoForIndex(indexPath.row)
        cell.set(todo: todo)
        cell.selectionStyle = .none
        
        
        return cell
    }
}

extension TodosViewController: TodoDelegate{
    func didUpdateTodos() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func didFailWithError(_ error: any Error) {
        print("Error: \(error)")
    }
}

extension TodosViewController: TodoDetailViewControllerDelegate{
    func didDeleteTodo() {
        viewModel.deleteSelectedTodo()
    }
}
