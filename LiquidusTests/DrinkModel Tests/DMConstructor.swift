//
//  DMConstructor.swift
//  LiquidusTests
//
//  Created by Christopher Engelbart on 5/3/22.
//

import XCTest
import SwiftUI
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
        
        // Check that healthStore exists
        XCTAssertNotNil(model.healthStore)
    }
}
