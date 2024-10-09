//
//  basicsSnapshotTests.swift
//  basicsSnapshotTests
//
//  Created by Linus Widing on 08.10.24.
//

import SnapshotTesting
import XCTest
@testable import basics

class ViewControllerTests: XCTestCase {
    
    
    func testLoginViewController() {
        let vc = LoginViewController()
        
        vc.overrideUserInterfaceStyle = .light
        
        assertSnapshot(of: vc, as: .image)
    }
    
    func testTodosViewController(){
        let vc = TodosViewController(viewModel: TodosViewModel())
        let viewModel = TodosViewModel()
        viewModel.todos = ToDo.mockData
        viewModel.todosAreLoaded = true
        vc.viewModel = viewModel
        
        vc.overrideUserInterfaceStyle = .light
        
        assertSnapshot(of: vc, as: .image)
    }
    
    
}
