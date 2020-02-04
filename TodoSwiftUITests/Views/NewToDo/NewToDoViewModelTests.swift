//
//  NewToDoViewModelTests.swift
//  TodoSwiftUITests
//
//  Created by Laura Corssac on 1/26/20.
//  Copyright © 2020 Laura Corssac. All rights reserved.
//

import Foundation
import XCTest
import Combine
import SwiftUI
@testable import TodoSwiftUI

class NewToDoViewModelTests: XCTestCase {
    
    var subscriptions = [AnyCancellable]()
    
    override func setUp() {
        self.subscriptions = []
    }
    
    override func tearDown() {
        
    }
    
    func test_DoneButton() {
        
        let viewModel: NewToDoViewModel = NewToDoViewModel(service: TodoListServiceSuccessMock())
        
        XCTAssertFalse(viewModel.shouldEnableDone)
        
        viewModel.titleTyped = "content"
        
        XCTAssertTrue(viewModel.shouldEnableDone)
        
        viewModel.titleTyped = ""
        
        XCTAssertFalse(viewModel.shouldEnableDone)
        
        viewModel.titleTyped = "text"
        
        XCTAssertTrue(viewModel.shouldEnableDone)
        
    }
    
    func test_presentAlertFailure() {
        
        let viewModelFailure = NewToDoViewModel(service: TodoListServiceFailureMock())
        let expectation = self.expectation(description: #function)
       
        var booleanReceived = false
        
        XCTAssertFalse(viewModelFailure.shouldPresentAlert)
        XCTAssertFalse(viewModelFailure.shouldFinish)
        
        viewModelFailure.doneButtonPressed.send(())
        
        viewModelFailure
            .$shouldPresentAlert
            .dropFirst()
            .sink {
                booleanReceived = $0
                expectation.fulfill() }
            .store(in: &subscriptions)
        
        waitForExpectations(timeout: 1, handler: nil)
        
        XCTAssertTrue(booleanReceived)
        
    }
    
    func test_shouldFinish() {
        
        let viewModel = NewToDoViewModel(service: TodoListServiceSuccessMock())
        let expectation = self.expectation(description: #function)
       
        var valueReceived = false
        
        XCTAssertFalse(viewModel.shouldFinish)
        
        viewModel.doneButtonPressed.send(())
        
        viewModel
            .$shouldFinish
            .dropFirst()
            .sink {
                valueReceived = $0
                expectation.fulfill() }
            .store(in: &subscriptions)
        
        waitForExpectations(timeout: 1, handler: nil)
        
        XCTAssertTrue(valueReceived)
        
    }
    
}
