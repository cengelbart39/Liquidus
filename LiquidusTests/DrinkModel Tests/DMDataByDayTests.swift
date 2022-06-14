//
//  DMDataByDayTests.swift
//  LiquidusTests
//
//  Created by Christopher Engelbart on 4/30/22.
//

import XCTest
import CoreData
@testable import Liquidus

class DMDataByDayTests: XCTestCase {

    var context: NSManagedObjectContext!
    
    var model: DrinkModel!
    
    override func setUp() {
        self.context = PersistenceController.inMemory.container.viewContext
        self.model = DrinkModel(test: true, suiteName: nil)
    }
    
    override func tearDown() {
        self.context = nil
        self.model = nil
    }
    
    func testGetTotalPercentByDay() {
        let day = Day(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
        
        let types = SampleDrinks.day(day, context: context)
        
        let result = model.getTotalPercentByDay(types: types, day: day)
        
        XCTAssertEqual(result, 3.9)
    }
}
