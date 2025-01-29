//
//  APIService.swift
//  todoList
//
//  Created by Сергей Киселев on 29.01.2025.
//

import Foundation

class APIService {
    func fetchTasks(completion: @escaping ([Task]) -> Void) {
        guard let url = URL(string: "https://dummyjson.com/todos") else { return }
        
        DispatchQueue.global(qos: .background).async {
            URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil else { return }
                
                do {
                    let response = try JSONDecoder().decode(TodoResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(response.todos)
                    }
                } catch {
                    print("Ошибка парсинга JSON: \(error)")
                }
            }.resume()
        }
    }
}
