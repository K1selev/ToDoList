//
//  EditTaskViewControllerTests.swift
//  todoList
//
//  Created by Сергей Киселев on 01.02.2025.
//

import XCTest
@testable import todoList

class EditTaskViewControllerTests: XCTestCase {

    var sut: EditTaskViewController!
    var mockTask: TaskEntity!
    var mockNavigationController: UINavigationController!
    var didSaveTask: TaskEntity?

    override func setUp() {
        super.setUp()
        sut = EditTaskViewController()
        
        // Создаем моковый task
        mockTask = TaskEntity(context: CoreDataManager.shared.context)
        mockTask.title = "Test Task"
        
        sut.task = mockTask
        sut.onSave = { task in
            self.didSaveTask = task
        }
        
        mockNavigationController = UINavigationController(rootViewController: sut)
        _ = sut.view  // Вызываем загрузку View
    }

    override func tearDown() {
        sut = nil
        mockTask = nil
        mockNavigationController = nil
        didSaveTask = nil
        super.tearDown()
    }

    func testLoadTaskData_ShouldSetTitleTextField() {
        XCTAssertEqual(sut.titleTextField.text, "Test Task")
    }

    func testDidTapSave_ShouldUpdateTaskTitle() {
        // Симулируем ввод нового названия
        sut.titleTextField.text = "Updated Task"
        
        // Нажимаем "Сохранить"
        sut.didTapSave()
        
        // Проверяем, что task обновился
        XCTAssertEqual(didSaveTask?.title, "Updated Task")
    }

    func testDidTapSave_ShouldPopViewController() {
        let initialVCCount = mockNavigationController.viewControllers.count
        sut.didTapSave()
        XCTAssertEqual(mockNavigationController.viewControllers.count, initialVCCount - 1)
    }

    func testDidTapCancel_ShouldPopViewController() {
        let initialVCCount = mockNavigationController.viewControllers.count
        sut.didTapCancel()
        XCTAssertEqual(mockNavigationController.viewControllers.count, initialVCCount - 1)
    }
}
