//
//  TodoDetailsViewModel.swift
//  TodoSwiftUI
//
//  Created by Laura Corssac on 2/10/20.
//  Copyright © 2020 Laura Corssac. All rights reserved.
//

import Foundation
import Combine

struct DateStyle {
    
    let dateFormat: String
    
    static let defaultStyle = DateStyle(dateFormat: "dd MMMM yyyy")
    
}

extension DateFormatter {
    
    func format(date: Date, using style: DateStyle) -> String {
        
        self.locale = Locale(identifier: "pt-br")
        self.dateFormat = style.dateFormat
        return self.string(from: date)
        
    }

}
class TodoDetailsViewModel {
    
    @Published private(set) var shouldpresentError = false
    @Published private(set) var deletionSucceeded = false
    
    @Published private(set) var dateString: String
    @Published private(set) var title: String
    
    let deleteButtonPressed = PassthroughSubject<Void, Never>()
    let todoItem: TodoItemReactive
    
    private var cancellables = [AnyCancellable]()
    
    init(todoItem: TodoItemReactive, service: ToDoServices, style: DateStyle = .defaultStyle) {
        
        self.todoItem = todoItem
        self.title = todoItem.title
        
        if let date = todoItem.date {
            dateString = DateFormatter()
                .format(date: date , using: style)
        } else {
            dateString = ""
        }
       
        deleteButtonPressed
            .setFailureType(to: URLError.self)
            .flatMap {
                service.delete(item: todoItem.asTodoItem())
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
