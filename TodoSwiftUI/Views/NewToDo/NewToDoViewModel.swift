//
//  NewToDoViewModel.swift
//  TodoSwiftUI
//
//  Created by Laura Corssac on 1/16/20.
//  Copyright © 2020 Laura Corssac. All rights reserved.
//

import Foundation
import Combine

class NewToDoViewModel: ObservableObject {
    
    @Published var titleTyped: String
    @Published var dateChoosed: Date
    
    @Published private var dateFormatted: String = ""
    @Published var shouldPresentAlert: Bool = false
    @Published private(set) var shouldEnableDone: Bool = false
    @Published private(set) var shouldFinish: Bool = false
    
    private var subscriptions = [AnyCancellable]()
    private let todoItem: TodoItemReactive?
    private let service: ToDoServices
    private let isEditing: Bool
    
    let doneButtonPressed = PassthroughSubject<Void, Never>()
    
    init(service: ToDoServices, todoItem: TodoItemReactive? = nil) {
        
        self.todoItem = todoItem
        self.titleTyped = todoItem?.title ?? ""
        self.dateChoosed = todoItem?.date ?? Date()
        self.isEditing = (todoItem != nil)
        self.service = service
        
        $titleTyped
            .map { !$0.isEmpty }
            .assign(to: \.shouldEnableDone, on: self)
            .store(in: &subscriptions)
        
        $dateChoosed
            .map { date in
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "br")
                formatter.dateFormat = "dd MMMM yyyy"
                return formatter.string(from: date) }
            .assign(to: \.dateFormatted, on: self)
            .store(in: &subscriptions)
        
        doneButtonPressed
            .map(getItem)
            .flatMap({ [weak self] item -> AnyPublisher<Void, Never> in
                
                guard let self = self else {
                    return Empty<Void, Never>().eraseToAnyPublisher()
                }
                
                if self.isEditing {
                    return self.update(todoItem: item)
                } else {
                    return self.save(todoItem: item)
                }
                
                
            })
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] _ in
                self?.handleSuccess()
            }).store(in: &subscriptions)
        
    }
    
    func getItem() -> TodoItem {
        
        if let todoItem = self.todoItem {
            
            return TodoItem(id: todoItem.id, title: self.titleTyped, date: self.dateChoosed, isDone: todoItem.isDone)
        }
        
        return TodoItem(id: UUID(), title: self.titleTyped, date: self.dateChoosed, isDone: false)
    }
    
    func handleError(error: URLError) -> Empty<Void, Never> {
        
        self.shouldPresentAlert = true
        return Empty<Void, Never>()
    }
    
    func handleSuccess() {
         
        self.shouldFinish = true
        if let item = todoItem {
            
            item.title = self.titleTyped
            item.date = self.dateChoosed
            
        }
        
    }
    
    func save(todoItem: TodoItem) -> AnyPublisher<Void, Never> {
        return self.service
            .save(todoItem: todoItem)
            .receive(on: RunLoop.main)
            .catch(self.handleError(error:))
            .eraseToAnyPublisher()
    }
    
    func update(todoItem: TodoItem) -> AnyPublisher<Void, Never> {
           return self.service
               .update(id: todoItem.id, to: todoItem)
               .receive(on: RunLoop.main)
               .catch(self.handleError(error:))
               .eraseToAnyPublisher()
       }
    
}
