//
//  CoreDataManager.swift
//  todoList
//
//  Created by Сергей Киселев on 30.01.2025.
//

import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Ошибка сохранения: \(error.localizedDescription)")
        }
    }

    func fetchTasks() -> [TaskEntity] {
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Ошибка загрузки задач: \(error.localizedDescription)")
            return []
        }
    }

    func addTask(title: String) {
        let task = TaskEntity(context: context)
        task.id = UUID()
        task.title = title
        task.isCompleted = false
        saveContext()
    }

    func updateTask(_ task: TaskEntity, title: String? = nil, isCompleted: Bool? = nil) {
        if let title = title { task.title = title }
        if let isCompleted = isCompleted { task.isCompleted = isCompleted }
        saveContext()
    }

    func deleteTask(_ task: TaskEntity) {
        context.delete(task)
        saveContext()
    }
}
