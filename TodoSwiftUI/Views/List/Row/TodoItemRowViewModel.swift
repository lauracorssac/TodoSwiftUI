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
    @Published private(set) var title: String
    
    let checkButtonPressed = PassthroughSubject<Void, Never>()
    private var subscriptions = [AnyCancellable]()
    let todoItem: TodoItemReactive
    
    init(todoItem: TodoItemReactive, service: ToDoServices) {
        
        self.todoItem = todoItem
        
        isDone = todoItem.isDone
        title = todoItem.title
        
        checkButtonPressed
            .map(getItem)
            .setFailureType(to: URLError.self)
            .flatMap { item in
                service.update(id: item.id, to: item) }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in }) { [weak self] _ in
                self?.isDone.toggle() }
            .store(in: &subscriptions)
        
    }
    
    func getItem() -> TodoItem {
        
        return TodoItem(id: UUID(),
                        title: self.todoItem.title,
                        date: self.todoItem.date,
                        isDone: !self.isDone)
    }
    
}
