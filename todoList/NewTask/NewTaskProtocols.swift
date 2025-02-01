//
//  NewTaskProtocols.swift
//  todoList
//
//  Created by Сергей Киселев on 01.02.2025.
//

import Foundation

protocol NewTaskViewProtocol: AnyObject {
    func showAlert(title: String, message: String)
}

protocol NewTaskPresenterProtocol: AnyObject {
    func didTapSave(title: String?)
    func didTapCancel()
}

protocol NewTaskInteractorProtocol: AnyObject {
    func saveTask(title: String)
}

protocol NewTaskRouterProtocol: AnyObject {
    func dismiss()
}
