//
//  EditTaskViewController.swift
//  todoList
//
//  Created by Сергей Киселев on 30.01.2025.
//

import UIKit

class EditTaskViewController: UIViewController {

    var task: TaskEntity!
    var onSave: ((TaskEntity) -> Void)?
    
    let titleTextField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadTaskData()
        setupNavigationBar()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
//        title = "Edit Task"
        
        titleTextField.borderStyle = .roundedRect
        titleTextField.textColor = .white
        titleTextField.backgroundColor = .black
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleTextField)
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupNavigationBar() {
        //            title = "Edit Task"
        
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        
        let backButton = UIButton(type: .system)
        backButton.setTitle(" Назад", for: .normal)
        backButton.setTitleColor(UIColor(named: "CustomYellow"), for: .normal)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = UIColor(named: "CustomYellow")
        backButton.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)
        
        backButton.contentHorizontalAlignment = .left
        backButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        
        let backBarButton = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButton
    }
        
    
    
    private func loadTaskData() {
        titleTextField.text = task.title
    }

    @objc func didTapSave() {
        task.title = titleTextField.text ?? ""
        onSave?(task)
        navigationController?.popViewController(animated: true)
    }

    @objc func didTapCancel() {
        navigationController?.popViewController(animated: true)
    }
}
