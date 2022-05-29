//
//  WeekTests.swift
//  LiquidusTests
//
//  Created by Christopher Engelbart on 5/27/22.
//

import XCTest
@testable import Liquidus

class WeekTests: XCTestCase {

    var week: Week!
    
    override func setUp() {
        self.week = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
    }

    override func tearDown() {
        self.week = nil
    }
    
    func testDateConstructor() {
        let result = week!
        
        let expected = Week()
        
        expected.data = [
            Day(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 3))!),
            Day(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 4))!),
            Day(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 5))!),
            Day(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 6))!),
            Day(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 7))!),
            Day(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!),
            Day(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 9))!)
        ]
        expected.description = "Apr 3-9, 2022"
        expected.accessibilityDescription = "Apr 3rd to 9th, 2022"
        
        XCTAssertEqual(result, expected)
    }
    
    func testArrayConstructor() {
        let days = [
            Day(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 3))!),
            Day(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 4))!),
            Day(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 5))!),
            Day(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 6))!),
            Day(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 7))!),
            Day(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!),
            Day(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 9))!)
        ]
        
        let result = Week(days: days)
        
        let expected = Week()
        expected.data = days
        expected.description = "Apr 3-9, 2022"
        expected.accessibilityDescription = "Apr 3rd to 9th, 2022"
        
        XCTAssertEqual(result, expected)
    }
    
    func testFirstDay() {
        let result = week.firstDay()
        
        let expected = Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 3))!
        
        XCTAssertEqual(result, expected)
    }
    
    func testLastDay() {
        let result = week.lastDay()
        
        let expected = Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 9))!
        
        XCTAssertEqual(result, expected)
    }

    func testPrevWeek() {
        let expected = Week()
        expected.data = [
            Day(date: Calendar.current.date(from: DateComponents(year: 2022, month: 3, day: 27))!),
            Day(date: Calendar.current.date(from: DateComponents(year: 2022, month: 3, day: 28))!),
            Day(date: Calendar.current.date(from: DateComponents(year: 2022, month: 3, day: 29))!),
            Day(date: Calendar.current.date(from: DateComponents(year: 2022, month: 3, day: 30))!),
            Day(date: Calendar.current.date(from: DateComponents(year: 2022, month: 3, day: 31))!),
            Day(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 1))!),
            Day(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 2))!)
        ]
        expected.description = "Mar 27 - Apr 2, 2022"
        expected.accessibilityDescription = "Mar 27th to Apr 2nd, 2022"
        
        week.prevWeek()
        
        XCTAssertEqual(self.week, expected)
    }
    
    func testNextWeek() {
        let expected = Week()
        expected.data = [
            Day(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 10))!),
            Day(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 11))!),
            Day(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 12))!),
            Day(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 13))!),
            Day(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 14))!),
            Day(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 15))!),
            Day(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 16))!)
        ]
        expected.description = "Apr 10-16, 2022"
        expected.accessibilityDescription = "Apr 10th to 16th, 2022"
        
        week.nextWeek()
        
        XCTAssertEqual(self.week, expected)
    }
    
    func testIsNextWeek() {
        XCTAssertTrue(Week().isNextWeek())
        XCTAssertFalse(week.isNextWeek())
    }
    
    func testUpdate() {
        week.update(date: Date.now)
        
        XCTAssertEqual(week!, Week())
    }
    
    func testEquatable() {
        let week1 = week!
        let week2 = week!
        XCTAssertTrue(week1 == week2)
        
        let week3 = Week()
        XCTAssertFalse(week1 == week3)
        XCTAssertFalse(week2 == week3)
    }
}
