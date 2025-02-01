//
//  NewTaskInteractorTests.swift
//  todoList
//
//  Created by Сергей Киселев on 01.02.2025.
//

import XCTest
@testable import todoList

class NewTaskInteractorTests: XCTestCase {
    
    var interactor: NewTaskInteractor!
    var mockCoreDataManager: MockCoreDataManager!
    
    override func setUp() {
        super.setUp()
        mockCoreDataManager = MockCoreDataManager()
        interactor = NewTaskInteractor()
    }
    
    override func tearDown() {
        interactor = nil
        mockCoreDataManager = nil
        super.tearDown()
    }
    
    func testSaveTask_CallsCoreDataManager() {
        interactor.saveTask(title: "Test Task")
        
        XCTAssertTrue(mockCoreDataManager.isAddTaskCalled, "addTask() должен быть вызван")
    }
}

// Mock для CoreDataManager
class MockCoreDataManager {
    var isAddTaskCalled = false
    
    func addTask(title: String) {
        isAddTaskCalled = true
    }
}
