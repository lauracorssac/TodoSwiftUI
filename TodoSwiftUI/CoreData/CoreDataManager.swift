//
//  CoreDataManager.swift
//  TodoSwiftUI
//
//  Created by Laura Corssac on 2/2/20.
//  Copyright © 2020 Laura Corssac. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static func allIdeasFetchRequest() -> NSFetchRequest<TodoItemManagedObject> {
        
        let request = NSFetchRequest<TodoItemManagedObject>(entityName: "TodoItemManagedObject")
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
          
        return request
    }
    
}
