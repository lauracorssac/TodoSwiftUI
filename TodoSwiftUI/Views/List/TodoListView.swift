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
    
    var body: some View {
       
        contentView()
       
    }
    
    func contentView() -> AnyView {
        switch viewModel.viewState {
        case .error:
            return AnyView(Text("errro :("))
        case .content(let todoItems):
            return AnyView(List(todoItems) { item in
                Text(item.title)
            })
        case .loading:
            return AnyView(Text("loading"))
        }
    }
    
}


struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView(viewModel: .init())
    }
}