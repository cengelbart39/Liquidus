//
//  DMUserDefaultsTests.swift
//  LiquidusTests
//
//  Created by Christopher Engelbart on 5/16/22.
//

import XCTest
import Combine
@testable import Liquidus

class DMUserDefaultsTests: XCTestCase {

    var model: DrinkModel!

    override func setUp() {
        self.model = DrinkModel(test: true, suiteName: Constants.unitTestingKey)
    }
    
    override func tearDown() {
        self.model = nil
    }

    func testSaveAndRetrieve() {
        // Create a configure a new DrinkData
        var userInfo = UserInfo()
        userInfo.isOnboarding = false
        userInfo.currentDay = Date()
        userInfo.dailyTotalToGoal = 10.5
        userInfo.dailyGoal = 27.0
        userInfo.units = Constants.fluidOuncesUS
        userInfo.lastHKSave = Date.now
        userInfo.healthKitEnabled = false
        
        // Update the model
        model.userInfo = userInfo
        
        // Save the new userInfo
        model.saveUserInfo(test: true)
        
        // Return userInfo to its default state
        model.userInfo = UserInfo()
        
        // Retrieve the data
        model.retrieveUserInfo(test: true)
        
        // Assert it was saved and retrieved correctly
        XCTAssertEqual(model.userInfo.isOnboarding, userInfo.isOnboarding)
        XCTAssertEqual(model.userInfo.currentDay.description, userInfo.currentDay.description)
        XCTAssertEqual(model.userInfo.dailyTotalToGoal, userInfo.dailyTotalToGoal)
        XCTAssertEqual(model.userInfo.dailyGoal, userInfo.dailyGoal)
        XCTAssertEqual(model.userInfo.units, userInfo.units)
        XCTAssertEqual(model.userInfo.lastHKSave, userInfo.lastHKSave)
        XCTAssertEqual(model.userInfo.healthKitEnabled, userInfo.healthKitEnabled)
    }

}
