//
//  Interactor.swift
//  todoList
//
//  Created by Сергей Киселев on 29.01.2025.
//

import UIKit

protocol ToDoListInteractorProtocol {
    func fetchTasks(completion: @escaping ([Task]) -> Void)
}

class ToDoListInteractor: ToDoListInteractorProtocol {
    private let apiService = APIService()
    
    func fetchTasks(completion: @escaping ([Task]) -> Void) {
        DispatchQueue.global(qos: .background).async {
            self.apiService.fetchTasks { tasks in
                DispatchQueue.main.async {
                    completion(tasks)
                }
            }
        }
    }
}
