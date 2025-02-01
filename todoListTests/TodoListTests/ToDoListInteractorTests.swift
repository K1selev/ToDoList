//
//  ToDoListInteractorTests.swift
//  todoList
//
//  Created by Сергей Киселев on 01.02.2025.
//

import XCTest
@testable import todoList

class ToDoListInteractorTests: XCTestCase {
    
    class MockAPIService: APIService {
        var mockTasks: [Task] = []
        
        override func fetchTasks(completion: @escaping ([Task]) -> Void) {
            completion(mockTasks)
        }
    }
    
    func test_fetchTasks_callsCompletionWithTasks() {
        let mockAPIService = MockAPIService()
        let interactor = ToDoListInteractor()
        
        let expectation = self.expectation(description: "Tasks fetched")
        interactor.fetchTasks { tasks in
            XCTAssertEqual(tasks.count, mockAPIService.mockTasks.count)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
}
