//
//  TodoManagedObject.swift
//  TodoSwiftUI
//
//  Created by Laura Corssac on 2/14/20.
//  Copyright © 2020 Laura Corssac. All rights reserved.
//

import Foundation
import CoreData

@objc(TodoItemManagedObject)
class TodoItemManagedObject: NSManagedObject, Identifiable {
    
    @NSManaged var id: UUID?
    @NSManaged var title: String
    @NSManaged var date: Date?
    @NSManaged var isDone: Bool
    
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

