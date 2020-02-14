//
//  TodoDetailsView.swift
//  TodoSwiftUI
//
//  Created by Laura Corssac on 2/10/20.
//  Copyright © 2020 Laura Corssac. All rights reserved.
//

import SwiftUI
import Combine

struct TodoDetailsView: View {
    
    @State var deletionSheetPresented = false
    @Binding var showSelf: Bool
    @State var editSheetPresented = false
    
    let viewModel: TodoDetailsViewModel
    
    private var cancellables = [AnyCancellable]()
    
    init(showSelf: Binding<Bool>, viewModel: TodoDetailsViewModel) {
        self.viewModel = viewModel
        self._showSelf = showSelf
        
        viewModel.$deletionSucceeded
            .dropFirst()
            .map { !$0 }
            .assign(to: \.showSelf, on: self)
            .store(in: &cancellables)
        
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8.0)
        {
            Text(viewModel.title)
                .font(.system(size: 24, weight: .bold, design: .default))
                .lineLimit(0)
                .padding(.leading)
            
            Text(viewModel.dateString)
                .font(.system(size: 18, weight: .regular, design: .default))
                .lineLimit(0)
                .padding(.leading)
            
            Spacer()
            Button(action: {
                self.deletionSheetPresented = true
            } ) {
                
                HStack {
                    Spacer()
                    
                    Text("Delete")
                        .bold()
                        .font(.system(size: 20, weight: .regular, design: .default))
                    Spacer()
                }
                    
                .frame(height: 44)
                .foregroundColor(Color.red)
                
            }
            .actionSheet(isPresented: $deletionSheetPresented, content: {
                
                ActionSheet(title: Text("Are you sure you want to delete this Todo?"),
                            buttons: [
                                ActionSheet.Button.destructive(Text("Delete Todo Item"), action: {
                                    self.viewModel.deleteButtonPressed.send(())
                                }),
                                ActionSheet.Button.cancel(Text("Cancel"), action: { })
                ])})
        }
        .navigationBarTitle(Text("Event details"))
        .navigationBarItems(trailing:
            Button(action: {
                self.editSheetPresented = true
            }, label: {
                Text("Edit")
                    .foregroundColor(.blue)
            }))
        .sheet(isPresented: $editSheetPresented) {
            NewToDoView(showModal: self.$editSheetPresented,
                        viewModel: .init(service: CoreDataManager(),
                                         todoItem: self.viewModel.todoItem))
        }
        
    }
}

struct TodoDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        TodoDetailsView(showSelf: .constant(true),
                        viewModel: .init(todoItem: TodoItemReactive(id: UUID(),
                                                            title: "ola",
                                                            isDone: false,
                                                            date: Date()),
                                         service: CoreDataManager()))
    }
}
