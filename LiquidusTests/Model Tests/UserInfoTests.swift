//
//  UserInfoTests.swift
//  LiquidusTests
//
//  Created by Christopher Engelbart on 4/16/22.
//

import XCTest
@testable import Liquidus

class UserInfoTests: XCTestCase {

    var data: UserInfo!

    override func setUp() {
        self.data = UserInfo()
    }
    
    override func tearDown() {
        self.data = nil
    }
    
    func testConstructor() {
        // Test Onboarding Status
        XCTAssertTrue(data.isOnboarding)
        
        // Test if currentDay is Today
        XCTAssertTrue(Calendar.current.isDateInToday(data.currentDay))
        
        // Test for Daily Total To Goal
        XCTAssertEqual(data.dailyTotalToGoal, 0.0)
        
        // Test for Daily Goal
        XCTAssertEqual(data.dailyGoal, 2000.0)
        
        // Test for Default Units
        XCTAssertEqual(data.units, Constants.milliliters)
        
        // Test LastHKStatus
        XCTAssertNil(data.lastHKSave)
        
        // Test HealthKitEnabled Status
        XCTAssertFalse(data.healthKitEnabled)
    }
}
