//
//  TodoListViewModel.swift
//  TodoSwiftUI
//
//  Created by Laura Corssac on 1/12/20.
//  Copyright © 2020 Laura Corssac. All rights reserved.
//

import Foundation
import Combine

enum ViewState {
    case loading, error, content([TodoItem])
}

class TodoListViewModel: ObservableObject {
    
    //@Published var todoItems: [TodoItem] = []
    @Published var viewState: ViewState = .loading
    
    private let viewStateSubject = PassthroughSubject<ViewState, Never>()
    private let todoItemsSubject = PassthroughSubject<[TodoItem], URLError>()
    private let errorSubject = PassthroughSubject<URLError, Never>()
    private var cancellables = [AnyCancellable]()
    
    init(service: TodoListService = TodoListService()) {
        
//        service.getTodoItems()
//            .share()
//            .subscribe(todoItemsSubject)
//            .store(in: &cancellables)
        
//        todoItemsSubject
//            .catch { error -> Empty<[TodoItem], Never> in
//                self.errorSubject.send(error)
//                return Empty(completeImmediately: false) }
//            .assign(to: \.todoItems, on: self)
//            .store(in: &cancellables)
        
        viewStateSubject
            .assign(to: \.viewState, on: self)
            .store(in: &cancellables)
        
        service.getTodoItems()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [viewStateSubject] completion in
            
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    viewStateSubject.send(.error)
                }
                
            }) { [viewStateSubject] items in
                viewStateSubject.send(.content(items))
            }.store(in: &cancellables)
        
       
        
    }
}
