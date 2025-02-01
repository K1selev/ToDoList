//
//  NewTaskPresenter.swift
//  todoList
//
//  Created by Сергей Киселев on 01.02.2025.
//

import Foundation

class NewTaskPresenter: NewTaskPresenterProtocol {
    
    weak var view: NewTaskViewProtocol?
    var interactor: NewTaskInteractorProtocol?
    var router: NewTaskRouterProtocol?
    
    init(view: NewTaskViewProtocol, interactor: NewTaskInteractorProtocol, router: NewTaskRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func didTapSave(title: String?) {
        guard let title = title, !title.isEmpty else {
            view?.showAlert(title: "Ошибка", message: "Введите название задачи")
            return
        }
        
        interactor?.saveTask(title: title)
        router?.dismiss()
    }
    
    func didTapCancel() {
        router?.dismiss()
    }
}
