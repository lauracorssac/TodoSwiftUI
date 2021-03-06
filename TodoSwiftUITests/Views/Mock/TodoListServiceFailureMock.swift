//
//  TodoListServiceFailureMock.swift
//  TodoSwiftUITests
//
//  Created by Laura Corssac on 1/26/20.
//  Copyright © 2020 Laura Corssac. All rights reserved.
//

import Foundation
import Combine
@testable import TodoSwiftUI

class TodoListServiceFailureMock: ToDoServices {
    
    var didChangeContent = PassthroughSubject<Void, Never>()
    
    func delete(item: TodoItem) -> AnyPublisher<Void, URLError> {
        return Fail<Void, URLError>(error: URLError(URLError.unknown))
                  .eraseToAnyPublisher()
    }
    
    func update(item: TodoItem, to checked: Bool) -> AnyPublisher<Void, URLError> {
        
        return Fail<Void, URLError>(error: URLError(URLError.unknown))
            .eraseToAnyPublisher()
    }
    
    
    func getTodoItems() -> AnyPublisher<[TodoItem], URLError> {
        
        return Fail<[TodoItem], URLError>(error: URLError(URLError.unknown))
            .eraseToAnyPublisher()
        
    }
    
    func save(todoItem: TodoItem) -> AnyPublisher<Void, URLError> {
        
        return Fail<Void, URLError>(error: URLError(URLError.unknown))
            .eraseToAnyPublisher()
        
    }

    
}
