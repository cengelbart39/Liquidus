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
        var drinkData = DrinkData()
        drinkData.isOnboarding = false
        drinkData.drinks = [Drink(type: model.drinkData.drinkTypes.first!, amount: 39, date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)]
        drinkData.dailyGoal = 27.0
        drinkData.units = Constants.fluidOuncesUS
        drinkData.drinkTypes += [DrinkType(name: "Apple Cider", color: CodableColor(color: UIColor(red: 207/255, green: 58/255, blue: 31/255, alpha: 1)), isDefault: false, enabled: true, colorChanged: true)]
        drinkData.lastHKSave = Date.now
        drinkData.healthKitEnabled = false
        
        // Update the model
        model.drinkData = drinkData
        
        // Save the new drinkData
        model.save(test: true)
        
        // Return drinkData to its default state
        model.drinkData = DrinkData()
        
        // Retrieve the data
        model.retrieve(test: true)
        
        // Assert it was saved and retrieved correctly
        XCTAssertEqual(model.drinkData.isOnboarding, drinkData.isOnboarding)
        XCTAssertEqual(model.drinkData.drinks, drinkData.drinks)
        XCTAssertEqual(model.drinkData.dailyGoal, drinkData.dailyGoal)
        XCTAssertEqual(model.drinkData.units, drinkData.units)
        XCTAssertEqual(model.drinkData.drinkTypes, drinkData.drinkTypes)
        XCTAssertEqual(model.drinkData.lastHKSave, drinkData.lastHKSave)
        XCTAssertEqual(model.drinkData.healthKitEnabled, drinkData.healthKitEnabled)
    }

}
