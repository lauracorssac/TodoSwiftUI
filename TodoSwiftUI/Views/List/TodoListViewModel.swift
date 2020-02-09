//
//  TodoListViewModel.swift
//  TodoSwiftUI
//
//  Created by Laura Corssac on 1/12/20.
//  Copyright © 2020 Laura Corssac. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

enum ViewState {
    case loading, error, content([TodoItem])
}

class TodoListViewModel: ObservableObject {
    
    @Published private(set) var viewState: ViewState = .loading
    @Published var shoudRequest: Void = ()
    
    private let viewStateSubject = PassthroughSubject<ViewState, Never>()
    private var cancellables = [AnyCancellable]()
    
    init(service: ToDoServices) {
        
        viewStateSubject
            .assign(to: \.viewState, on: self)
            .store(in: &cancellables)

        $shoudRequest
            .handleEvents(receiveOutput: { [viewStateSubject] _ in viewStateSubject.send(.loading) })
            .flatMap { [viewStateSubject] _ in
                service.getTodoItems()
                .catch { _ -> Empty<[TodoItem], Never> in
                    viewStateSubject.send(.error)
                    return .init(completeImmediately: false) }
            }
            .sink(receiveValue: { [viewStateSubject] items in
                viewStateSubject.send(.content(items))
            })
            .store(in: &cancellables)
        
        service
            .didChangeContent
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] _ in
                self?.shoudRequest = ()
            })
            .store(in: &cancellables)
        
    }
}
