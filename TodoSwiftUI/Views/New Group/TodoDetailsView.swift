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
        
        VStack
            {
                Spacer()
                Button(action: {
                    self.deletionSheetPresented = true
                } ) {
                    
                    HStack {
                        Spacer()
                        Text("Delete")
                            .bold()
                        Spacer()
                    }
                        
                    .frame(height: 44)
                    .foregroundColor(Color.red)
                    .background(Color.gray)
                    
                    }.actionSheet(isPresented: $deletionSheetPresented, content: {
                        
                        ActionSheet(title: Text("Are you sure you want to delete this Todo?"),
                                    buttons: [
                                        ActionSheet.Button.destructive(Text("Delete Todo Item"), action: {
                                            self.viewModel.deleteButtonPressed.send(())
                                        }),
                                         ActionSheet.Button.cancel(Text("Cancel"), action: {
                                            print("")
                                        })])})
        }
        .shadow(color: Color.gray, radius: 2.0, x: 0.0, y: 2.0)
        .navigationBarTitle(Text("Items"))
    }
}

struct TodoDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        TodoDetailsView(showSelf: .constant(true),
                        viewModel: .init(todoItem: TodoItem(id: UUID(), title: "", date: nil, isDone: false),
                                         service: CoreDataManager()))
    }
}
