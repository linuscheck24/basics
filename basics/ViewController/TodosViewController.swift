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
    
    var viewModel: TodosViewModel
    
    struct Cells{
        static let todoCell = "ToDoCell"
    }
    
    init(viewModel: TodosViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        title = "Todos"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
        setupContentArea()
        setupTableView()
        
        
        viewModel.delegate = self
        
        if !viewModel.todosAreLoaded{
            // Load todos
            Task{
                await viewModel.fetchTodos()
            }
        }
    }
    
    func setupContentArea(){
        contentArea.addToSafeArea(to: view, padding: BasicsSizes.paddingMedium)
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

// MARK: - UITableViewDelegate
extension TodosViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTodo = viewModel.getTodoForIndex(indexPath.row)
        viewModel.selectedTodoIndex = indexPath.row
        let detailViewModel = TodoDetailViewModel(selectedTodo)
        let detailViewController = TodoDetailViewController(viewModel: detailViewModel)
        detailViewController.delegate = self
        
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension TodosViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getTodoCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.todoCell) as? TodoTableViewCell else{
            // Return a default cell in case of failure
            return UITableViewCell()
        }
        let todo = viewModel.getTodoForIndex(indexPath.row)
        cell.set(todo: todo)
        cell.selectionStyle = .none
        
        
        return cell
    }
}

// MARK: - TodoDelegate
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

// MARK: - TodoDetailViewControllerDelegate
extension TodosViewController: TodoDeletionDelegate{
    func didDeleteTodo() {
        viewModel.deleteSelectedTodo()
    }
}
