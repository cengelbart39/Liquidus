//
//  DMDataItemsTests.swift
//  LiquidusTests
//
//  Created by Christopher Engelbart on 4/16/22.
//

import XCTest
import CoreData
@testable import Liquidus

class DMDataItemsTests: XCTestCase {
    
    var context: NSManagedObjectContext!
    
    var model: DrinkModel!

    override func setUp() {
        self.context = PersistenceController.inMemory.container.viewContext
        self.model = DrinkModel(test: true, suiteName: nil)
    }
    
    override func tearDown() {
        self.context = nil
        self.model = nil
    }
    
    func testGetAllDataItemsForDay() {
        let testDay = Day(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
        
        let types = SampleDrinks.day(testDay, context: context)
        
        let result = model.getAllDataItems(types: types, dates: testDay)
        
        let expected = SampleDataItems.day(testDay, context: context)
        
        for index in 0..<expected.count {
            XCTAssertEqual(result[index], expected[index], "failed at index \(index)")
        }
    }
    
    func testGetAllDataItemsForWeek() {
        let testWeek = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
        
        let types = SampleDrinks.week(testWeek, context: context)
        
        let result = model.getAllDataItems(types: types, dates: testWeek)
        
        let expected = SampleDataItems.week(testWeek, context: context)
        
        for index in 0..<expected.count {
            XCTAssertEqual(result[index], expected[index], "failed at index \(index)")
        }    }
    
    func testGetAllDataItemsForMonth() {
        let testMonth = Month(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
        
        let types = SampleDrinks.month(testMonth, context: context)
        
        let result = model.getAllDataItems(types: types, dates: testMonth)
        
        let expected = SampleDataItems.month(testMonth, context: context)
        
        for index in 0..<expected.count {
            XCTAssertEqual(result[index], expected[index], "failed at index \(index)")
        }    }
    
    func testGetAllDataItemsForHalfYesr() {
        let testHalfYear = HalfYear(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
        
        let types = SampleDrinks.halfYear(testHalfYear, context: context)
        
        let result = model.getAllDataItems(types: types, dates: testHalfYear)
        
        let expected = SampleDataItems.halfYear(testHalfYear, context: context)
        
        for index in 0..<expected.count {
            XCTAssertEqual(result[index], expected[index], "failed at index \(index)")
        }
    }
    
    func testGetAllDataItemsForYear() {
        let testYear = Year(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
        
        let types = SampleDrinks.year(testYear, context: context)
        
        let result = model.getAllDataItems(types: types, dates: testYear)
        
        let expected = SampleDataItems.year(testYear, context: context)
        
        for index in 0..<expected.count {
            XCTAssertEqual(result[index], expected[index], "failed at index \(index)")
        }
    }
}
