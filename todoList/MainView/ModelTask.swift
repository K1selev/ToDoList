//
//  Model.swift
//  todoList
//
//  Created by Сергей Киселев on 29.01.2025.
//

import Foundation

struct Task: Codable {
    let id: Int
    var title: String
    var isCompleted: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case title = "todo"
        case isCompleted = "completed"
    }
}

struct TodoResponse: Codable {
    let todos: [Task]
}
