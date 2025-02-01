//
//  NewTaskRouterTests.swift
//  todoList
//
//  Created by Сергей Киселев on 01.02.2025.
//

import XCTest
@testable import todoList

class NewTaskRouterTests: XCTestCase {
    
    var router: NewTaskRouter!
    var mockViewController: MockViewController!
    
    override func setUp() {
        super.setUp()
        mockViewController = MockViewController()
        router = NewTaskRouter(viewController: mockViewController)
    }
    
    override func tearDown() {
        router = nil
        mockViewController = nil
        super.tearDown()
    }
    
    func testDismiss_CallsNavigationPop() {
        router.dismiss()
        
        XCTAssertTrue(mockViewController.isPopViewControllerCalled, "popViewController() должен быть вызван")
    }
}

// Mock ViewController для тестов
class MockViewController: UIViewController {
    var isPopViewControllerCalled = false
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isPopViewControllerCalled = true
    }
}

