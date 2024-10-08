//
//  basicsTests.swift
//  basicsTests
//
//  Created by Linus Widing on 08.10.24.
//

import XCTest
@testable import basics


class MockAPIService: APIService {
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
    var mockAPIService: MockAPIService!
    var mockDelegate: MockTodoDelegate!
    
    override func setUp() {
        super.setUp()
        mockAPIService = MockAPIService()
        mockDelegate = MockTodoDelegate()
        viewModel = TodosViewModel(apiService: mockAPIService)
        viewModel.delegate = mockDelegate
    }
    
    override func tearDown() {
        viewModel = nil
        mockAPIService = nil
        mockDelegate = nil
        super.tearDown()
    }
    
    // Testing the successful fetch of todos
    func testFetchTodosSuccess() async {
        // Given
        let expectedTodos = [ToDo(id: 1, title: "Test1", text: "Test", isDone: true, ownerId: 1, position: 1),
                             ToDo(id: 2, title: "Test2", text: "Test", isDone: true, ownerId: 1, position: 2)]
        mockAPIService.todos = expectedTodos
        
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
        mockAPIService.shouldReturnError = true
        
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
        let todos = [ToDo(id: 1, title: "Test1", text: "Test", isDone: true, ownerId: 1, position: 1),
                     ToDo(id: 2, title: "Test2", text: "Test", isDone: true, ownerId: 1, position: 2)]
        
        viewModel.todos = todos
        
        //When
        let count = viewModel.getTodoCount()
        
        //Then
        XCTAssertEqual(count, 2)
        
    }
    
    // Testing getTodoForIndex method
    func testGetTodoForIndex() {
        // Given
        let todos = [ToDo(id: 1, title: "Test1", text: "Test", isDone: true, ownerId: 1, position: 1),
                     ToDo(id: 2, title: "Test2", text: "Test", isDone: true, ownerId: 1, position: 2)]
        viewModel.todos = todos
        
        // When
        let todoAtIndex = viewModel.getTodoForIndex(1)
        
        // Then
        XCTAssertEqual(todoAtIndex.title, todos[1].title)
    }
}
