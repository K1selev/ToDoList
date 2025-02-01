//
//  ToDoListPresenterTests.swift
//  todoList
//
//  Created by Сергей Киселев on 01.02.2025.
//

import XCTest
@testable import todoList

class ToDoListPresenterTests: XCTestCase {
    
    class MockView: ToDoListViewProtocol {
        var didReloadData = false
        func reloadData() {
            didReloadData = true
        }
    }
    
    class MockInteractor: ToDoListInteractorProtocol {
        var mockTasks: [Task] = []
        func fetchTasks(completion: @escaping ([Task]) -> Void) {
            completion(mockTasks)
        }
    }
    
    class MockRouter: ToDoListRouterProtocol {
        var didNavigateToTaskDetail = false
        var didNavigateToEditTask = false
        
        func navigateToTaskDetail() {
            didNavigateToTaskDetail = true
        }
        
        func navigateToEditTask(_ task: Task) {
            didNavigateToEditTask = true
        }
    }
    
    func test_loadTasks_fetchesTasksAndReloadsView() {
        let view = MockView()
        let interactor = MockInteractor()
        let router = MockRouter()
        let presenter = ToDoListPresenter(view: view, interactor: interactor, router: router)
        
        presenter.loadTasks()
        
        XCTAssertTrue(view.didReloadData)
    }
    
    func test_updateTask_updatesTaskAndReloadsView() {
        let view = MockView()
        let interactor = MockInteractor()
        let router = MockRouter()
        let presenter = ToDoListPresenter(view: view, interactor: interactor, router: router)
        
//        let task = TaskEntity(id: UUID(), title: "Test Task", isCompleted: false)
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let task = TaskEntity(context: context)
        task.id = UUID()
        task.title = "Test Task"
        task.isCompleted = false
        
        presenter.tasks = [task]
        
//        let updatedTask = TaskEntity(id: task.id, title: "Updated Task", isCompleted: true)
        let contextUpd = CoreDataManager.shared.persistentContainer.viewContext
        let updatedTask = TaskEntity(context: contextUpd)
        updatedTask.id = UUID()
        updatedTask.title = "Updated Task"
        updatedTask.isCompleted = false
        presenter.updateTask(updatedTask)
        
        XCTAssertEqual(presenter.tasks.first?.title, "Updated Task")
        XCTAssertTrue(view.didReloadData)
    }
}
