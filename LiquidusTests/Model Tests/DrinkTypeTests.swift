//
//  DrinkTypeTests.swift
//  LiquidusTests
//
//  Created by Christopher Engelbart on 4/16/22.
//

import XCTest
import SwiftUI
@testable import Liquidus

class DrinkTypeTests: XCTestCase {

    var type: DrinkType!
    
    override func setUp() {
        self.type = DrinkType(name: Constants.waterKey, color: CodableColor(color: .systemTeal), isDefault: true, enabled: true, colorChanged: false)
    }
    
    override func tearDown() {
        self.type = nil
    }
    
    func testConstructor() {
        // Test type's constructor
        XCTAssertEqual(type.name, "Water") // Type Name
        XCTAssertEqual(type.color.getColor(), Color(.systemTeal)) // Type Color
        XCTAssertEqual(type.isDefault, true) // Type Default Status
        XCTAssertEqual(type.enabled, true) // Type Enabled Status
        XCTAssertEqual(type.colorChanged, false) // Type Color Changed Status
        
        // Test default constructor
        let newType = DrinkType()
        XCTAssertEqual(newType.name, "temp") // Type Name
        XCTAssertEqual(newType.color.getColor(), Color(.systemRed)) // Type Color
        XCTAssertEqual(newType.isDefault, true) // Type Default Status
        XCTAssertEqual(newType.enabled, true) // Type Enabled Status
        XCTAssertEqual(newType.colorChanged, true) // Type Color Changed Status
    }
    
    func testEqutable() {
        // Assert thetype is equal to itself
        XCTAssertEqual(type, type)
        
        // Assert the type is not equal to the return of the default constructor
        XCTAssertNotEqual(type, DrinkType())
    }
    
}
