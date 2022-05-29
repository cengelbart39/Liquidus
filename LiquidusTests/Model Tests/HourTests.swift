//
//  HourTests.swift
//  LiquidusTests
//
//  Created by Christopher Engelbart on 5/27/22.
//

import XCTest
@testable import Liquidus

class HourTests: XCTestCase {

    var hour: Hour!
    
    override func setUp() {
        self.hour = Hour(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8, hour: 12, minute: 0, second: 0, nanosecond: 0))!)
    }

    override func tearDown() {
        self.hour = nil
    }

    func testDefaultConstructor() {
        let result = Hour()
        
        let now = Date.now
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour], from: now)
        
        let year = components.year!
        let month = components.month!
        let day = components.day!
        let hour = components.hour!
        
        let expected = Hour(date: self.hour.data)
        expected.data = Calendar.current.date(from: DateComponents(year: year, month: month, day: day, hour: hour, minute: 0, second: 0, nanosecond: 0))!
        expected.description = self.getHourDescription(for: hour)
        expected.accessibilityDescription = self.getHourDescription(for: hour)
        
        XCTAssertEqual(result, expected)
    }
    
    func testDateConstructor() {
        let expected = Hour(date: self.hour.data)
        expected.data = Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8, hour: 11, minute: 0, second: 0, nanosecond: 0))!
        expected.description = self.getHourDescription(for: 12)
        expected.accessibilityDescription = self.getHourDescription(for: 12)
        
        XCTAssertEqual(self.hour!, expected)
    }
    
    func testEqutable() {
        let hour1 = self.hour
        let hour2 = self.hour
        XCTAssertTrue(hour1 == hour2)
        
        let hour3 = Hour()
        XCTAssertFalse(hour1 == hour3)
        XCTAssertFalse(hour2 == hour3)
    }
    
    private func getHourDescription(for hour: Int) -> String {
        switch hour {
        case 0:
            return "12 AM"
        case 1...11:
            return "\(hour) AM"
        case 12:
            return "12 PM"
        case 13...23:
            return "\(hour-12) PM"
        default:
            return ""
        }
        
    }
}
