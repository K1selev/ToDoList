//
//  NewTaskModuleBuilder.swift
//  todoList
//
//  Created by Сергей Киселев on 01.02.2025.
//

import UIKit

class NewTaskModuleBuilder {
    static func build() -> UIViewController {
        let view = NewTaskViewController()
        let interactor = NewTaskInteractor()
        let router = NewTaskRouter(viewController: view)
        let presenter = NewTaskPresenter(view: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        
        return view
    }
}
