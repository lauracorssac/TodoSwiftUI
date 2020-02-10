//
//  TodoItemRowViewModel.swift
//  TodoSwiftUI
//
//  Created by Laura Corssac on 2/10/20.
//  Copyright © 2020 Laura Corssac. All rights reserved.
//

import Foundation
import Combine

class TodoItemRowViewModel: ObservableObject {
    
    @Published private(set) var isDone: Bool
    let checkButtonPressed = PassthroughSubject<Void, Never>()
    private var subscriptions = [AnyCancellable]()
    let todoItem: TodoItem
    
    init(todoItem: TodoItem, service: ToDoServices) {
        
        self.todoItem = todoItem
        
        isDone = todoItem.isDone
        
        checkButtonPressed
            .setFailureType(to: URLError.self)
            .flatMap { [weak self] _ in
                
                service.update(item: todoItem, to: !(self?.isDone ?? true))
        }
        .receive(on: RunLoop.main)
        .sink(receiveCompletion: { _ in }) { [weak self] _ in
            self?.isDone.toggle() }
        .store(in: &subscriptions)
        
    }
    
}
