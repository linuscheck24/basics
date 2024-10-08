//
//  basicsUITests.swift
//  basicsUITests
//
//  Created by Linus Widing on 08.10.24.
//

import XCTest

final class basicsUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLogin() throws {
        let app = XCUIApplication()
        app.launch()
        
        let usernameTextField = app.textFields["Username"]
        XCTAssertTrue(usernameTextField.exists)
        
        usernameTextField.tap()
        usernameTextField.typeText("demo")
        
        
        let passwordTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordTextField.exists)
        
        passwordTextField.tap()
        passwordTextField.typeText("demo")
        
        let loginBotton = app.buttons["Login"]
        XCTAssertTrue(loginBotton.exists)
        
        loginBotton.tap()
        
        let navigationBarTodosExists = app.navigationBars["Todos"].waitForExistence(timeout: 10)
        XCTAssertTrue(navigationBarTodosExists)
    }
    
    func testDeleteTodo() throws{
        
        try testLogin()
        
        let app = XCUIApplication()
        
        let tableView = app.tables.firstMatch

        XCTAssertTrue(tableView.exists)
        
        let firstCell = tableView.cells.firstMatch
        
        XCTAssertTrue(firstCell.exists)
        
        firstCell.tap()
        
        let deleteButton = app.buttons["Delete Todo"]
        XCTAssertTrue(deleteButton.exists)
        
        deleteButton.tap()
        
        let navigationBarTodosExists = app.navigationBars["Todos"].waitForExistence(timeout: 10)
        XCTAssertTrue(navigationBarTodosExists)
        
        let newFirstCell = tableView.cells.firstMatch
        XCTAssertNotEqual(firstCell, newFirstCell)
        
        
    }
}
