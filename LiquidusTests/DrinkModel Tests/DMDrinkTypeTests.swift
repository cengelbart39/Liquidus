//
//  DMDrinkTypeTests.swift
//  LiquidusTests
//
//  Created by Christopher Engelbart on 4/28/22.
//

import XCTest
import CoreData
import SwiftUI
@testable import Liquidus

class DMDrinkTypeTests: XCTestCase {

    var context: NSManagedObjectContext!
    
    var model: DrinkModel!
    
    var water: DrinkType!
    var coffee: DrinkType!
    var soda: DrinkType!
    var juice: DrinkType!
    var custom: DrinkType!

    override func setUp() {
        self.context = PersistenceController.inMemory.container.viewContext
        
        self.model = DrinkModel(test: true, suiteName: nil)
        
        self.water = SampleDrinkTypes.water(context)
        self.coffee = SampleDrinkTypes.coffee(context)
        self.soda = SampleDrinkTypes.soda(context)
        self.juice = SampleDrinkTypes.juice(context)
        self.custom = SampleDrinkTypes.appleCider(context)
    }
    
    override func tearDown() {
        self.context = nil
        self.model = nil
        self.water = nil
        self.coffee = nil
        self.soda = nil
        self.juice = nil
        self.custom = nil
    }
    
    func testGetDrinkTypeColor() {
        // Assert that the default Water type returns .systemTeal
        XCTAssertEqual(UIColor.color(data: water.color!), .systemTeal)
        
        // Assert that the default Coffee type returns .systemBrown
        XCTAssertEqual(UIColor.color(data: coffee.color!), .systemBrown)

        // Assert that the default Soda type returns .systemGreen
        XCTAssertEqual(UIColor.color(data: soda.color!), .systemGreen)

        // Assert that the default Juice type returns .systemOrange
        XCTAssertEqual(UIColor.color(data: juice.color!), .systemOrange)

        // Assert that the Apple Cider custom type returns the stored color
        XCTAssertEqual(UIColor.color(data: custom.color!), UIColor(red: 207/255, green: 58/255, blue: 31/255, alpha: 1))
    }
    
    func testGetTotalAmount() {
        let month = Month(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
        
        let types = SampleDrinks.month(month, context: context)
        
        var allDrinks = [Drink]()
        
        for type in types {
            if let drinks = type.drinks?.allObjects as? [Drink] {
                allDrinks += drinks
            }
        }
        
        let results = model.getTotalAmount(drinks: allDrinks)
        
        XCTAssertEqual(results, 12750)
    }
    
    func testGetTotalAverageNil() {
        let month = Month(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
        
        let currentDate = Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 1))!
        
        let types = SampleDrinks.month(month, context: context)
        
        var allDrinks = [Drink]()
        
        for type in types {
            if let drinks = type.drinks?.allObjects as? [Drink] {
                allDrinks += drinks
            }
        }
        
        let results = model.getTotalAverage(drinks: allDrinks, startDate: currentDate)
        
        XCTAssertNil(results)
    }
    
    func testGetTotalAverageNonNil() {
        // Create dates for the first of Jan, Feb, Mar, Apr 2022
        let apr = Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 1))!
        let mar = Calendar.current.date(from: DateComponents(year: 2022, month: 3, day: 1))!
        let feb = Calendar.current.date(from: DateComponents(year: 2022, month: 2, day: 1))!
        let jan = Calendar.current.date(from: DateComponents(year: 2022, month: 1, day: 1))!
        
        let monthTypes = [
            SampleDrinks.month(Month(date: apr), context: context),
            SampleDrinks.month(Month(date: mar), context: context),
            SampleDrinks.month(Month(date: feb), context: context),
            SampleDrinks.month(Month(date: jan), context: context)
        ]

        var allDrinks = [Drink]()
        
        for allTypes in monthTypes {
            for type in allTypes {
                if let drinks = type.drinks?.allObjects as? [Drink] {
                    allDrinks += drinks
                }
            }
        }
        
        let results = model.getTotalAverage(drinks: allDrinks, startDate: .now)
        
        XCTAssertNotNil(results)
        XCTAssertEqual(results!, 552)
    }
    
    func testProcessDrinkTypeName() {
        let name1 = "milk"
        XCTAssertEqual(model.processDrinkTypeName(name: name1), "Milk")
        
        let name2 = "apple cider"
        XCTAssertEqual(model.processDrinkTypeName(name: name2), "Apple Cider")
        
        let name3 = "aPpLe CiDer"
        XCTAssertEqual(model.processDrinkTypeName(name: name3), "Apple Cider")
    }
}
