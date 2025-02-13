//
//  Router.swift
//  todoList
//
//  Created by Сергей Киселев on 29.01.2025.
//

import UIKit

protocol ToDoListRouterProtocol {
    func navigateToTaskDetail()
    func navigateToEditTask(_ task: Task)
}

class ToDoListRouter: ToDoListRouterProtocol {
    weak var viewController: UIViewController?
        
    static func createModule() -> UIViewController {
        let view = ToDoListViewController()
        let interactor = ToDoListInteractor()
        let router = ToDoListRouter()
        let presenter = ToDoListPresenter(view: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        router.viewController = view
        
        return view
    }

    func navigateToTaskDetail() {
//        let detailVC = TaskDetailViewController()
//        viewController?.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func navigateToEditTask(_ task: Task) {
//        let editVC = EditTaskViewController(task: task)
//        viewController?.present(editVC, animated: true)
    }
}
