//
//  DTTypeMeasurementTests.swift
//  LiquidusTests
//
//  Created by Christopher Engelbart on 6/13/22.
//

import XCTest
import CoreData
@testable import Liquidus

class DTTypeMeasurementTests: XCTestCase {
    
    var context: NSManagedObjectContext!
    
    override func setUp() {
        self.context = PersistenceController.inMemory.container.viewContext
    }
    
    override func tearDown() {
        self.context = nil
    }
    
    func testGetTypeAmount() {
        let types = SampleDrinks.week(Week(), context: context)
        
        XCTAssertEqual(types[0].getTypeAmount(), 400)
        
        XCTAssertEqual(types[1].getTypeAmount(), 400)
        
        XCTAssertEqual(types[2].getTypeAmount(), 400)
        
        XCTAssertEqual(types[3].getTypeAmount(), 400)
    }

    func testGetTypePercent() {
        let types = SampleDrinks.week(Week(), context: context)
        
        XCTAssertEqual(types[0].getTypePercent(goal: 2000), 0.2)
        
        XCTAssertEqual(types[1].getTypePercent(goal: 2000), 0.2)

        XCTAssertEqual(types[2].getTypePercent(goal: 2000), 0.2)

        XCTAssertEqual(types[3].getTypePercent(goal: 2000), 0.2)
    }
    
    func testGetTypeAverageNil() {
        // Add the sample drinks
        let types = SampleDrinks.month(Month(), context: context)
        
        // Get a date for April 1, 2022
        let currentDate = Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 1))!
        
        XCTAssertNil(types[0].getTypeAverage(startDate: currentDate))
        
        XCTAssertNil(types[1].getTypeAverage(startDate: currentDate))

        XCTAssertNil(types[2].getTypeAverage(startDate: currentDate))

        XCTAssertNil(types[3].getTypeAverage(startDate: currentDate))
    }
    
    func testGetTypeAverageNonNil() {
        // Create dates for the first of Jan, Feb, Mar, Apr 2022
        let apr = Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 1))!
        let mar = Calendar.current.date(from: DateComponents(year: 2022, month: 3, day: 1))!
        let feb = Calendar.current.date(from: DateComponents(year: 2022, month: 2, day: 1))!
        let jan = Calendar.current.date(from: DateComponents(year: 2022, month: 1, day: 1))!
        
        // Get the dates for the whole months
        let april = Month(date: apr)
        let march = Month(date: mar)
        let february = Month(date: feb)
        let january = Month(date: jan)
        
        let types = self.getAverageDrinks(months: [january, february, march, april])
        
        let result1 = types[0].getTypeAverage(startDate: .now)
        XCTAssertNotNil(result1)
        XCTAssertEqual(result1!, 137)
        
        let result2 = types[1].getTypeAverage(startDate: .now)
        XCTAssertNotNil(result2)
        XCTAssertEqual(result2!, 138)
        
        let result3 = types[2].getTypeAverage(startDate: .now)
        XCTAssertNotNil(result3)
        XCTAssertEqual(result3!, 139)
        
        let result4 = types[3].getTypeAverage(startDate: .now)
        XCTAssertNotNil(result4)
        XCTAssertEqual(result4!, 137)
    }
    
    /**
     Generate Sample Drinks for multiple months
     - Parameter months: The months to generate drinks for
     - Returns: `DrinkType`s with the associated `Drink`s
     */
    private func getAverageDrinks(months: [Month]) -> [DrinkType] {
        // Get default drink types
        let types = SampleDrinkTypes.defaultTypes(context)
        
        // Create typeIndex
        var typeIndex = 0
        
        // Loop through month array
        for month in months {
            for index in 0..<month.data.count {
                
                // Append drink based on index
                let drink = Drink(context: context)
                drink.id = UUID()
                drink.type = types[typeIndex % 4]
                drink.amount = SampleDrinkAmounts.month[index]
                drink.date = month.data[index]
                
                types[typeIndex % 4].addToDrinks(drink)
                
                // Increment typeIndex
                typeIndex += 1
            }
        }
        
        return types
    }
}
