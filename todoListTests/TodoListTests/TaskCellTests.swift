//
//  TaskCellTests.swift
//  todoList
//
//  Created by Сергей Киселев on 02.02.2025.
//

import XCTest
@testable import todoList

class TaskCellTests: XCTestCase {
    
    func test_configure_setsTaskTitle() {
        let cell = TaskCell()
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let task = TaskEntity(context: context)
        task.id = UUID()
        task.title = "Test Task"
        task.isCompleted = false
        
        cell.configure(with: task)
        
        XCTAssertEqual(cell.textLabel?.text, "Test Task")
    }
    
    func test_longPress_callsOnLongPress() {
        let cell = TaskCell()
        var longPressCalled = false
        cell.onLongPress = {
            longPressCalled = true
        }
        
        cell.didLongPress()
        
        XCTAssertTrue(longPressCalled)
    }
}
