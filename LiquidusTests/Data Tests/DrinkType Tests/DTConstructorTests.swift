//
//  DTConstructorTests.swift
//  LiquidusTests
//
//  Created by Christopher Engelbart on 4/16/22.
//

import XCTest
import CoreData
import SwiftUI
@testable import Liquidus

class DTConstructorTests: XCTestCase {

    var context: NSManagedObjectContext!
    
    var type: DrinkType!
    
    override func setUp() {
        self.context = PersistenceController.inMemory.container.viewContext
        
        self.type = SampleDrinkTypes.water(context)
    }
    
    override func tearDown() {
        self.context = nil
        self.type = nil
    }
    
    func testConstructor() {
        XCTAssertEqual(type.name, "Water")
        XCTAssertEqual(type.order, 0)
        XCTAssertTrue(type.enabled)
        XCTAssertTrue(type.isDefault)
        XCTAssertFalse(type.colorChanged)
        XCTAssertEqual(type.color, UIColor.systemTeal.encode())
        XCTAssertEqual(type.drinks?.count ?? 0, 0)
    }
    
    func testEqutable() {
        // Assert thetype is equal to itself
        XCTAssertEqual(type, type)
        
        let testType = DrinkType(context: context)
        testType.id = UUID()
        testType.name = "Coffee"
        testType.order = 1
        testType.enabled = true
        testType.isDefault = true
        testType.colorChanged = false
        testType.color = UIColor.systemBrown.encode()
        testType.drinks = nil
        
        XCTAssertNotEqual(type, testType)
    }
    
}
