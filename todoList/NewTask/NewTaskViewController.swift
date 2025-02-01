//
//  NewTaskViewController.swift
//  todoList
//
//  Created by Сергей Киселев on 30.01.2025.
//

import UIKit

class NewTaskViewController: UIViewController {
    
    var presenter: NewTaskPresenterProtocol?

    private let taskTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название задачи"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .black
        textField.textColor = .white
        textField.layer.borderColor = UIColor(named: "CustomYellow")?.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 8
        textField.tintColor = UIColor(named: "CustomYellow")
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        title = "Новая задача"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(named: "CustomYellow")!]

        let backButton = UIButton(type: .system)
        backButton.setTitle(" Назад", for: .normal)
        backButton.setTitleColor(UIColor(named: "CustomYellow"), for: .normal)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = UIColor(named: "CustomYellow")
        backButton.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        
        backButton.contentHorizontalAlignment = .left
        backButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        
        let backBarButton = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButton
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapSave))
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "CustomYellow")

        view.addSubview(taskTextField)
        taskTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            taskTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            taskTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            taskTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            taskTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            taskTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc private func didTapCancel() {
        presenter?.didTapCancel()
    }
    
    @objc private func didTapSave() {
        presenter?.didTapSave(title: taskTextField.text)
    }
}

extension NewTaskViewController: NewTaskViewProtocol {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
