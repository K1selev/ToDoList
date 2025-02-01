//
//  ToDoListViewControllerTests.swift
//  todoList
//
//  Created by Сергей Киселев on 02.02.2025.
//

import XCTest
@testable import todoList

class ToDoListViewControllerTests: XCTestCase {
    
    class MockPresenter: ToDoListPresenterProtocol {
        var tasks: [TaskEntity] = []
        var didLoadTasks = false
        var didUpdateTask = false
        var didDeleteTask = false
        
        func loadTasks() {
            didLoadTasks = true
        }
        
        func updateTask(_ task: TaskEntity) {
            didUpdateTask = true
        }
        
        func deleteTask(_ task: TaskEntity) {
            didDeleteTask = true
        }
    }
    
    func test_viewDidLoad_callsLoadTasks() {
        let mockPresenter = MockPresenter()
        let viewController = ToDoListViewController()
        viewController.presenter = mockPresenter
        
        viewController.viewDidLoad()
        
        XCTAssertTrue(mockPresenter.didLoadTasks)
    }
    
    func test_didTapAddTask_pushesNewTaskViewController() {
        let viewController = ToDoListViewController()
        let mockNavController = UINavigationController(rootViewController: viewController)
        
        viewController.didTapAddTask()
        
        XCTAssertEqual(mockNavController.viewControllers.count, 2)
    }
}
