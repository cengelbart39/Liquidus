//
//  DrinkTests.swift
//  LiquidusTests
//
//  Created by Christopher Engelbart on 4/16/22.
//

import XCTest
@testable import Liquidus

class DrinkTests: XCTestCase {
    
    var drink: Drink!
    
    // Create a dummy water type
    var waterType = DrinkType(name: Constants.waterKey, color: CodableColor(color: .systemTeal), isDefault: true, enabled: true, colorChanged: false)
    
    override func setUp() {
        self.drink = Drink(type: waterType, amount: 500, date: .now)
    }
    
    override func tearDown() {
        self.drink = nil
    }
    
    func testConstructor() {
        // Assert the type of the drink is the water type
        XCTAssertEqual(drink.type, waterType)
        
        // Assert the amount of the drink is 500
        XCTAssertEqual(drink.amount, 500)
        
        // Assert the date of the drink is the same as now
        XCTAssertEqual(Calendar.current.compare(drink.date, to: .now, toGranularity: .nanosecond), .orderedSame)
    }
    
    func testEqutable() {
        // Create a test drink
        let testDrink = Drink(type: waterType, amount: 200, date: .now)
        
        // Assert the test drink is not equal to above drink
        XCTAssertNotEqual(drink, testDrink)
        
        // Assert the above drink is equal to itself
        XCTAssertEqual(drink, drink)
    }
}
