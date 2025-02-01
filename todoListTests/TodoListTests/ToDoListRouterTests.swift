//
//  ToDoListRouterTests.swift
//  todoList
//
//  Created by Сергей Киселев on 01.02.2025.
//

import XCTest
@testable import todoList

class ToDoListRouterTests: XCTestCase {
    
    func test_navigateToTaskDetail_pushesViewController() {
        let router = ToDoListRouter()
        let mockNavController = UINavigationController()
        let mockVC = UIViewController()
        mockNavController.viewControllers = [mockVC]
        
        router.viewController = mockVC
        
        router.navigateToTaskDetail()
        
        XCTAssertEqual(mockNavController.viewControllers.count, 1)
    }
    
    func test_navigateToEditTask_presentsViewController() {
        let router = ToDoListRouter()
        let mockVC = UIViewController()
        router.viewController = mockVC
        
        router.navigateToEditTask(Task(id: 0, title: "Test", isCompleted: false))
        
        XCTAssertNotNil(mockVC.presentedViewController)
    }
}
