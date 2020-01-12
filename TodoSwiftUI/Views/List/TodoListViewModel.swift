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
    @Published var tryAgainButtonPressed: Void = ()
    
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
        
        $tryAgainButtonPressed
            .handleEvents(receiveOutput: { [viewStateSubject] _ in viewStateSubject.send(.loading) })
            .flatMap { [viewStateSubject] _ in
                service.getTodoItems()
                .receive(on: RunLoop.main)
                .catch { _ -> Empty<[TodoItem], Never> in
                    viewStateSubject.send(.error)
                    return .init(completeImmediately: false) }
            }
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [viewStateSubject] items in
                viewStateSubject.send(.content(items))
            })
            .store(in: &cancellables)
        
    }
}
