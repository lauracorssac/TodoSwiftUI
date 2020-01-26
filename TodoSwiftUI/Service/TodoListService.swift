//
//  TodoListService.swift
//  TodoSwiftUI
//
//  Created by Laura Corssac on 1/12/20.
//  Copyright © 2020 Laura Corssac. All rights reserved.
//

import Foundation
import Combine

protocol ToDoServices {
    func getTodoItems() -> AnyPublisher<[TodoItem], URLError>
    func save(todoItem: TodoItem) -> AnyPublisher<Void, URLError>
}

class TodoListService: ToDoServices {
    
    func save(todoItem: TodoItem) -> AnyPublisher<Void, URLError> {
        
        return Just(Void())
            .mapError { _ in URLError(URLError.unknown) }
            .eraseToAnyPublisher()
        
//        return Fail<Void, URLError>(error: URLError(URLError.unsupportedURL))
//            .eraseToAnyPublisher()
        
    }
    
    func getTodoItems() -> AnyPublisher<[TodoItem], URLError> {
        
        let urlString = "http://localhost:3000/getTodoList"
        
        guard let url = URL(string: urlString) else {
            return Fail<[TodoItem], URLError>(error: URLError(URLError.unsupportedURL))
                .eraseToAnyPublisher()
        }
        
        let response = URLSession
            .shared
            .dataTaskPublisher(for: url)
            .tryMap { data, response in
                try JSONDecoder().decode([TodoItem].self, from: data)
            }.mapError { _ in
                return URLError(URLError.badServerResponse)
            }.eraseToAnyPublisher()
        
        return response
    }
}
