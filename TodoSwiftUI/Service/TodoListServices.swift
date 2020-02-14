//
//  TodoListServices.swift
//  TodoSwiftUI
//
//  Created by Laura Corssac on 1/26/20.
//  Copyright © 2020 Laura Corssac. All rights reserved.
//

import Foundation
import Combine

protocol ToDoServices {
    
    var didChangeContent: PassthroughSubject<Void, Never> { get }
    
    func getTodoItems() -> AnyPublisher<[TodoItem], URLError>
    func save(todoItem: TodoItem) -> AnyPublisher<Void, URLError>
    func update(id: UUID, to item: TodoItem) -> AnyPublisher<Void, URLError>
    func delete(item: TodoItem) -> AnyPublisher<Void, URLError>
    
}
