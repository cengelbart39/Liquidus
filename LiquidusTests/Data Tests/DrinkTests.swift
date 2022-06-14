//
//  DrinkTests.swift
//  LiquidusTests
//
//  Created by Christopher Engelbart on 4/16/22.
//

import XCTest
import CoreData
@testable import Liquidus

class DrinkTests: XCTestCase {
    
    var context: NSManagedObjectContext!
    
    var drink: Drink!
    
    var water: DrinkType!
    
    override func setUp() {
        self.context = PersistenceController.inMemory.container.viewContext
        
        self.water = DrinkType(context: context)
        water.id = UUID()
        water.name = "Water"
        water.order = 0
        water.enabled = true
        water.isDefault = true
        water.colorChanged = false
        water.color = UIColor.systemTeal.encode()
        water.drinks = nil
        
        self.drink = Drink(context: context)
        self.drink.id = UUID()
        self.drink.amount = 500
        self.drink.date = Date.now
        self.drink.type = self.water
        
        self.water.addToDrinks(self.drink)
    }
    
    override func tearDown() {
        self.context = nil
        self.drink = nil
        self.water = nil
    }
    
    func testConstructor() {
        XCTAssertEqual(drink.amount, 500.0)
        XCTAssertTrue(Calendar.current.isDateInToday(drink.date))
        XCTAssertEqual(water, drink.type)
    }
    
    func testEqutable() {
        // Create a test drink
        let testDrink = Drink(context: context)
        testDrink.id = UUID()
        testDrink.amount = 200.0
        testDrink.date = Calendar.current.date(byAdding: .day, value: -1, to: Date.now)!
        testDrink.type = self.water
        
        // Assert the test drink is not equal to above drink
        XCTAssertNotEqual(drink, testDrink)
        
        // Assert the above drink is equal to itself
        XCTAssertEqual(drink, drink)
    }
}
