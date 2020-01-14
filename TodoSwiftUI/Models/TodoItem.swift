//
//  TodoItem.swift
//  TodoSwiftUI
//
//  Created by Laura Corssac on 1/12/20.
//  Copyright © 2020 Laura Corssac. All rights reserved.
//

import Foundation

struct TodoItem: Codable, Identifiable {
    
    let id: Int
    let title: String
    //let date: Date
    let isDone: Bool
}

class TodoItemReactive: ObservableObject {
    
    let id: Int
    let title: String
    @Published var isDone: Bool
    
    init(id: Int, title: String, isDone: Bool) {
        self.id = id
        self.title = title
        self.isDone = isDone
    }
}

class TodoItemConverter {
    func convertToReactive(todoItem: TodoItem) -> TodoItemReactive {
        TodoItemReactive(id: todoItem.id,
                         title: todoItem.title,
                         isDone: todoItem.isDone)
    }
}
