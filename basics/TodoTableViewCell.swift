//
//  TodoTableViewCell.swift
//  basics
//
//  Created by Linus Widing on 06.10.24.
//

import UIKit

class TodoTableViewCell: UITableViewCell {
    
    let contentStack = UIStackView()
    let titleAndDescriptioStack = UIStackView()
    
    let todoTitle = UILabel()
    let todoDescription = UILabel()
    let todoStatusIndicator = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupContentStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(todo: ToDo){
        todoTitle.text = todo.title
        todoDescription.text = todo.text
        todoStatusIndicator.image = todo.isDone ? BasicsImages.checkmarkCircleFilled : BasicsImages.checkmarkCircle
    }
    
    func setupContentStack() {
        addSubview(contentStack)
        
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .horizontal
        contentStack.distribution = .fill
        contentStack.alignment = .center
        contentStack.spacing = BasicsSizes.paddingSmall
        
        contentStack.pin(to: self)
        
        setupTitleAndDescriptionStack()
        setupTodoStatusIndicator()
        
        contentStack.addArrangedSubview(titleAndDescriptioStack)
        contentStack.addArrangedSubview(todoStatusIndicator)
    }
    
    func setupTitleAndDescriptionStack() {
        titleAndDescriptioStack.axis = .vertical
        titleAndDescriptioStack.distribution = .fillProportionally
        titleAndDescriptioStack.alignment = .leading
        titleAndDescriptioStack.spacing = 5
        
        titleAndDescriptioStack.addArrangedSubview(todoTitle)
        titleAndDescriptioStack.addArrangedSubview(todoDescription)
        
        todoTitle.font = UIFont.boldSystemFont(ofSize: BasicsSizes.fontSizePrimary)
        todoDescription.font = UIFont.systemFont(ofSize: BasicsSizes.fontSizeSecondary)
        todoDescription.textColor = .gray
    }
    
    func setupTodoStatusIndicator() {
        todoStatusIndicator.contentMode = .scaleAspectFit
        todoStatusIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            todoStatusIndicator.widthAnchor.constraint(equalToConstant: BasicsSizes.doneIndicatorSize),
            todoStatusIndicator.heightAnchor.constraint(equalToConstant: BasicsSizes.doneIndicatorSize)
        ])
    }
}
