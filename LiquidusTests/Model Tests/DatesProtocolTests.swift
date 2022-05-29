//
//  DatesProtocolTests.swift
//  LiquidusTests
//
//  Created by Christopher Engelbart on 5/28/22.
//

import XCTest
@testable import Liquidus

class DatesProtocolTests: XCTestCase {

    var date = Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!
    
    override func setUp() { }
    
    override func tearDown() { }
    
    func testDayIsEqualTo() {
        let day = Day()
        XCTAssertTrue(day.isEqualTo(other: Day()))
        XCTAssertFalse(day.isEqualTo(other: Day(date: date)))
        
        XCTAssertFalse(day.isEqualTo(other: Week()))
        XCTAssertFalse(day.isEqualTo(other: Month()))
        XCTAssertFalse(day.isEqualTo(other: HalfYear()))
        XCTAssertFalse(day.isEqualTo(other: Year()))
    }
    
    func testWeekIsEqualTo() {
        let week = Week()
        XCTAssertTrue(week.isEqualTo(other: Week()))
        XCTAssertFalse(week.isEqualTo(other: Week(date: date)))
        
        XCTAssertFalse(week.isEqualTo(other: Day()))
        XCTAssertFalse(week.isEqualTo(other: Month()))
        XCTAssertFalse(week.isEqualTo(other: HalfYear()))
        XCTAssertFalse(week.isEqualTo(other: Year()))
    }
    
    func testMonthIsEqualTo() {
        let month = Month()
        XCTAssertTrue(month.isEqualTo(other: Month()))
        XCTAssertFalse(month.isEqualTo(other: Month(date: date)))
        
        XCTAssertFalse(month.isEqualTo(other: Day()))
        XCTAssertFalse(month.isEqualTo(other: Week()))
        XCTAssertFalse(month.isEqualTo(other: HalfYear()))
        XCTAssertFalse(month.isEqualTo(other: Year()))
    }
    
    func testHalfYearIsEqualTo() {
        let halfYear = HalfYear()
        XCTAssertTrue(halfYear.isEqualTo(other: HalfYear()))
        XCTAssertFalse(halfYear.isEqualTo(other: HalfYear(date: date)))
        
        XCTAssertFalse(halfYear.isEqualTo(other: Day()))
        XCTAssertFalse(halfYear.isEqualTo(other: Week()))
        XCTAssertFalse(halfYear.isEqualTo(other: Month()))
        XCTAssertFalse(halfYear.isEqualTo(other: Year()))
    }
    
    func testYearIsEqualTo() {
        let year = Year()
        XCTAssertTrue(year.isEqualTo(other: Year()))
        XCTAssertFalse(year.isEqualTo(other: Year(date: date)))
        
        XCTAssertFalse(year.isEqualTo(other: Day()))
        XCTAssertFalse(year.isEqualTo(other: Week()))
        XCTAssertFalse(year.isEqualTo(other: Month()))
        XCTAssertFalse(year.isEqualTo(other: HalfYear()))
    }
}
