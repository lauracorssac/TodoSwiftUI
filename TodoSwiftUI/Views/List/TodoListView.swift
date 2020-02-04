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
    private let converter = ManagedObjectToReactiveConverter()
    @FetchRequest(entity: TodoItemManagedObject.entity(), sortDescriptors: []) var todoItems: FetchedResults<TodoItemManagedObject>

    var body: some View {

        NavigationView {
            
            List(todoItems) { item in
                Text(item.title) }
                .buttonStyle(PlainButtonStyle())
                .navigationBarTitle("To Do Lista")
                .navigationBarItems(trailing: Button(action: {
                    self.showModal = true
                }, label: {
                    Image(systemName: "plus")
                        .imageScale(.large)
                }))
                .sheet(isPresented: $showModal) {
                    NewToDoView(showModal: self.$showModal, viewModel: NewToDoViewModel(service: TodoListService())) }
        }
        
    }
    
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView(viewModel: .init())
    }
}
