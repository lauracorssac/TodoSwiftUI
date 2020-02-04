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
    
    func getTodoItems() -> AnyPublisher<[TodoItem], URLError> {
        let todoItems = [
            TodoItem(id: 0, title: "todo item 0", date: "22/12/2019", isDone: false),
            TodoItem(id: 1, title: "todo item 1", date: "22/01/2020", isDone: true),
            TodoItem(id: 2, title: "todo item 2", date: "22/01/2020", isDone: false)
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
