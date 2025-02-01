//
//  NewTaskPresenterTests.swift
//  todoList
//
//  Created by Сергей Киселев on 01.02.2025.
//

import XCTest
@testable import todoList

class NewTaskPresenterTests: XCTestCase {
    
    var presenter: NewTaskPresenter!
    var mockView: MockNewTaskView!
    var mockInteractor: MockNewTaskInteractor!
    var mockRouter: MockNewTaskRouter!
    
    override func setUp() {
        super.setUp()
        mockView = MockNewTaskView()
        mockInteractor = MockNewTaskInteractor()
        mockRouter = MockNewTaskRouter()
        presenter = NewTaskPresenter(view: mockView, interactor: mockInteractor, router: mockRouter)
    }
    
    override func tearDown() {
        presenter = nil
        mockView = nil
        mockInteractor = nil
        mockRouter = nil
        super.tearDown()
    }
    
    func testDidTapSave_WithValidTitle_CallsSaveTaskAndDismiss() {
        presenter.didTapSave(title: "New Task")
        
        XCTAssertTrue(mockInteractor.isSaveTaskCalled, "saveTask() должен быть вызван")
        XCTAssertTrue(mockRouter.isDismissCalled, "dismiss() должен быть вызван")
    }
    
    func testDidTapSave_WithEmptyTitle_ShowsAlert() {
        presenter.didTapSave(title: "")
        
        XCTAssertTrue(mockView.isShowAlertCalled, "showAlert() должен быть вызван")
    }
    
    func testDidTapCancel_CallsDismiss() {
        presenter.didTapCancel()
        
        XCTAssertTrue(mockRouter.isDismissCalled, "dismiss() должен быть вызван")
    }
}

// Mock классы для тестов
class MockNewTaskView: NewTaskViewProtocol {
    var isShowAlertCalled = false
    
    func showAlert(title: String, message: String) {
        isShowAlertCalled = true
    }
}

class MockNewTaskInteractor: NewTaskInteractorProtocol {
    var isSaveTaskCalled = false
    
    func saveTask(title: String) {
        isSaveTaskCalled = true
    }
}

class MockNewTaskRouter: NewTaskRouterProtocol {
    var isDismissCalled = false
    
    func dismiss() {
        isDismissCalled = true
    }
}
