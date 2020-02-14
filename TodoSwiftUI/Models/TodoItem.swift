//
//  TodoItem.swift
//  TodoSwiftUI
//
//  Created by Laura Corssac on 1/12/20.
//  Copyright © 2020 Laura Corssac. All rights reserved.
//

import Foundation

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
    
    func asManagedObject() -> TodoItemManagedObject {
        let object = TodoItemManagedObject(context: CoreDataStack.shared.persistentContainer.viewContext)
        object.title = self.title
        object.date = self.date
        object.isDone = self.isDone
        object.id = self.id
        return object
    }
    
}
