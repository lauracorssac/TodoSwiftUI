//
//  TodoDetailsViewModel.swift
//  TodoSwiftUI
//
//  Created by Laura Corssac on 2/10/20.
//  Copyright © 2020 Laura Corssac. All rights reserved.
//

import Foundation
import Combine

class TodoDetailsViewModel {
    
    @Published private(set) var shouldpresentError = false
    @Published private(set) var deletionSucceeded = false
    
    let deleteButtonPressed = PassthroughSubject<Void, Never>()
    let todoItem: TodoItem
    
    private var cancellables = [AnyCancellable]()
    
    init(todoItem: TodoItem, service: ToDoServices) {
        self.todoItem = todoItem
        
        deleteButtonPressed
            .setFailureType(to: URLError.self)
            .flatMap {
                service.delete(item: todoItem)
        }.sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                break
            case .failure(_):
                self.shouldpresentError = true
            }
        }) {  _ in
            self.deletionSucceeded = true
        }.store(in: &cancellables)
        
    }

}
