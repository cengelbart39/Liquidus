//
//  DMHealthKitTests.swift
//  LiquidusTests
//
//  Created by Christopher Engelbart on 5/14/22.
//

import XCTest
import HealthKit
@testable import Liquidus

class DMHealthKitTests: XCTestCase {

    var model: DrinkModel!

    override func setUp() {
        self.model = DrinkModel(test: true, suiteName: nil)
    }
    
    override func tearDown() {
        self.model = nil
    }
    
    func testGetHKUnit() {
        // Set units to millilters and test for the correct HKUnit
        model.drinkData.units = Constants.milliliters
        XCTAssertEqual(model.getHKUnit(), HKUnit.literUnit(with: .milli))
        
        // Set units to liters and test for the correct HKUnit
        model.drinkData.units = Constants.liters
        XCTAssertEqual(model.getHKUnit(), HKUnit.liter())
        
        // Set units to fluid ounces and test for the correct HKUnit
        model.drinkData.units = Constants.fluidOuncesUS
        XCTAssertEqual(model.getHKUnit(), HKUnit.fluidOunceUS())
        
        // Set units to cups and test for the correct HKUnit
        model.drinkData.units = Constants.cupsUS
        XCTAssertEqual(model.getHKUnit(), HKUnit.cupUS())
    }
}
