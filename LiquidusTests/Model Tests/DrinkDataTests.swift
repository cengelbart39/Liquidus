//
//  DrinkDataTests.swift
//  LiquidusTests
//
//  Created by Christopher Engelbart on 4/16/22.
//

import XCTest
@testable import Liquidus

class DrinkDataTests: XCTestCase {

    var data: DrinkData!

    override func setUp() {
        self.data = DrinkData()
    }
    
    override func tearDown() {
        self.data = nil
    }
    
    func testConstructor() {
        XCTAssertTrue(data.isOnboarding) // Test Onboarding Status
        XCTAssertEqual(data.drinks.count, 0) // Test for Empty Drinks Array
        XCTAssertEqual(data.dailyGoal, 2000.0) // Test for Daily Goal
        XCTAssertEqual(data.units, Constants.milliliters) // Test for Default Units
        XCTAssertEqual(data.drinkTypes, DrinkType.getDefault()) // Test for Default Drink Types
        XCTAssertNil(data.lastHKSave) // Test LastHKStatus
        XCTAssertFalse(data.healthKitEnabled) // Test HealthKitEnabled Status
    }
}
