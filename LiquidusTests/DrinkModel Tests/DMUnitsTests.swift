//
//  DMUnitsTests.swift
//  LiquidusTests
//
//  Created by Christopher Engelbart on 4/29/22.
//

import XCTest
@testable import Liquidus

class DMUnitsTests: XCTestCase {

    var model: DrinkModel!
    
    override func setUp() {
        self.model = DrinkModel(test: true, suiteName: nil)
    }
    
    override func tearDown() {
        self.model = nil
    }
    
    func testGetSpecificer() {
        // Check that 10 returns  "%.0f"
        XCTAssertEqual(model.getSpecifier(amount: 10), "%.0f")
        
        // Check 10.5 returns "%.2f"
        XCTAssertEqual(model.getSpecifier(amount: 10.5), "%.2f")
    }

    func testGetUnits() {
        // Set units to milliliters
        model.drinkData.units = Constants.milliliters
        
        // Check that "mL" is returned
        XCTAssertEqual(model.getUnits(), "mL")
        
        // Set units to liters
        model.drinkData.units = Constants.liters
        
        // Check that "L" is return
        XCTAssertEqual(model.getUnits(), "L")
        
        // Set units to fluid ounces
        model.drinkData.units = Constants.fluidOuncesUS
        
        // Check that "floz" is returned
        XCTAssertEqual(model.getUnits(), "floz")
        
        // Set units to cups
        model.drinkData.units = Constants.cupsUS
        
        // Check that "cups" is returned
        XCTAssertEqual(model.getUnits(), "cups")
    }
    
    func testGetAccessibilityUnitLabel() {
        // Set units to mL and check "milliliters" is returned
        model.drinkData.units = Constants.milliliters
        XCTAssertEqual(model.getAccessibilityUnitLabel(), "milliliters")
        
        // Set units to L and check "liters" is returned
        model.drinkData.units = Constants.liters
        XCTAssertEqual(model.getAccessibilityUnitLabel(), "liters")
        
        // Set units to fl oz and check "fluid ounces" is returned
        model.drinkData.units = Constants.fluidOuncesUS
        XCTAssertEqual(model.getAccessibilityUnitLabel(), "fluid ounces")
        
        // Set units to cups and check "cups" is returned
        model.drinkData.units = Constants.cupsUS
        XCTAssertEqual(model.getAccessibilityUnitLabel(), "cups")
    }
}
