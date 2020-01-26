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
    
    @ObservedObject private var todoItem: TodoItemReactive
    
    init(todoItem: TodoItemReactive) {
        self.todoItem = todoItem
    }
    
    var body: some View {
        HStack {
            Button(action: toggle){
                Image(systemName: todoItem.isDone ? "checkmark.square" : "square")
                    .imageScale(.large)
            }
            Text(todoItem.title)
        }
    }
    func toggle() {
        todoItem.isDone.toggle()
    }
}

struct TodoItemRow_Previews: PreviewProvider {
    static var previews: some View {
        TodoItemRow(todoItem: TodoItemReactive(id: 0,
                                               title: "todo item test",
                                               isDone: true,
                                               date: "25 de janeiro de 2020"))
    }
}
