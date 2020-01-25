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
    
    @State private var showModal = false
    @ObservedObject var viewModel: TodoListViewModel
    private let converter = TodoItemConverter()
    
    var body: some View {

        NavigationView {
            contentView()
            .navigationBarTitle("To Do Lista")
            .navigationBarItems(trailing: Button(action: {
                self.showModal = true
            }, label: {
                Image(systemName: "plus")
                    .imageScale(.large)
            }))
                .sheet(isPresented: $showModal) {
                    NewToDoView(showModal: self.$showModal, viewModel: NewToDoViewModel())
            }
        }
        
    }
    
    func contentView() -> some View {
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
