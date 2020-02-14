//
//  TodoListService.swift
//  TodoSwiftUI
//
//  Created by Laura Corssac on 1/12/20.
//  Copyright © 2020 Laura Corssac. All rights reserved.
//

import Foundation
import Combine

class TodoListService: ToDoServices {
    
    let didChangeContent = PassthroughSubject<Void, Never>()
    
    func update(id: UUID, to item: TodoItem) -> AnyPublisher<Void, URLError> {
        return Just(Void())
            .mapError { _ in URLError(URLError.unknown) }
            .eraseToAnyPublisher()
    }
    
    func save(todoItem: TodoItem) -> AnyPublisher<Void, URLError> {
        
        return Just(Void())
            .mapError { _ in URLError(URLError.unknown) }
            .eraseToAnyPublisher()
        
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
    
    func delete(item: TodoItem) -> AnyPublisher<Void, URLError> {
        
        return Just(Void())
            .mapError { _ in URLError(URLError.unknown) }
            .eraseToAnyPublisher()
    }
    
}
