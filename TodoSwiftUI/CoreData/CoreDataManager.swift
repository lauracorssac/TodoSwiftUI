//
//  CoreDataManager.swift
//  TodoSwiftUI
//
//  Created by Laura Corssac on 2/2/20.
//  Copyright © 2020 Laura Corssac. All rights reserved.
//

import Foundation
import CoreData
import SwiftUI
import Combine

class CoreDataManager: NSObject, ToDoServices {
    
    let didChangeContent = PassthroughSubject<Void, Never>()
    let fetchRequest: NSFetchRequest<TodoItemManagedObject> = NSFetchRequest(entityName: "\(TodoItemManagedObject.self)")
    
    lazy var controller: NSFetchedResultsController<TodoItemManagedObject> = {
        let controller = NSFetchedResultsController(fetchRequest: self.fetchRequest,
                                   managedObjectContext: CoreDataStack.shared.persistentContainer.viewContext,
                                   sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        return controller
    }()
    
        
    func getTodoItems() -> AnyPublisher<[TodoItem], URLError> {
        
        fetchRequest.sortDescriptors = []
        
        do {
            try controller.performFetch()
        } catch {
            
            return Fail(error: URLError(URLError.unknown))
                               .eraseToAnyPublisher()
            
        }
        
        guard let objects = controller.fetchedObjects else {
            return Fail(error: URLError(URLError.unknown)).eraseToAnyPublisher()
        }
        
        return Just( objects.map { return $0.asTodoItem() })
            .setFailureType(to: URLError.self)
            .eraseToAnyPublisher()
        
    }
    
    func save(todoItem: TodoItem) -> AnyPublisher<Void, URLError> {
        
        guard
            let managedObj = NSEntityDescription.insertNewObject(forEntityName: "\(TodoItemManagedObject.self)", into: CoreDataStack.shared.persistentContainer.viewContext) as? TodoItemManagedObject
            else {
                return Fail(error: URLError(URLError.unknown))
                    .eraseToAnyPublisher() }
        
        managedObj.date = todoItem.date
        managedObj.isDone = todoItem.isDone
        managedObj.title = todoItem.title
        managedObj.id = todoItem.id
        
        
        do {
            try CoreDataStack.shared.saveContext()
        } catch {
            return Fail(error: URLError(URLError.unknown))
                           .eraseToAnyPublisher()
        }
        return Just(())
            .setFailureType(to: URLError.self)
            .eraseToAnyPublisher()
        
    }
    
    func update(item: TodoItem, to checked: Bool) -> AnyPublisher<Void, URLError> {
        
        let request: NSFetchRequest<TodoItemManagedObject> = NSFetchRequest(entityName: "\(TodoItemManagedObject.self)")
        let predicate = NSPredicate(format: "id == %@", item.id.uuidString)
        request.predicate = predicate
        do  {
            let results = try CoreDataStack.shared.persistentContainer.viewContext.fetch(request)
            guard let objectUpdate = results.first else { throw URLError(URLError.unknown) }
            objectUpdate.setValue(checked, forKey: "isDone")
            do {
                try CoreDataStack.shared.saveContext()
            } catch {
                return Fail(error: URLError(URLError.unknown))
                               .eraseToAnyPublisher()
            }
        } catch {
            return Fail(error: URLError(URLError.unknown))
                .eraseToAnyPublisher()
        }
        
        return Just(())
            .setFailureType(to: URLError.self)
            .eraseToAnyPublisher()
        
    }
    
    func delete(item: TodoItem) -> AnyPublisher<Void, URLError> {
        
        let request: NSFetchRequest<TodoItemManagedObject> = NSFetchRequest(entityName: "\(TodoItemManagedObject.self)")
        let predicate = NSPredicate(format: "id == %@", item.id.uuidString)
        request.predicate = predicate
        do  {
            let results = try CoreDataStack.shared.persistentContainer.viewContext.fetch(request)
            guard let object = results.first else { throw URLError(URLError.unknown) }
            CoreDataStack.shared.persistentContainer.viewContext.delete(object)
            do {
                try CoreDataStack.shared.saveContext()
            } catch {
                return Fail(error: URLError(URLError.unknown))
                               .eraseToAnyPublisher()
            }
        } catch {
            return Fail(error: URLError(URLError.unknown))
                .eraseToAnyPublisher()
        }
        
        return Just(())
            .setFailureType(to: URLError.self)
            .eraseToAnyPublisher()
    }
    
}

extension CoreDataManager: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.didChangeContent.send(())
    }
}
