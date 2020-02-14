//
//  NewToDoView.swift
//  TodoSwiftUI
//
//  Created by Laura Corssac on 1/16/20.
//  Copyright © 2020 Laura Corssac. All rights reserved.
//

import SwiftUI
import Combine

struct NewToDoView: View {
    
    @Binding var showModal: Bool
    @ObservedObject var viewModel: NewToDoViewModel
    var subscriptions = [AnyCancellable]()

    init(showModal: Binding<Bool>, viewModel: NewToDoViewModel) {
        
        self._showModal = showModal
        self.viewModel = viewModel
        
        self.viewModel.$shouldFinish
            .dropFirst()
            .map { !$0 }
            .assign(to: \.showModal, on: self)
            .store(in: &subscriptions)
        
    }
    
    var body: some View {
        NavigationView {
            Form {
               
                TextField("Todo title", text: $viewModel.titleTyped)
                
                DatePicker(selection: $viewModel.dateChoosed, in: Date()..., displayedComponents: .date) {
                    Text("Select a date")
                }
            }
            .navigationBarTitle("New Todo")
            .navigationBarItems(
               
                leading:
                
                Button(action: {
                    self.showModal = false
                }, label: {
                    Text("Cancel")
                }),
                
                trailing:
                
                Button(action: (self.viewModel.doneButtonPressed.send),
                       label: { Text("Done") })
                    .disabled(!viewModel.shouldEnableDone)
                
            ).alert(isPresented: $viewModel.shouldPresentAlert) { () -> Alert in
                Alert(title: Text("Uuups :("), message: Text("Não foi possível registrar seu Todo"), dismissButton: nil)
            }
            
        }
    }
}

struct NewToDoView_Previews: PreviewProvider {
    static var previews: some View {
        NewToDoView(showModal: .constant(true), viewModel: NewToDoViewModel(service: TodoListService()))
    }
}
