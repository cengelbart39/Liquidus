//
//  DMDataByHalfYearTests.swift
//  LiquidusTests
//
//  Created by Christopher Engelbart on 5/2/22.
//

import XCTest
@testable import Liquidus

class DMDataByHalfYearTests: XCTestCase {

    var model: DrinkModel!
    
    override func setUp() {
        self.model = DrinkModel(test: true, suiteName: nil)
    }
    
    override func tearDown() {
        self.model = nil
    }

    // Also tests getWeeksForHalfYear() as their outputs are the same
    func testGetHalfYear() {
        // Create a date for April 8, 2022
        let testDate = Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!
        
        // Get the method return
        let result = HalfYear(date: testDate)
        
        // Set the expected result
        let expected = halfYearFromApril2022()
        
        // Loop through expected
        for i1 in 0..<expected.count {
            
            // Loop through expected[i1]
            for i2 in 0..<expected[i1].data.count {
                
                // Assert at the same [i1][i2] the result and expected arrays return the same value
                XCTAssertEqual(result.data[i1].data[i2], expected[i1].data[i2], "at i1 \(i1), i2 \(i2)")
            }
        }
    }
    
    func testFilterByHalfYear() {
        // Create a date for April 8, 2022
        let testDate = Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!

        // Get the half year for November 2021 to April 2022
        let testHalfYear = HalfYear(date: testDate)
        
        // Assert the method returns an empty array
        XCTAssertTrue(model.filterDataByHalfYear(halfYear: testHalfYear).isEmpty)

        // Get the half year for May 2021 to October 2021
        let prev6Months = HalfYear(date: Calendar.current.date(from: DateComponents(year: 2021, month: 10, day: 1))!)

        // Add sample drinks for for May 2021 to October 2022
        model.drinkData.drinks = SampleDrinks.halfYear(prev6Months)

        // Assert the method returns an empty array
        XCTAssertTrue(model.filterDataByHalfYear(halfYear: testHalfYear).isEmpty)
        
        // Add sample drinks for for November 2021 to April 2022
        model.drinkData.drinks = SampleDrinks.halfYear(testHalfYear)
        
        // Fetch the method results for November 2021 to April 2022
        let result = model.filterDataByHalfYear(halfYear: testHalfYear)
        
        // Get the expected drinks
        let expected = allDrinksFromApril2022()
        
        // Assert at the same index the test and expected arrays return the same value
        for index in 0..<expected.count {
            XCTAssertEqual(result[index], expected[index])
        }
    }
    
    func testFilterByHalfYearAndType() {
        // Create a date for April 8, 2022
        let testDate = Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!

        // Get the half year for November 2021 to April 2022
        let testHalfYear = HalfYear(date: testDate)
        
        // Assert the method returns an empty array
        XCTAssertTrue(model.filterDataByHalfYearAndType(type: model.drinkData.drinkTypes.first!, halfYear: testHalfYear).isEmpty)

        // Get the half year for May 2021 to October 2021
        let prev6Months = HalfYear(date: Calendar.current.date(from: DateComponents(year: 2021, month: 10, day: 1))!)

        // Add sample drinks for for May 2021 to October 2022
        model.drinkData.drinks = SampleDrinks.halfYear(prev6Months)

        // Assert the method returns an empty array
        XCTAssertTrue(model.filterDataByHalfYearAndType(type: model.drinkData.drinkTypes.first!, halfYear: testHalfYear).isEmpty)

        // Add sample drinks for for November 2021 to April 2022
        model.drinkData.drinks = SampleDrinks.halfYear(testHalfYear)
        
        // Fetch the method results for November 2021 to April 2022
        let result = model.filterDataByHalfYearAndType(type: model.drinkData.drinkTypes.first!, halfYear: testHalfYear)
        
        // Get the expected drinks
        let expected = allDrinksFromApril2022().filter { $0.type == model.drinkData.drinkTypes.first! }
        
        // Assert at the same index the test and expected arrays return the same value
        for index in 0..<expected.count {
            XCTAssertEqual(result[index], expected[index])
        }
    }
    
    func testGetTypeAmountByHalfYear() {
        // Create a date for April 8, 2022
        let testDate = Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!

        // Get the half year for November 2021 to April 2022
        let testHalfYear = HalfYear(date: testDate)
        
        // Assert the method returns 0.0
        XCTAssertEqual(model.getTypeAmountByHalfYear(type: model.drinkData.drinkTypes.first!, halfYear: testHalfYear), 0.0)

        // Get the half year for May 2021 to October 2021
        let prev6Months = HalfYear(date: Calendar.current.date(from: DateComponents(year: 2021, month: 10, day: 1))!)

        // Add sample drinks for for May 2021 to October 2022
        model.drinkData.drinks = SampleDrinks.halfYear(prev6Months)

        // Assert the method returns 0.0
        XCTAssertEqual(model.getTypeAmountByHalfYear(type: model.drinkData.drinkTypes.first!, halfYear: testHalfYear), 0.0)

        // Add sample drinks for for November 2021 to April 2022
        model.drinkData.drinks = SampleDrinks.halfYear(testHalfYear)
        
        // Fetch the method results for November 2021 to April 2022 and for Water and Coffee
        let result1 = model.getTypeAmountByHalfYear(type: model.drinkData.drinkTypes.first!, halfYear: testHalfYear)
        
        let result2 = model.getTypeAmountByHalfYear(type: model.drinkData.drinkTypes[1], halfYear: testHalfYear)

        // Assert result1 is 10,400
        XCTAssertEqual(result1, 10400)
        
        // Assert result2 is not 10,400
        XCTAssertNotEqual(result2, 10400)
    }

    /**
     Returns an array with the weeks in November 2021 to April 2022, cutting off any extraneous dates in October 2021 or May 2022
     */
    private func halfYearFromApril2022() -> [Week] {
        let w1 = Week(date: Calendar.current.date(from: DateComponents(year: 2021, month: 11, day: 1))!)
        w1.data.removeFirst()
        
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
    
    /**
     Generate the expected drinks for April 2022 ignoring drink type
     */
    private func allDrinksFromApril2022() -> [Drink] {
        // Get the half year from November 2021 to April 2022
        let halfYear = self.halfYearFromApril2022()
       
        // Create an empty drink array
        var drinks = [Drink]()
        
        // Set the drink amounts
        let amounts: [Double] = [100, 200, 300, 400, 300, 200, 100]
        
        // Get the drink types
        let types = DrinkType.getDefault()
        
        // Create typeIndex and amountIndex
        var typeIndex = 0
        var amountIndex = 0
        
        // Loop through weeks in halfYear
        for week in halfYear {
            
            // Loop through day in week
            for day in week.data {
                
                // Append and create a drink using typeIndex, amountIndex, and day
                drinks.append(Drink(type: types[typeIndex % 4], amount: amounts[amountIndex % 7], date: day.data))
                
                // Increment indices
                typeIndex += 1
                amountIndex += 1
            }
        }
        
        // Return drinks
        return drinks
    }
}
