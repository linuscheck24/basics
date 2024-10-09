//
//  TodoViewModelTests.swift
//  basicsTests
//
//  Created by Linus Widing on 08.10.24.
//

import XCTest
@testable import basics


class MockTodoAPIService: TodoAPIService {
    var todos: [ToDo] = []
    var shouldReturnError = false
    
    override func fetchUserTodos() async throws -> [ToDo] {
        if shouldReturnError {
            let error = APIServiceError.unauthorized
            throw error
        }
        return todos
    }
}

class MockTodoDelegate: TodoDelegate {
    var didUpdateTodosCalled = false
    var didFailWithErrorCalled = false
    var receivedError: Error?
    
    func didUpdateTodos() {
        didUpdateTodosCalled = true
    }
    
    func didFailWithError(_ error: Error) {
        didFailWithErrorCalled = true
        receivedError = error
    }
}

class TodosViewModelTests: XCTestCase {
    
    var viewModel: TodosViewModel!
    var mockTodoAPIService: MockTodoAPIService!
    var mockDelegate: MockTodoDelegate!
    
    override func setUp() {
        super.setUp()
        mockTodoAPIService = MockTodoAPIService()
        mockDelegate = MockTodoDelegate()
        viewModel = TodosViewModel(todoAPIService: mockTodoAPIService)
        viewModel.delegate = mockDelegate
    }
    
    override func tearDown() {
        viewModel = nil
        mockTodoAPIService = nil
        mockDelegate = nil
        super.tearDown()
    }
    
    // Testing the successful fetch of todos
    func testFetchTodosSuccess() async {
        // Given
        let expectedTodos = ToDo.mockData
        mockTodoAPIService.todos = expectedTodos
        
        // When
        await viewModel.fetchTodos()
        
        // Then
        XCTAssertTrue(mockDelegate.didUpdateTodosCalled)
        XCTAssertEqual(viewModel.todos.count, expectedTodos.count)
        XCTAssertEqual(viewModel.todos.first?.title, expectedTodos.first?.title)
    }
    
    // Testing the failure of fetchTodos
    func testFetchTodosFailure() async {
        // Given
        mockTodoAPIService.shouldReturnError = true
        
        // When
        await viewModel.fetchTodos()
        
        // Then
        XCTAssertTrue(mockDelegate.didFailWithErrorCalled)
        XCTAssertNotNil(mockDelegate.receivedError)
        XCTAssertEqual(viewModel.todos.count, 0)
    }
    
    //Testing the getTodoCount method
    func testGetTodoCount(){
        // Given
        let todos = ToDo.mockData
        
        viewModel.todos = todos
        
        //When
        let count = viewModel.getTodoCount()
        
        //Then
        XCTAssertEqual(count, 5)
        
    }
    
    // Testing getTodoForIndex method
    func testGetTodoForIndex() {
        // Given
        let todos = ToDo.mockData
        viewModel.todos = todos
        
        // When
        let todoAtIndex = viewModel.getTodoForIndex(1)
        
        // Then
        XCTAssertEqual(todoAtIndex.title, todos[1].title)
    }
}
