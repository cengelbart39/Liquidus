//
//  DMTimeDisplayTests.swift
//  LiquidusTests
//
//  Created by Christopher Engelbart on 4/26/22.
//

import XCTest
@testable import Liquidus

class DMTimeDisplayTests: XCTestCase {

    var model: DrinkModel!

    override func setUp() {
        self.model = DrinkModel(test: true, suiteName: nil)
    }
    
    override func tearDown() {
        self.model = nil
    }

    func testIsNextWeek() {
        // Set prevDay (i.e. if today is 4/8/2022, set to 4/1/2022)
        let prevDay = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: .now)!
        
        // Get the current week
        let thisWeek = model.getWeek(date: .now)
        
        // Get the week of prevDay
        let prevWeek = model.getWeek(date: prevDay)
                
        // Assert True and False
        XCTAssertTrue(model.isNextWeek(currentWeek: thisWeek))
        XCTAssertFalse(model.isNextWeek(currentWeek: prevWeek))
    }
    
    func testIsNextMonth() {
        // Set prevDay (i.e. if today is 4/8/2022, set to 3/8/2022)
        let prevDay = Calendar.current.date(byAdding: .month, value: -1, to: .now)!
        
        // Get the current month
        let thisMonth = model.getMonth(day: .now)
        
        // Get the previous month relative to the current month
        let prevMonth = model.getMonth(day: prevDay)
        
        // Assert the next month is thisMonth
        XCTAssertTrue(model.isNextMonth(currentMonth: thisMonth))
        
        // Assert the the next month isn't prevMonth
        XCTAssertFalse(model.isNextMonth(currentMonth: prevMonth))
    }
    
    func testIsNextHalfYear() {
        // Set prevDay (i.e. if today is 4/8/2022, set to 3/8/2022)
        let prevDay = Calendar.current.date(byAdding: .month, value: -1, to: .now)!
        
        // Get the current half year (this month and the last 5 months)
        let thisHalfYear = model.getHalfYear(date: .now)
        
        // Get the half year starting in the month of prevDay
        let prevHalfYear = model.getHalfYear(date: prevDay)
        
        // Assert the next half year is thisHalfYear
        XCTAssertTrue(model.isNextHalfYear(currentHalfYear: thisHalfYear))
        
        // Assert the next half year isn't prevHalfYear
        XCTAssertFalse(model.isNextHalfYear(currentHalfYear: prevHalfYear))
    }
    
    func testIsNextYear() {
        // Set prevDay (i.e. if today is 4/8/2022, set to 3/8/2022)
        let prevDay = Calendar.current.date(byAdding: .month, value: -1, to: .now)!
        
        // Get the current year (current month and past 11 months)
        let thisYear = model.getYear(date: .now)
        
        // Get the year with prevDay's month being the last month
        let prevYear = model.getYear(date: prevDay)
        
        // Assert the next year is thisYear
        XCTAssertTrue(model.isNextYear(currentYear: thisYear))
        
        // Assert the next year isn't prevYear
        XCTAssertFalse(model.isNextYear(currentYear: prevYear))
    }
    
    func testGetWeekText() {
        // Get a date for April 8, 2022
        let components = DateComponents(year: 2022, month: 4, day: 8)
        let testDate = Calendar.current.date(from: components)!
        
        // Get the week for that date
        let testWeek = model.getWeek(date: testDate)
        
        // Set the expected result
        let expected = "Apr 3-9, 2022"
        
        // Assert the functions returns the expected result
        XCTAssertEqual(model.getWeekText(week: testWeek), expected)
    }
    
    func testGetAccessibilityWeekText() {
        // Get a date for April 8, 2022
        let components = DateComponents(year: 2022, month: 4, day: 8)
        let testDate = Calendar.current.date(from: components)!
        
        // Get the week for that date
        let testWeek = model.getWeek(date: testDate)
        
        // Set the expected result
        let expected = "Apr 3rd to 9th, 2022"
        
        // Assert the functions returns the expected result
        XCTAssertEqual(model.getAccessibilityWeekText(week: testWeek), expected)
    }
    
    func testGetDateSuffix() {
        // Set parameters for method
        let test1 = "1"
        let test2 = "2"
        let test3 = "3"
        let test4 = "4"
        let test5 = "21"
        
        // Assert "1" returns "st"
        XCTAssertEqual(model.getDateSuffix(date: test1), "st")
        
        // Assert "2" returns "nd"
        XCTAssertEqual(model.getDateSuffix(date: test2), "nd")
        
        // Assert "3" returns "rd"
        XCTAssertEqual(model.getDateSuffix(date: test3), "rd")
        
        // Assert "4" returns "th"
        XCTAssertEqual(model.getDateSuffix(date: test4), "th")
        
        // Assert "21" returns "st"
        XCTAssertEqual(model.getDateSuffix(date: test5), "st")
        
        // Assert "1" and "21" return the same result ("st")
        XCTAssertEqual(model.getDateSuffix(date: test1), model.getDateSuffix(date: test5))
    }
    
    func testGetHalfYearText() {
        // Get a date for April 8, 2022
        let components = DateComponents(year: 2022, month: 4, day: 8)
        let testDate = Calendar.current.date(from: components)!
        
        // Get a half year
        let halfYear = model.getHalfYear(date: testDate)
        
        // Assert the function returns "Nov 2021 - Apr 2022"
        XCTAssertEqual(model.getHalfYearText(halfYear: halfYear), "Nov 2021 - Apr 2022")
    }
    
    func testGetAccessibilityHalfYearText() {
        // Get a date for April 8, 2022
        let components = DateComponents(year: 2022, month: 4, day: 8)
        let testDate = Calendar.current.date(from: components)!
        
        // Get the half year
        let halfYear = model.getHalfYear(date: testDate)
        
        // Assert the functions returns "Nov 2021 to Apr 2022"
        XCTAssertEqual(model.getAccessibilityHalfYearText(halfYear: halfYear), "Nov 2021 to Apr 2022")
    }

}
