//
//  HalfYearTests.swift
//  LiquidusTests
//
//  Created by Christopher Engelbart on 5/27/22.
//

import XCTest
@testable import Liquidus

class HalfYearTests: XCTestCase {

    var halfYear: HalfYear!
    
    override func setUp() {
        self.halfYear = HalfYear(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
    }

    override func tearDown() {
        self.halfYear = nil
    }
    
    func testConstructor() {
        let result = self.halfYear!
        
        let expected = HalfYear()
        expected.data = self.halfYearToApril2022()
        expected.description = "Nov 2021 - Apr 2022"
        expected.accessibilityDescription = "Nov 2021 to Apr 2022"
        
        for index in 0..<expected.data.count {
            XCTAssertEqual(result.data[index], expected.data[index], "failed at index \(index)")
        }
    }
    
    func testFirstMonth() {
        let result = self.halfYear.firstMonth()
        
        let expected = Calendar.current.date(from: DateComponents(year: 2021, month: 11, day: 1))!
        
        XCTAssertEqual(result, expected)
    }
    
    func testLastMonth() {
        let result = self.halfYear.lastMonth()
        
        let expected = Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 1))!
        
        XCTAssertEqual(result, expected)
    }
    
    func testPrevHalfYear() {
        let result = self.halfYear!
        result.prevHalfYear()
        
        let expected = HalfYear()
        expected.data = halfYearToMarch2022()
        expected.description = "Oct 2021 - Mar 2022"
        expected.accessibilityDescription = "Oct 2021 to Mar 2022"

        for index in 0..<expected.data.count {
            XCTAssertEqual(result.data[index], expected.data[index], "failed at index \(index)")
        }
    }
    
    func testNextHalfYear() {
        let result = self.halfYear!
        result.nextHalfYear()
        
        let expected = HalfYear()
        expected.data = halfYearToMay2022()
        expected.description = "Dec 2021 - May 2022"
        expected.accessibilityDescription = "Dec 2021 to May 2022"

        for index in 0..<expected.data.count {
            XCTAssertEqual(result.data[index], expected.data[index], "failed at index \(index)")
        }
    }

    func testIsNextHalfYear() {
        XCTAssertTrue(HalfYear().isNextHalfYear())
        
        XCTAssertFalse(self.halfYear.isNextHalfYear())
    }
    
    func testEquatable() {
        let halfYear1 = self.halfYear!
        let halfYear2 = self.halfYear!
        XCTAssertTrue(halfYear1 == halfYear2)
        
        let halfYear3 = HalfYear()
        XCTAssertFalse(halfYear1 == halfYear3)
        XCTAssertFalse(halfYear2 == halfYear3)
    }
    
    private func halfYearToMarch2022() -> [Week] {
        var w0 = Week(date: Calendar.current.date(from: DateComponents(year: 2021, month: 10, day: 1))!)
        w0.data.removeFirst()
        w0.data.removeFirst()
        w0.data.removeFirst()
        w0.data.removeFirst()
        w0.data.removeFirst()
        w0 = Week(days: w0.data)

        let w1 = Week(date: Calendar.current.date(from: DateComponents(year: 2021, month: 10, day: 3))!)

        let w2 = Week(date: Calendar.current.date(from: DateComponents(year: 2021, month: 10, day: 10))!)
        
        let w3 = Week(date: Calendar.current.date(from: DateComponents(year: 2021, month: 10, day: 17))!)

        
        let w4 = Week(date: Calendar.current.date(from: DateComponents(year: 2021, month: 10, day: 24))!)

        
        let w5 = Week(date: Calendar.current.date(from: DateComponents(year: 2021, month: 10, day: 31))!)
        
        let w6 = Week(date: Calendar.current.date(from: DateComponents(year: 2021, month: 11, day: 7))!)
        
        let w7 = Week(date: Calendar.current.date(from: DateComponents(year: 2021, month: 11, day: 14))!)
        
        let w8 = Week(date: Calendar.current.date(from: DateComponents(year: 2021, month: 11, day: 21))!)
        
        let w9 = Week(date: Calendar.current.date(from: DateComponents(year: 2021, month: 11, day: 28))!)

        let w10 = Week(date: Calendar.current.date(from: DateComponents(year: 2021, month: 12, day: 5))!)

        let w11 = Week(date: Calendar.current.date(from: DateComponents(year: 2021, month: 12, day: 12))!)
        
        let w12 = Week(date: Calendar.current.date(from: DateComponents(year: 2021, month: 12, day: 19))!)
        
        let w13 = Week(date: Calendar.current.date(from: DateComponents(year: 2021, month: 12, day: 26))!)

        let w14 = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 1, day: 2))!)

        let w15 = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 1, day: 9))!)

        let w16 = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 1, day: 16))!)
        
        let w17 = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 1, day: 23))!)

        let w18 = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 1, day: 30))!)

        let w19 = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 2, day: 6))!)

        let w20 = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 2, day: 13))!)
        
        let w21 = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 2, day: 20))!)

        let w22 = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 2, day: 27))!)

        let w23 = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 3, day: 6))!)

        let w24 = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 3, day: 13))!)

        let w25 = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 3, day: 20))!)

        var w26 = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 3, day: 27))!)
        w26.data.removeLast()
        w26.data.removeLast()
        w26 = Week(days: w26.data)
        
        return [w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15, w16, w17, w18, w19, w20, w21, w22, w23, w24, w25, w26]
    }
    
    private func halfYearToApril2022() -> [Week] {
        var w1 = Week(date: Calendar.current.date(from: DateComponents(year: 2021, month: 11, day: 1))!)
        w1.data.removeFirst()
        w1 = Week(days: w1.data)
        
        let w2 = Week(date: Calendar.current.date(from: DateComponents(year: 2021, month: 11, day: 7))!)
        
        let w3 = Week(date: Calendar.current.date(from: DateComponents(year: 2021, month: 11, day: 14))!)
        
        let w4 = Week(date: Calendar.current.date(from: DateComponents(year: 2021, month: 11, day: 21))!)
        
        let w5 = Week(date: Calendar.current.date(from: DateComponents(year: 2021, month: 11, day: 28))!)

        let w6 = Week(date: Calendar.current.date(from: DateComponents(year: 2021, month: 12, day: 5))!)

        let w7 = Week(date: Calendar.current.date(from: DateComponents(year: 2021, month: 12, day: 12))!)
        
        let w8 = Week(date: Calendar.current.date(from: DateComponents(year: 2021, month: 12, day: 19))!)
        
        let w9 = Week(date: Calendar.current.date(from: DateComponents(year: 2021, month: 12, day: 26))!)

        let w10 = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 1, day: 2))!)

        let w11 = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 1, day: 9))!)

        let w12 = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 1, day: 16))!)
        
        let w13 = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 1, day: 23))!)

        let w14 = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 1, day: 30))!)

        let w15 = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 2, day: 6))!)

        let w16 = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 2, day: 13))!)
        
        let w17 = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 2, day: 20))!)

        let w18 = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 2, day: 27))!)

        let w19 = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 3, day: 6))!)

        let w20 = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 3, day: 13))!)

        let w21 = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 3, day: 20))!)

        let w22 = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 3, day: 27))!)
        
        let w23 = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 3))!)

        let w24 = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 10))!)

        let w25 = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 17))!)

        let w26 = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 24))!)
        
        return [w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15, w16, w17, w18, w19, w20, w21, w22, w23, w24, w25, w26]
    }
    
    private func halfYearToMay2022() -> [Week] {
        var w1 = Week(date: Calendar.current.date(from: DateComponents(year: 2021, month: 11, day: 28))!)
        w1.data.removeFirst()
        w1.data.removeFirst()
        w1.data.removeFirst()
        w1 = Week(days: w1.data)
        
        let w2 = Week(date: Calendar.current.date(from: DateComponents(year: 2021, month: 12, day: 5))!)

        let w3 = Week(date: Calendar.current.date(from: DateComponents(year: 2021, month: 12, day: 12))!)
        
        let w4 = Week(date: Calendar.current.date(from: DateComponents(year: 2021, month: 12, day: 19))!)
        
        let w5 = Week(date: Calendar.current.date(from: DateComponents(year: 2021, month: 12, day: 26))!)

        let w6 = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 1, day: 2))!)

        let w7 = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 1, day: 9))!)

        let w8 = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 1, day: 16))!)
        
        let w9 = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 1, day: 23))!)

        let w10 = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 1, day: 30))!)

        let w11 = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 2, day: 6))!)

        let w12 = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 2, day: 13))!)
        
        let w13 = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 2, day: 20))!)

        let w14 = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 2, day: 27))!)

        let w15 = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 3, day: 6))!)

        let w16 = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 3, day: 13))!)

        let w17 = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 3, day: 20))!)

        let w18 = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 3, day: 27))!)
        
        let w19 = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 3))!)

        let w20 = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 10))!)

        let w21 = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 17))!)

        let w22 = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 24))!)
        
        let w23 = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 5, day: 1))!)
        
        let w24 = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 5, day: 8))!)
        
        let w25 = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 5, day: 15))!)

        let w26 = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 5, day: 22))!)
        
        var w27 = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 5, day: 29))!)
        w27.data.removeLast()
        w27.data.removeLast()
        w27.data.removeLast()
        w27.data.removeLast()
        w27 = Week(days: w27.data)
        
        return [w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15, w16, w17, w18, w19, w20, w21, w22, w23, w24, w25, w26, w27]
    }

}
