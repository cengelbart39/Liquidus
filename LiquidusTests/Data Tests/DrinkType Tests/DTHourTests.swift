//
//  DTHourTests.swift
//  LiquidusTests
//
//  Created by Christopher Engelbart on 6/13/22.
//

import XCTest
import CoreData
@testable import Liquidus

class DTHourTests: XCTestCase {

    var context: NSManagedObjectContext!
    
    override func setUp() {
        self.context = PersistenceController.inMemory.container.viewContext
    }
    
    override func tearDown() {
        self.context = nil
    }

    func testfilterDataByHour() {
        let types = SampleDrinks.day(Day(), context: context)
        
        let components = Calendar.current.dateComponents([.year, .month, .day], from: .now)
        
        let hour = Hour(date: Calendar.current.date(from: DateComponents(year: components.year, month: components.month, day: components.day, hour: 12))!)
        
        let expectedDrink = Drink(context: context)
        expectedDrink.id = UUID()
        expectedDrink.amount = 600
        expectedDrink.date = hour.data
        expectedDrink.type = SampleDrinkTypes.juice(context)
        
        expectedDrink.type.addToDrinks(expectedDrink)
        
        XCTAssertEqual(types[0].filterDataByHour(hour: hour), [])
        
        XCTAssertEqual(types[1].filterDataByHour(hour: hour), [])
        
        XCTAssertEqual(types[2].filterDataByHour(hour: hour), [])
        
        XCTAssertTrue(types[3].filterDataByHour(hour: hour)[0] == expectedDrink)
    }
    
    func testGetTypeAmountByHour() {
        let types = SampleDrinks.day(Day(), context: context)
        
        let components = Calendar.current.dateComponents([.year, .month, .day], from: .now)
        
        let hour = Hour(date: Calendar.current.date(from: DateComponents(year: components.year, month: components.month, day: components.day, hour: 12))!)
        
        XCTAssertEqual(types[0].getTypeAmountByHour(hour: hour), 0)
        
        XCTAssertEqual(types[1].getTypeAmountByHour(hour: hour), 0)
        
        XCTAssertEqual(types[2].getTypeAmountByHour(hour: hour), 0)
        
        XCTAssertEqual(types[3].getTypeAmountByHour(hour: hour), 600)
    }
}
