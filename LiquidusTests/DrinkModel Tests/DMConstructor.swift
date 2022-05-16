//
//  DMConstructor.swift
//  LiquidusTests
//
//  Created by Christopher Engelbart on 5/3/22.
//

import XCTest
@testable import Liquidus

class DMConstructor: XCTestCase {

    var model: DrinkModel!

    override func setUp() {
        self.model = DrinkModel(test: true, suiteName: nil)
    }
    
    override func tearDown() {
        self.model = nil
    }
    
    func testConstructor() {
        // Check for default DrinkData
        XCTAssertEqual(model.drinkData, DrinkData())
        
        // Check that weeksPopulated is False
        XCTAssertFalse(model.weeksPopulated)
        
        // Check that selectedDay has the same day, month, and year as
        // the current day
        XCTAssertTrue(Calendar.current.compare(model.selectedDay, to: Date.now, toGranularity: .day) == .orderedSame && Calendar.current.compare(model.selectedDay, to: Date.now, toGranularity: .month) == .orderedSame && Calendar.current.compare(model.selectedDay, to: Date.now, toGranularity: .year) == .orderedSame)
        
        // Check that selectedWeek is empty
        XCTAssertEqual(model.selectedWeek.count, 0)
        
        // Check that healthStore exists
        XCTAssertNotNil(model.healthStore)
    }
    
}
