//
//  TodoDetailViewController.swift
//  basics
//
//  Created by Linus Widing on 07.10.24.
//

import UIKit
import SwiftUI

protocol TodoDetailViewControllerDelegate: AnyObject {
    func didDeleteTodo()
}

class TodoDetailViewController: UIViewController {
    
    var viewModel: TodoDetailViewModel!
    weak var delegate: TodoDetailViewControllerDelegate?
    
    let titleAndDescription = UIStackView()
    let contentArea = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        title = viewModel.getTitle()
        
        contentArea.addToSafeArea(to: view, padding: 10)
        
        setupTitleAndDescription()
        setupDeleteButton()
    }
    
    func setupDeleteButton() {
        var todoDeleteButton = TodoDeleteButton()
        todoDeleteButton.delegate = self
        
        let hostingController = UIHostingController(rootView: todoDeleteButton)
        
        addChild(hostingController)
        contentArea.addSubview(hostingController.view)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: contentArea.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: contentArea.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: contentArea.bottomAnchor)
        ])
        
        hostingController.didMove(toParent: self)
    }
    
    func setupTitleAndDescription(){
        contentArea.addSubview(titleAndDescription)
        titleAndDescription.translatesAutoresizingMaskIntoConstraints = false
        
        titleAndDescription.axis = .vertical
        titleAndDescription.spacing = 20
        titleAndDescription.alignment = .leading
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.text = viewModel.getTitle()
        
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = UIFont.systemFont(ofSize: 15)
        descriptionLabel.textColor = .gray
        descriptionLabel.text = viewModel.getDescription()
        descriptionLabel.numberOfLines = 0
        
        
        titleAndDescription.addArrangedSubview(titleLabel)
        titleAndDescription.addArrangedSubview(descriptionLabel)
    }
    
    
}


extension TodoDetailViewController: TodoDeleteButtonDelegate{
    func onDeleteClick() {
        self.delegate?.didDeleteTodo()
        self.navigationController?.popViewController(animated: true)
    }
}
