//
//  DMProgressBarTests.swift
//  LiquidusTests
//
//  Created by Christopher Engelbart on 5/3/22.
//

import XCTest
import CoreData
import SwiftUI
@testable import Liquidus

class DMProgressBarTests: XCTestCase {

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

    func testGetProgressPercent() {
        // Get the week of April 8, 2022
        let testWeek = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
        
        // Add sample drinks for that week
        let types = SampleDrinks.week(testWeek, context: context)
        
        // Create a date for April 3, 2022
        let testDate = Day(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 3))!)
        
        // Set expected1 result
        let expected = 100.0/2000.0
        
        // Assert the method return is equal to expected
        XCTAssertEqual(model.getProgressPercent(types: types, day: testDate), expected)
    }

    func testGetHighlightColor() {
        // Get the week of April 8, 2022
        let testDate = Day(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
        
        let types = SampleDrinkTypes.allTypes(context)
        
        var typesA = Array(types.prefix(4))
        var typesB = Array(types.prefix(3))
        var typesC = Array(types.prefix(2))
        var typesD = Array(types.prefix(1))

        // < Goal
        XCTAssertEqual(model.getHighlightColor(types: typesA, day: testDate), Color(uiColor: UIColor.systemOrange))
        
        XCTAssertEqual(model.getHighlightColor(types: typesB, day: testDate), Color(uiColor: UIColor.systemGreen))
        
        XCTAssertEqual(model.getHighlightColor(types: typesC, day: testDate), Color(uiColor: UIColor.systemBrown))
        
        XCTAssertEqual(model.getHighlightColor(types: typesD, day: testDate), Color(uiColor: UIColor.systemCyan))

        // Grayscale Enabled
        model.grayscaleEnabled = true
        
        XCTAssertEqual(model.getHighlightColor(types: typesA, day: testDate), Color.primary)
        
        XCTAssertEqual(model.getHighlightColor(types: typesB, day: testDate), Color.primary)
        
        XCTAssertEqual(model.getHighlightColor(types: typesC, day: testDate), Color.primary)

        XCTAssertEqual(model.getHighlightColor(types: typesD, day: testDate), Color.primary)
        
        // Goal Reached
        model.grayscaleEnabled = false
        
        let typesWithDrinks = SampleDrinks.day(testDate, context: context)
        typesA = Array(typesWithDrinks.prefix(4))
        typesB = Array(typesWithDrinks.prefix(3))
        typesC = Array(typesWithDrinks.prefix(2))
        typesD = Array(typesWithDrinks.prefix(1))

        XCTAssertEqual(model.getHighlightColor(types: typesA, day: testDate), Color("GoalGreen"))
        
        XCTAssertEqual(model.getHighlightColor(types: typesB, day: testDate), Color("GoalGreen"))

        XCTAssertEqual(model.getHighlightColor(types: typesC, day: testDate), Color("GoalGreen"))

        XCTAssertEqual(model.getHighlightColor(types: typesD, day: testDate), Color(uiColor: UIColor.systemCyan))


    }
}
