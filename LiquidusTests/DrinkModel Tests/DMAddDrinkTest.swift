//
//  DMAddDrinkTest.swift
//  LiquidusTests
//
//  Created by Christopher Engelbart on 5/16/22.
//

import XCTest
import Combine
@testable import Liquidus

class DMAddDrinkTest: XCTestCase {

    var model: DrinkModel!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        self.model = DrinkModel(test: true, suiteName: nil)
        self.cancellables = []
    }
    
    override func tearDown() {
        self.model = nil
        self.cancellables = nil
    }
    
    func testAddDrink() {
        // Set expectation
        let expectation = XCTestExpectation(description: "Add Drink")
        
        // Create a drink
        let drink = Drink(type: model.drinkData.drinkTypes.first!, amount: 500, date: .now)
        
        // Add the drink
        model.addDrink(drink: drink)
        
        // Wait for the drink to be added
        model.$drinkData.dropFirst().sink { data in
            
            // Check that the drinks are equal
            XCTAssertEqual(data.drinks, [drink])
            
            // Fullfill the expectation
            expectation.fulfill()
        }
        .store(in: &cancellables)
        
        // Wait 1 second for the expectation to be fullfilled
        wait(for: [expectation], timeout: 1)
    }

}
