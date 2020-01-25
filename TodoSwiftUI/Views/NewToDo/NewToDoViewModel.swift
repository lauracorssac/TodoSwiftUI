//
//  NewToDoViewModel.swift
//  TodoSwiftUI
//
//  Created by Laura Corssac on 1/16/20.
//  Copyright © 2020 Laura Corssac. All rights reserved.
//

import Foundation
import Combine

class NewToDoViewModel: ObservableObject {
    
    @Published var titleTyped: String = ""
    @Published var dateChoosed: Date = Date()
    @Published var dateFormatted: String = ""
    
    @Published var shouldEnableDone: Bool = false
    
    var subscriptions = [AnyCancellable]()
    
    init() {
        
        $titleTyped
            .map { !$0.isEmpty }
            .assign(to: \.shouldEnableDone, on: self)
            .store(in: &subscriptions)
        
        $dateChoosed
            .map { date in
                let formatter = DateFormatter()
                formatter.dateFormat = "dd MMMM yyyy"
                return formatter.string(from: date) }
            .assign(to: \.dateFormatted, on: self)
            .store(in: &subscriptions)
        
    }
    
}
