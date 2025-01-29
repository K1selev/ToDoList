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
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .yellow
        button.backgroundColor = .clear
        button.layer.cornerRadius = 30
        return button
    }()
    
    private let taskCountLabel = UILabel()

    private var tasks: [Task] = []
    private var filteredTasks: [Task] = []
    private var isSearchActive = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.loadTasks()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        title = "Задачи"
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
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .gray
        
        let toolbar = UIToolbar()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.barTintColor = .black
        view.addSubview(toolbar)
        
        NSLayoutConstraint.activate([
            toolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolbar.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        let addTaskButton = UIBarButtonItem(customView: addButton)
        addTaskButton.tintColor = .yellow
        
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
    
    @objc private func didTapAddTask() {
        print("Создание новой задачи")
    }
    
    func updateFilteredTasks(with searchText: String) {
        if searchText.isEmpty {
            isSearchActive = false
            filteredTasks = tasks
            updateTaskCount()
        } else {
            isSearchActive = true
            filteredTasks = presenter.tasks.filter { task in
                return task.title.lowercased().contains(searchText.lowercased())
            }
            updateTaskCount()
        }
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
        cell.onCheckmarkTap = {
            var updatedTask = task
            updatedTask.isCompleted.toggle()  // Переключаем статус задачи
            self.presenter.updateTask(updatedTask)
        }
        return cell
    }
}

extension ToDoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        var task = isSearchActive ? filteredTasks[indexPath.row] : presenter.tasks[indexPath.row]
//        task.isCompleted.toggle()
//        
//        presenter.updateTask(task)
//        
//        tableView.reloadRows(at: [indexPath], with: .automatic)
        let task = presenter.tasks[indexPath.row]
        let detailVC = TaskDetailViewController(task: task)
        navigationController?.pushViewController(detailVC, animated: true)
            
    }
}
