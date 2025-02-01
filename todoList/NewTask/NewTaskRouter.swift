//
//  NewTaskRouter.swift
//  todoList
//
//  Created by Сергей Киселев on 01.02.2025.
//

import UIKit

class NewTaskRouter: NewTaskRouterProtocol {
    
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func dismiss() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
