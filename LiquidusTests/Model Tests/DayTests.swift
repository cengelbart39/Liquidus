//
//  DayTests.swift
//  LiquidusTests
//
//  Created by Christopher Engelbart on 5/27/22.
//

import XCTest
@testable import Liquidus

class DayTests: XCTestCase {

    var day: Day!
    
    override func setUp() {
        self.day = Day(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
    }

    override func tearDown() {
        self.day = nil
    }
    
    func testDefaultConstructor() {
        let result = Day()
        
        let expected = Day()
        expected.data = Date.now
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        expected.description = formatter.string(from: Date.now)
        
        formatter.doesRelativeDateFormatting = true
        expected.accessibilityDescription = formatter.string(from: Date.now)
        
        XCTAssertEqual(result, expected)
    }
    
    func testDateConstructor() {
        let testDate = Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!
        
        let result = Day(date: testDate)
        
        let expected = Day()
        expected.data = testDate
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        expected.description = formatter.string(from: testDate)
        
        formatter.doesRelativeDateFormatting = true
        expected.accessibilityDescription = formatter.string(from: testDate)
        
        XCTAssertEqual(result, expected)
    }
    
    func testNextDay() {
        let testDate = day.data
        
        let result = Day(date: testDate)
        result.nextDay()
        
        let expectedDate = Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 9))!
        
        let expectedDay = Day()
        expectedDay.data = expectedDate
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        expectedDay.description = formatter.string(from: expectedDate)
        
        formatter.doesRelativeDateFormatting = true
        expectedDay.accessibilityDescription = formatter.string(from: expectedDate)
        
        XCTAssertEqual(result, expectedDay)
    }
    
    func testPrevDay() {
        let testDate = day.data
        
        let result = Day(date: testDate)
        result.prevDay()
        
        let expectedDate = Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 7))!
        
        let expectedDay = Day()
        expectedDay.data = expectedDate
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        expectedDay.description = formatter.string(from: expectedDate)
        
        formatter.doesRelativeDateFormatting = true
        expectedDay.accessibilityDescription = formatter.string(from: expectedDate)
        
        XCTAssertEqual(result, expectedDay)
    }

    func testIsTomorrow() {
        let result1 = Day().isTomorrow()
        XCTAssertTrue(result1)
        
        let result2 = day.isTomorrow()
        XCTAssertFalse(result2)
    }
    
    func testToday() {
        day.today()
        XCTAssertEqual(day, Day())
    }
    
    func testUpdate() {
        let date = Calendar.current.date(from: DateComponents(year: 2022, month: 5, day: 27))!
        
        day.update(date: date)
        
        XCTAssertEqual(day, Day(date: date))
    }
    
    func testEqutable() {
        let day1 = day
        let day2 = day
        XCTAssertTrue(day1 == day2)
        
        let day3 = Day()
        XCTAssertFalse(day1 == day3)
        XCTAssertFalse(day2 == day3)
    }
}
