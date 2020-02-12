//
//  TodoListServiceSuccessMock.swift
//  TodoSwiftUITests
//
//  Created by Laura Corssac on 1/26/20.
//  Copyright © 2020 Laura Corssac. All rights reserved.
//

import Foundation
import Combine
@testable import TodoSwiftUI

class TodoListServiceSuccessMock: ToDoServices {
    
    var didChangeContent = PassthroughSubject<Void, Never>()
    
    func update(item: TodoItem, to checked: Bool) -> AnyPublisher<Void, URLError> {
        
        return Just(())
            .mapError { _ in URLError(URLError.unknown) }
            .eraseToAnyPublisher()
    }
    
    func getTodoItems() -> AnyPublisher<[TodoItem], URLError> {
        let todoItems = [
            TodoItem(id: UUID(), title: "todo item 0", date: Date(), isDone: false),
            TodoItem(id: UUID(), title: "todo item 1", date: Date(), isDone: true),
            TodoItem(id: UUID(), title: "todo item 2", date: Date(), isDone: false)
        ]
        
        return Just(todoItems)
            .mapError { _ in URLError(URLError.unknown) }
            .eraseToAnyPublisher()
    }
    
    func save(todoItem: TodoItem) -> AnyPublisher<Void, URLError> {
        
        return Just(())
            .mapError { _ in URLError(URLError.unknown) }
            .eraseToAnyPublisher()
    }
    
}
