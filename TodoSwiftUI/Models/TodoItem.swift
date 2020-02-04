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
    
    let id: Int
    let title: String
    let date: String
    let isDone: Bool
    
    init(id: Int, title: String, date: String, isDone: Bool) {
        self.id = id
        self.title = title
        self.date = date
        self.isDone = isDone
    }
}

class TodoItemReactive: ObservableObject {
    
    let id: Int
    let title: String
    let date: String
    @Published var isDone: Bool
    
    init(id: Int, title: String, isDone: Bool, date: String) {
        self.id = id
        self.title = title
        self.isDone = isDone
        self.date = date
    }
}

@objc(TodoItemManagedObject)
class TodoItemManagedObject: NSManagedObject, Identifiable {
    
    @NSManaged var id: Int64
    @NSManaged var title: String
    @NSManaged var date: Date
    @NSManaged var isDone: Bool
    
}

class ManagedObjectToReactiveConverter {
    func convertToReactive(todoItem: TodoItemManagedObject) -> TodoItemReactive {
       
        TodoItemReactive(id: todoItem.id.hashValue,
                            title: todoItem.title,
                            isDone: todoItem.isDone,
                            date: "")
       }
}

class TodoItemConverter {
    func convertToReactive(todoItem: TodoItem) -> TodoItemReactive {
        TodoItemReactive(id: todoItem.id,
                         title: todoItem.title,
                         isDone: todoItem.isDone,
                         date: todoItem.date)
    }
}
