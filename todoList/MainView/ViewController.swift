//
//  ViewController.swift
//  todoList
//
//  Created by Сергей Киселев on 29.01.2025.
//

import UIKit

protocol ToDoListViewProtocol: AnyObject {
    func reloadData()
}

class ToDoListViewController: UIViewController, ToDoListViewProtocol {

    var presenter: ToDoListPresenterProtocol!

    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        button.tintColor = UIColor(named: "CustomYellow")
        return button
    }()

    private let taskCountLabel = UILabel()
    private var filteredTasks: [TaskEntity] = []
    private var isSearchActive = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.loadTasks()
    }

    private func setupUI() {
        view.backgroundColor = .black
        title = "Задачи"
        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        searchController.searchBar.placeholder = "Поиск задач"
        searchController.searchBar.barStyle = .black
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        searchController.searchBar.showsCancelButton = false
        
        view.addSubview(tableView)
        tableView.backgroundColor = .black
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TaskCell.self, forCellReuseIdentifier: "TaskCell")
        
        let toolbar = UIToolbar()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.barTintColor = UIColor(named: "CustomDarkGray")
        view.addSubview(toolbar)
        
        NSLayoutConstraint.activate([
            toolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolbar.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        let addTaskButton = UIBarButtonItem(customView: addButton)
        let taskCountItem = UIBarButtonItem(customView: taskCountLabel)
        
        taskCountLabel.textColor = .white
        taskCountLabel.font = UIFont.systemFont(ofSize: 16)
        
        taskCountLabel.translatesAutoresizingMaskIntoConstraints = false
        taskCountLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleSpace, taskCountItem, flexibleSpace, addTaskButton], animated: true)
        
        updateTaskCount()
        addButton.addTarget(self, action: #selector(didTapAddTask), for: .touchUpInside)
    }

    func reloadData() {
        tableView.reloadData()
        updateTaskCount()
    }

    private func updateTaskCount() {
        let totalTasks = isSearchActive ? filteredTasks.count : presenter.tasks.count
        taskCountLabel.text = "Задач: \(totalTasks)"
    }

    @objc func didTapAddTask() {
        let newTaskVC = NewTaskModuleBuilder.build()
        navigationController?.pushViewController(newTaskVC, animated: true)
    }

    func updateFilteredTasks(with searchText: String) {
        if searchText.isEmpty {
            isSearchActive = false
        } else {
            isSearchActive = true
            filteredTasks = presenter.tasks.filter { $0.title?.lowercased().contains(searchText.lowercased()) ?? false }
        }
        updateTaskCount()
        tableView.reloadData()
    }
}

extension ToDoListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        updateFilteredTasks(with: searchText)
    }
}

extension ToDoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchActive ? filteredTasks.count : presenter.tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = isSearchActive ? filteredTasks[indexPath.row] : presenter.tasks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        cell.configure(with: task)
        cell.onLongPress = { [weak self] in
            self?.showContextMenu(for: task, at: indexPath)
        }
        return cell
    }
}

extension ToDoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = isSearchActive ? filteredTasks[indexPath.row] : presenter.tasks[indexPath.row]
        task.isCompleted.toggle()
        presenter.updateTask(task)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

extension ToDoListViewController {
        func showContextMenu(for task: TaskEntity, at indexPath: IndexPath) {
    
            let blurEffect = UIBlurEffect(style: .dark)
            let blurView = UIVisualEffectView(effect: blurEffect)
            blurView.frame = view.bounds
            blurView.alpha = 0
            blurView.isUserInteractionEnabled = true
            view.addSubview(blurView)
    
            UIView.animate(withDuration: 0.3) {
                blurView.alpha = 1
            }
    
            let taskView = UIView()
            taskView.backgroundColor = UIColor(named: "CustomDarkGray")
            taskView.layer.cornerRadius = 10
            taskView.tag = 99
            taskView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(taskView)
    
            let taskLabel = UILabel()
            taskLabel.text = task.title
            taskLabel.textColor = .white
            taskLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            taskLabel.numberOfLines = 0
            taskLabel.translatesAutoresizingMaskIntoConstraints = false
            taskView.addSubview(taskLabel)
    
            let menuView = UIView()
            menuView.backgroundColor = .lightGray
            menuView.layer.cornerRadius = 10
            menuView.tag = 999
            menuView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(menuView)
    
            let editButton = createMenuButton(title: "Редактировать", icon: "edit", color: .black, action: {
                self.hideContextMenu(blurView, menuView, taskView)
                let editVC = EditTaskViewController()
                editVC.task = task
                editVC.onSave = { updatedTask in
                    self.presenter.updateTask(updatedTask)
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
                self.navigationController?.pushViewController(editVC, animated: true)
                self.hideContextMenu(blurView, menuView, taskView)
                self.hideContextMenu(blurView, menuView, taskView)
            })
    
            let shareButton = createMenuButton(title: "Поделиться", icon: "export", color: .black, action: {
                let activityVC = UIActivityViewController(activityItems: [task.title ?? ""], applicationActivities: nil)
                self.present(activityVC, animated: true)
                self.hideContextMenu(blurView, menuView, taskView)
                self.hideContextMenu(blurView, menuView, taskView)
            })
    
            let deleteButton = createMenuButton(title: "Удалить", icon: "trash", color: .red, action: {
                self.presenter.deleteTask(task)
                self.hideContextMenu(blurView, menuView, taskView)
                self.hideContextMenu(blurView, menuView, taskView)
            })
            editButton.setTitleColor(.black, for: .normal)
            shareButton.setTitleColor(.black, for: .normal)
            deleteButton.setTitleColor(.red, for: .normal)
    
            let stackView = UIStackView(arrangedSubviews: [editButton, shareButton, deleteButton])
            stackView.axis = .vertical
            stackView.spacing = 10
            stackView.translatesAutoresizingMaskIntoConstraints = false
            menuView.addSubview(stackView)
    
            NSLayoutConstraint.activate([
                // TaskView (с текстом задачи)
                taskView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                taskView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                taskView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 38),
                taskView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -38),
    
                taskLabel.topAnchor.constraint(equalTo: taskView.topAnchor, constant: 16),
                taskLabel.leadingAnchor.constraint(equalTo: taskView.leadingAnchor, constant: 16),
                taskLabel.trailingAnchor.constraint(equalTo: taskView.trailingAnchor, constant: -16),
                taskLabel.bottomAnchor.constraint(equalTo: taskView.bottomAnchor, constant: -16),
    
                // MenuView (меню под задачей)
                menuView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                menuView.topAnchor.constraint(equalTo: taskView.bottomAnchor, constant: 20),
                menuView.widthAnchor.constraint(equalToConstant: 254),
                menuView.heightAnchor.constraint(equalToConstant: 132),
    
                stackView.topAnchor.constraint(equalTo: menuView.topAnchor, constant: 10),
                stackView.leadingAnchor.constraint(equalTo: menuView.leadingAnchor, constant: 10),
                stackView.trailingAnchor.constraint(equalTo: menuView.trailingAnchor, constant: -10),
                stackView.bottomAnchor.constraint(equalTo: menuView.bottomAnchor, constant: -10)
            ])
    
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOutsideMenu(_:)))
            tapGesture.cancelsTouchesInView = false
            blurView.addGestureRecognizer(tapGesture)
        }
    
    
    
        @objc private func didTapOutsideMenu(_ sender: UITapGestureRecognizer) {
            guard let blurView = sender.view,
                  let menuView = view.subviews.first(where: { $0 !== blurView }),
                  let taskView = view.subviews.first(where: { $0 !== menuView })else { return }
            hideContextMenu(blurView, menuView, taskView)
            hideContextMenu(blurView, menuView, taskView)
        }
    
        private func hideContextMenu(_ blurView: UIView, _ menuView: UIView, _ taskView: UIView) {
            guard let blurView = self.view.subviews.first(where: { $0 is UIVisualEffectView }),
                let menuView = self.view.subviews.first(where: { $0.tag == 999 }),
                  let taskView = self.view.subviews.first(where: { $0.tag == 99 })
            else { return }
            taskView.removeFromSuperview()
                    blurView.removeFromSuperview()
                    menuView.removeFromSuperview()
        }
    
    private func createMenuButton(title: String, icon: String, color: UIColor, action: @escaping () -> Void) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.contentHorizontalAlignment = .left
        
        let iconImage = UIImage(named: icon)
        let iconView = UIImageView(image: iconImage)
        iconView.tintColor = color
        iconView.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(iconView)
        
        button.addAction(UIAction(handler: { _ in action() }), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            iconView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -10),
            iconView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 20),
            iconView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        return button
    }
}
