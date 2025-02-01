//
//  NewTaskInteractor.swift
//  todoList
//
//  Created by Сергей Киселев on 01.02.2025.
//

import Foundation

class NewTaskInteractor: NewTaskInteractorProtocol {
    
    func saveTask(title: String) {
        CoreDataManager.shared.addTask(title: title)
        NotificationCenter.default.post(name: NSNotification.Name("TaskAdded"), object: nil)
    }
}
