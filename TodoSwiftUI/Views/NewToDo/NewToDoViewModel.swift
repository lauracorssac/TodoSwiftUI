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
    
    @Published var titleTyped: String = ""
    @Published var dateChoosed: Date = Date()
    @Published var dateFormatted: String = ""
    
    @Published var shouldEnableDone: Bool = false
    @Published var shouldPresentAlert: Bool = false
    
    var subscriptions = [AnyCancellable]()
    let doneButtonPressed = PassthroughSubject<Void, Never>()
    let saveSucceeded = PassthroughSubject<Bool, Never>()
    
    init(service: ToDoServices) {
        
        $titleTyped
            .map { !$0.isEmpty }
            .assign(to: \.shouldEnableDone, on: self)
            .store(in: &subscriptions)
        
        $dateChoosed
            .map { date in
                let formatter = DateFormatter()
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
                
                return service
                    .save(todoItem: item)
                    .catch(self.handleError(error:))
                    .eraseToAnyPublisher()
                
            }).sink(receiveValue: { [weak self] _ in
                self?.saveSucceeded.send(true)
            }).store(in: &subscriptions)
            
        
    }
    
    func getItem() -> TodoItem {
        return TodoItem(id: 0, title: self.titleTyped, date: self.dateFormatted, isDone: false)
    }
    
    func handleError(error: URLError) -> Empty<Void, Never> {
        
        self.shouldPresentAlert = true
        return Empty<Void, Never>()
    }
    
}
