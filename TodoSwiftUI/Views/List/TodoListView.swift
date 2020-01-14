//
//  TodoListView.swift
//  TodoSwiftUI
//
//  Created by Laura Corssac on 1/12/20.
//  Copyright © 2020 Laura Corssac. All rights reserved.
//

import SwiftUI
import Combine

struct TodoListView: View {
    
    @ObservedObject var viewModel: TodoListViewModel
    private let converter = TodoItemConverter()
    
    var body: some View {
       
        contentView()
       
    }
    
    func contentView() -> AnyView {
        switch viewModel.viewState {
        case .error:
            return AnyView(
                VStack {
                    Text("errro :(")
                    Button(action: {
                        self.viewModel.tryAgainButtonPressed = ()
                    }) {
                        Text("try again")
                    }
                }
            )
        case .content(let todoItems):
            return AnyView(
                List(todoItems) { item in
                    TodoItemRow(todoItem: self.converter.convertToReactive(todoItem: item))
                }.buttonStyle(PlainButtonStyle())
            )
        case .loading:
            return AnyView(Text("loading"))
        }
    }
    
    private func tryAgain() {
        
    }
    
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView(viewModel: .init())
    }
}
