//
//  TodoItem.swift
//  TodoSwiftUI
//
//  Created by Laura Corssac on 1/12/20.
//  Copyright © 2020 Laura Corssac. All rights reserved.
//

import Foundation
import CoreData

struct TodoItem: Codable, Identifiable {
    
    let id: UUID
    let title: String
    let date: Date?
    let isDone: Bool
    
    init(id: UUID, title: String, date: Date?, isDone: Bool) {
        self.id = id
        self.title = title
        self.date = date
        self.isDone = isDone
    }
    
    func asReactive() -> TodoItemReactive {
        
        return TodoItemReactive(id: self.id, title: self.title, isDone: self.isDone, date: self.date)
        
    }
    
}

class TodoItemReactive: ObservableObject {
    
    let id: UUID
    let title: String
    let date: Date?
    @Published var isDone: Bool
    
    init(id: UUID, title: String, isDone: Bool, date: Date?) {
        self.id = id
        self.title = title
        self.isDone = isDone
        self.date = date
    }
}

@objc(TodoItemManagedObject)
class TodoItemManagedObject: NSManagedObject, Identifiable {
    
    @NSManaged var id: UUID?
    @NSManaged var title: String
    @NSManaged var date: Date?
    @NSManaged var isDone: Bool
    
}

extension TodoItemManagedObject {
    
    func asTodoItem() -> TodoItem {
        
        return TodoItem(id: self.id ?? UUID(), title: self.title, date: self.date, isDone: self.isDone)
        
    }
    
    func asReactiveTodoItem() -> TodoItemReactive {
        TodoItemReactive(id: self.id ?? UUID(),
                         title: self.title,
                         isDone: self.isDone,
                         date: self.date)
    }
    
}
