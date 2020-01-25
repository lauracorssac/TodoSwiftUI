//
//  NewToDoView.swift
//  TodoSwiftUI
//
//  Created by Laura Corssac on 1/16/20.
//  Copyright © 2020 Laura Corssac. All rights reserved.
//

import SwiftUI

struct NewToDoView: View {
    
    @Binding var showModal: Bool

    @ObservedObject var viewModel: NewToDoViewModel
    
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
                    
                    Button(action: {
                        self.showModal = false
                    }, label: {
                        Text("Done")
                    }).disabled(!viewModel.shouldEnableDone)
            )
        }
    }
}

struct NewToDoView_Previews: PreviewProvider {
    static var previews: some View {
        NewToDoView(showModal: .constant(true), viewModel: NewToDoViewModel())
    }
}
