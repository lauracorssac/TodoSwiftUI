//
//  TodoItemReactive.swift
//  TodoSwiftUI
//
//  Created by Laura Corssac on 2/14/20.
//  Copyright © 2020 Laura Corssac. All rights reserved.
//

import Foundation

class TodoItemReactive: ObservableObject {
    
    let id: UUID
    @Published var title: String
    @Published var date: Date?
    @Published var isDone: Bool
    
    init(id: UUID, title: String, isDone: Bool, date: Date?) {
        self.id = id
        self.title = title
        self.isDone = isDone
        self.date = date
    }
    
    func asTodoItem() -> TodoItem {
        return TodoItem(id: self.id, title: self.title, date: self.date, isDone: self.isDone)
    }
}
