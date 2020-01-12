//
//  TodoItem.swift
//  TodoSwiftUI
//
//  Created by Laura Corssac on 1/12/20.
//  Copyright © 2020 Laura Corssac. All rights reserved.
//

import Foundation

struct TodoItem: Codable, Identifiable {
    
    let id: Int
    let title: String
    //let date: Date
    //let isDone: Bool
}
