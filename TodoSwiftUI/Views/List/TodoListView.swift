//
//  TodoListView.swift
//  TodoSwiftUI
//
//  Created by Laura Corssac on 1/12/20.
//  Copyright © 2020 Laura Corssac. All rights reserved.
//

import SwiftUI
import Combine
import CoreData

struct TodoListView: View {
    
    @State private var showModal = false
    @ObservedObject var viewModel: TodoListViewModel

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
                    NewToDoView(showModal: self.$showModal, viewModel: NewToDoViewModel(service: CoreDataManager()))
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
                         self.viewModel.shoudRequest = ()
                     }) {
                         Text("try again")
                     }
                 }
             )
         case .content(let todoItems):
             return AnyView(
                 List(todoItems) { item in
                    TodoItemRow(todoItem: item.asReactive())
                 }.buttonStyle(PlainButtonStyle())
             )
         case .loading:
             return AnyView(Text("loading"))
         }
     }
    
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView(viewModel: .init(service: CoreDataManager()))
    }
}
