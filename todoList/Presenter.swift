//
//  PresenterProtocol.swift
//  todoList
//
//  Created by Сергей Киселев on 29.01.2025.
//

protocol ToDoListPresenterProtocol {
    var tasks: [Task] { get }
    func loadTasks()
    func updateTask(_ task: Task)
}

class ToDoListPresenter: ToDoListPresenterProtocol {
    weak var view: ToDoListViewProtocol?
    private let interactor: ToDoListInteractorProtocol
    private let router: ToDoListRouterProtocol
    
    var tasks: [Task] = []
    
    init(view: ToDoListViewProtocol, interactor: ToDoListInteractorProtocol, router: ToDoListRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func loadTasks() {
        interactor.fetchTasks { [weak self] tasks in
            self?.tasks = tasks
            self?.view?.reloadData()
        }
    }
    func updateTask(_ task: Task) {
            if let index = tasks.firstIndex(where: { $0.id == task.id }) {
                tasks[index] = task
            }
        }
}
