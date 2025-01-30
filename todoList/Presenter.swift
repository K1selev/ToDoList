//
//  PresenterProtocol.swift
//  todoList
//
//  Created by Сергей Киселев on 29.01.2025.
//

import Foundation

protocol ToDoListPresenterProtocol {
    var tasks: [TaskEntity] { get }
    func loadTasks()
    func updateTask(_ task: TaskEntity)
    func deleteTask(_ task: TaskEntity)
}

class ToDoListPresenter: ToDoListPresenterProtocol {
    weak var view: ToDoListViewProtocol?
    private let interactor: ToDoListInteractorProtocol
    private let router: ToDoListRouterProtocol
    
    var tasks: [TaskEntity] = []
    private let hasLoadedTasksKey = "hasLoadedTasks"
    
    init(view: ToDoListViewProtocol, interactor: ToDoListInteractorProtocol, router: ToDoListRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func loadTasks() {
        let hasLoadedTasks = UserDefaults.standard.bool(forKey: hasLoadedTasksKey)
        
        if hasLoadedTasks {
            tasks = CoreDataManager.shared.fetchTasks()
            view?.reloadData()
        } else {
            interactor.fetchTasks { [weak self] tasks in
                guard let self = self else { return }
                for task in tasks {
                    CoreDataManager.shared.addTask(title: task.title ?? "")
                }
                UserDefaults.standard.setValue(true, forKey: self.hasLoadedTasksKey)
                
                self.tasks = CoreDataManager.shared.fetchTasks()
                self.view?.reloadData()
            }
        }
    }
    
    
    func updateTask(_ task: TaskEntity) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
        }
        CoreDataManager.shared.updateTask(task)
        view?.reloadData()
    }
    
    func deleteTask(_ task: TaskEntity) {
        CoreDataManager.shared.deleteTask(task)
        loadTasks()
    }
}
