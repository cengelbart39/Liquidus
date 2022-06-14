//
//  DMConstructorTests.swift
//  LiquidusTests
//
//  Created by Christopher Engelbart on 5/3/22.
//

import XCTest
import SwiftUI
@testable import Liquidus

class DMConstructorTests: XCTestCase {

    var model: DrinkModel!

    override func setUp() {
        self.model = DrinkModel(test: true, suiteName: Constants.unitTestingKey)
    }
    
    override func tearDown() {
        self.model = nil
    }
    
    func testConstructor() {
        let new = UserInfo()
        
        // Check for default DrinkData
        XCTAssertEqual(model.userInfo, new)
        
        // Check that healthStore exists
        XCTAssertNotNil(model.healthStore)
    }
}
