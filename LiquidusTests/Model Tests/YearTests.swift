//
//  YearTests.swift
//  LiquidusTests
//
//  Created by Christopher Engelbart on 5/27/22.
//

import XCTest
@testable import Liquidus

class YearTests: XCTestCase {
    
    var year: Year!
    
    override func setUp() {
        self.year = Year(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
    }

    override func tearDown() {
        self.year = nil
    }
    
    func testConstructor() {
        let result = self.year!
        
        let expected = Year()
        expected.data = self.yearToApril2022()
        expected.description = "May 2021 - Apr 2022"
        expected.accessibilityDescription = "May 2021 to Apr 2022"
        
        XCTAssertEqual(result.description, expected.description)
        XCTAssertEqual(result.accessibilityDescription, expected.accessibilityDescription)
        
        for index in 0..<expected.data.count {
            XCTAssertEqual(result.data[index], expected.data[index], "failed at index \(index)")
        }
    }
    
    func testFirstMonth() {
        let result = self.year.firstMonth()
        
        let expected = Calendar.current.date(from: DateComponents(year: 2021, month: 5, day: 1))
        
        XCTAssertEqual(result, expected)
    }
    
    func testLastMonth() {
        let result = self.year.lastMonth()
        
        let expected = Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 1))
        
        XCTAssertEqual(result, expected)
    }
    
    func testPrevYear() {
        let expected = Year()
        expected.data = self.yearToMar2022()
        expected.description = "Apr 2021 - Mar 2022"
        expected.accessibilityDescription = "Apr 2021 to Mar 2022"
        
        self.year.prevYear()
        
        XCTAssertEqual(self.year!, expected)
    }
    
    func testNextYear() {
        let expected = Year()
        expected.data = self.yearToMay2022()
        expected.description = "Jun 2021 - May 2022"
        expected.accessibilityDescription = "Jun 2021 to May 2022"
        
        self.year.nextYear()
        
        XCTAssertEqual(self.year!, expected)
    }
    
    func testIsNextYear() {
        XCTAssertTrue(Year().isNextYear())
        
        XCTAssertFalse(self.year.isNextYear())
    }
    
    func testEquatable() {
        let year1 = self.year!
        let year2 = self.year!
        XCTAssertTrue(year1 == year2)
        
        let year3 = Year()
        XCTAssertFalse(year1 == year3)
        XCTAssertFalse(year2 == year3
        )
    }
    
    private func yearToMar2022() -> [Month] {
        let apr21 = Month(date: Calendar.current.date(from: DateComponents(year: 2021, month: 4, day: 1))!)
        
        let may21 = Month(date: Calendar.current.date(from: DateComponents(year: 2021, month: 5, day: 1))!)
        
        let jun21 = Month(date: Calendar.current.date(from: DateComponents(year: 2021, month: 6, day: 1))!)
        
        let jul21 = Month(date: Calendar.current.date(from: DateComponents(year: 2021, month: 7, day: 1))!)
        
        let aug21 = Month(date: Calendar.current.date(from: DateComponents(year: 2021, month: 8, day: 1))!)
        
        let sep21 = Month(date: Calendar.current.date(from: DateComponents(year: 2021, month: 9, day: 1))!)
        
        let oct21 = Month(date: Calendar.current.date(from: DateComponents(year: 2021, month: 10, day: 1))!)
        
        let nov21 = Month(date: Calendar.current.date(from: DateComponents(year: 2021, month: 11, day: 1))!)
        
        let dec21 = Month(date: Calendar.current.date(from: DateComponents(year: 2021, month: 12, day: 1))!)
        
        let jan22 = Month(date: Calendar.current.date(from: DateComponents(year: 2022, month: 1, day: 1))!)
        
        let feb22 = Month(date: Calendar.current.date(from: DateComponents(year: 2022, month: 2, day: 1))!)
        
        let mar22 = Month(date: Calendar.current.date(from: DateComponents(year: 2022, month: 3, day: 1))!)
                
        return [apr21, may21, jun21, jul21, aug21, sep21, oct21, nov21, dec21, jan22, feb22, mar22]
    }

    private func yearToApril2022() -> [Month] {
        let may21 = Month(date: Calendar.current.date(from: DateComponents(year: 2021, month: 5, day: 1))!)
        
        let jun21 = Month(date: Calendar.current.date(from: DateComponents(year: 2021, month: 6, day: 1))!)
        
        let jul21 = Month(date: Calendar.current.date(from: DateComponents(year: 2021, month: 7, day: 1))!)
        
        let aug21 = Month(date: Calendar.current.date(from: DateComponents(year: 2021, month: 8, day: 1))!)
        
        let sep21 = Month(date: Calendar.current.date(from: DateComponents(year: 2021, month: 9, day: 1))!)
        
        let oct21 = Month(date: Calendar.current.date(from: DateComponents(year: 2021, month: 10, day: 1))!)
        
        let nov21 = Month(date: Calendar.current.date(from: DateComponents(year: 2021, month: 11, day: 1))!)
        
        let dec21 = Month(date: Calendar.current.date(from: DateComponents(year: 2021, month: 12, day: 1))!)
        
        let jan22 = Month(date: Calendar.current.date(from: DateComponents(year: 2022, month: 1, day: 1))!)
        
        let feb22 = Month(date: Calendar.current.date(from: DateComponents(year: 2022, month: 2, day: 1))!)
        
        let mar22 = Month(date: Calendar.current.date(from: DateComponents(year: 2022, month: 3, day: 1))!)
        
        let apr22 = Month(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 1))!)
        
        return [may21, jun21, jul21, aug21, sep21, oct21, nov21, dec21, jan22, feb22, mar22, apr22]
    }
    
    private func yearToMay2022() -> [Month] {
        let jun21 = Month(date: Calendar.current.date(from: DateComponents(year: 2021, month: 6, day: 1))!)
        
        let jul21 = Month(date: Calendar.current.date(from: DateComponents(year: 2021, month: 7, day: 1))!)
        
        let aug21 = Month(date: Calendar.current.date(from: DateComponents(year: 2021, month: 8, day: 1))!)
        
        let sep21 = Month(date: Calendar.current.date(from: DateComponents(year: 2021, month: 9, day: 1))!)
        
        let oct21 = Month(date: Calendar.current.date(from: DateComponents(year: 2021, month: 10, day: 1))!)
        
        let nov21 = Month(date: Calendar.current.date(from: DateComponents(year: 2021, month: 11, day: 1))!)
        
        let dec21 = Month(date: Calendar.current.date(from: DateComponents(year: 2021, month: 12, day: 1))!)
        
        let jan22 = Month(date: Calendar.current.date(from: DateComponents(year: 2022, month: 1, day: 1))!)
        
        let feb22 = Month(date: Calendar.current.date(from: DateComponents(year: 2022, month: 2, day: 1))!)
        
        let mar22 = Month(date: Calendar.current.date(from: DateComponents(year: 2022, month: 3, day: 1))!)
        
        let apr22 = Month(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 1))!)
        
        let may22 = Month(date: Calendar.current.date(from: DateComponents(year: 2022, month: 5, day: 1))!)
        
        return [jun21, jul21, aug21, sep21, oct21, nov21, dec21, jan22, feb22, mar22, apr22, may22]
    }

}
