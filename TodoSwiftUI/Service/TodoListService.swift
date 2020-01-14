//
//  TodoListService.swift
//  TodoSwiftUI
//
//  Created by Laura Corssac on 1/12/20.
//  Copyright © 2020 Laura Corssac. All rights reserved.
//

import Foundation
import Combine

class TodoListService {
    
    func getTodoItems() -> AnyPublisher<[TodoItem], URLError> {
        
        let urlString = "http://www.mocky.io/v2/5e1bb4e63100008d324f33ca"
        
        guard let url = URL(string: urlString) else {
            return Fail<[TodoItem], URLError>(error: URLError(URLError.unsupportedURL))
                .eraseToAnyPublisher()
        }
        
        let response = URLSession
            .shared
            .dataTaskPublisher(for: url)
            .tryMap { data, response in
                try JSONDecoder().decode([TodoItem].self, from: data)
            }.mapError { _ in
                return URLError(URLError.badServerResponse)
            }.eraseToAnyPublisher()
        
        return response
    }
}
