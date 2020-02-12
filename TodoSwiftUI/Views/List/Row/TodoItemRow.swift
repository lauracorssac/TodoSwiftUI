//
//  TodoItemRow.swift
//  TodoSwiftUI
//
//  Created by Laura Corssac on 1/12/20.
//  Copyright © 2020 Laura Corssac. All rights reserved.
//

import SwiftUI
import Combine

struct TodoItemRow: View {
    
    @ObservedObject private var viewModel: TodoItemRowViewModel
    @State var showDetail = false
    
    init(viewModel: TodoItemRowViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
            
        NavigationLink(destination: TodoDetailsView(showSelf: $showDetail,
                                                    viewModel: .init(todoItem: viewModel.todoItem, service: CoreDataManager())),
                       isActive: $showDetail) {
                        
                        HStack {
                            Button(action: toggle) {
                                Image(systemName: viewModel.isDone ? "checkmark.square" : "square")
                                    .imageScale(.large)
                            }
                            Text(viewModel.todoItem.title)
                        }
        }
            
    }
    func toggle() {
        viewModel.checkButtonPressed.send(())
    }
}

struct TodoItemRow_Previews: PreviewProvider {
    static var previews: some View {
        TodoItemRow(viewModel: .init(todoItem: TodoItem(id: UUID(), title: "todo item 0", date: Date(), isDone: false),
                                     service: CoreDataManager()))
    }
}
