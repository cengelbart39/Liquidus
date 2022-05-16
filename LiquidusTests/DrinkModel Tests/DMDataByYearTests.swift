//
//  DMDataByYearTests.swift
//  LiquidusTests
//
//  Created by Christopher Engelbart on 5/3/22.
//

import XCTest
@testable import Liquidus

class DMDataByYearTests: XCTestCase {

    var model: DrinkModel!
    
    override func setUp() {
        self.model = DrinkModel(test: true, suiteName: nil)
    }
    
    override func tearDown() {
        self.model = nil
    }

    func testGetYear() {
        // Create a date for April 8, 2022
        let testDate = Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!
        
        // Fetch the returned year
        let result = model.getYear(date: testDate)
        
        // Get the expected year
        let expected = self.getExpectedYear()
        
        // Loop through expected
        for i1 in 0..<expected.count {
            
            // Loop through expected[i1]
            for i2 in 0..<expected[i1].count {
                
                // Assert at the same [i1][i2] the result and expected arrays return the same value
                XCTAssertTrue(result[i1][i2].compare(expected[i1][i2]) == .orderedSame, "at i1 \(i1), i2 \(i2)")
            }
        }
    }
    
    func testFilterByYear() {
        // Get 12 months from May 2021 to April 2022
        let testYear = model.getYear(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
        
        // Assert the method returns an empty array
        XCTAssertEqual(model.filterDataByYear(year: testYear), [])
        
        // Get 12 months from May 2020 to April 2021
        let lastYear = model.getYear(date: Calendar.current.date(from: DateComponents(year: 2021, month: 4, day: 8))!)
        
        // Add sample drinks from May 2020 to April 2021
        model.drinkData.drinks = SampleDrinks.year(lastYear)
        
        // Assert the method returns an empty array
        XCTAssertEqual(model.filterDataByYear(year: testYear), [])

        // Add sample drinks from May 2021 to April 2022
        model.drinkData.drinks = SampleDrinks.year(testYear)
        
        // Fetch the method results for May 2021 to April 2022
        let result = model.filterDataByYear(year: testYear)
        
        // Get the expected drinks
        let expected = self.getExpectedDrinks()
        
        // Assert at the same index the test and expected arrays return the same value
        for index in 0..<expected.count {
            XCTAssertEqual(result[index], expected[index], "at index \(index)")
        }
    }
    
    func testFilterByYearAndType() {
        // Get 12 months from May 2021 to April 2022
        let testYear = model.getYear(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
        
        // Assert the method returns an empty array
        XCTAssertEqual(model.filterDataByYearAndType(type: model.drinkData.drinkTypes.first!, year: testYear), [])
        
        // Get 12 months from May 2020 to April 2021
        let lastYear = model.getYear(date: Calendar.current.date(from: DateComponents(year: 2021, month: 4, day: 8))!)
        
        // Add sample drinks from May 2020 to April 2021
        model.drinkData.drinks = SampleDrinks.year(lastYear)
        
        // Assert the method returns an empty array
        XCTAssertEqual(model.filterDataByYearAndType(type: model.drinkData.drinkTypes.first!, year: testYear), [])

        // Add sample drinks from May 2021 to April 2022
        model.drinkData.drinks = SampleDrinks.year(testYear)
        
        // Fetch the method results for May 2021 to April 2022
        let result = model.filterDataByYearAndType(type: model.drinkData.drinkTypes.first!, year: testYear)
        
        // Get the expected drinks
        let expected = self.getExpectedDrinks().filter { $0.type == model.drinkData.drinkTypes.first}
        
        // Assert at the same index the test and expected arrays return the same value
        for index in 0..<expected.count {
            XCTAssertEqual(result[index], expected[index], "at index \(index)")
        }
    }
    
    func testGetTypeAmountByYear() {
        // Get 12 months from May 2021 to April 2022
        let testYear = model.getYear(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
        
        // Assert the method returns 0.0
        XCTAssertEqual(model.getTypeAmountByYear(type: model.drinkData.drinkTypes.first!, year: testYear), 0.0)
        
        // Get 12 months from May 2020 to April 2021
        let lastYear = model.getYear(date: Calendar.current.date(from: DateComponents(year: 2021, month: 4, day: 8))!)
        
        // Add sample drinks from May 2020 to April 2021
        model.drinkData.drinks = SampleDrinks.year(lastYear)
        
        // Assert the method returns 0.0
        XCTAssertEqual(model.getTypeAmountByYear(type: model.drinkData.drinkTypes.first!, year: testYear), 0.0)

        // Add sample drinks from May 2021 to April 2022
        model.drinkData.drinks = SampleDrinks.year(testYear)
        
        // Fetch the method results for May 2021 to April 2022
        let result = model.getTypeAmountByYear(type: model.drinkData.drinkTypes.first!, year: testYear)

        // Assert the fetched result is 38,250
        XCTAssertEqual(result, 38250)
    }
    
    /**
     Returns a 2D array with the months in May 2021 to April 2022
     */
    private func getExpectedYear() -> [[Date]] {
        // Get the days in the following months
        let may21 = model.getMonth(day: Calendar.current.date(from: DateComponents(year: 2021, month: 5, day: 1))!)
        
        let jun21 = model.getMonth(day: Calendar.current.date(from: DateComponents(year: 2021, month: 6, day: 1))!)
        
        let jul21 = model.getMonth(day: Calendar.current.date(from: DateComponents(year: 2021, month: 7, day: 1))!)
        
        let aug21 = model.getMonth(day: Calendar.current.date(from: DateComponents(year: 2021, month: 8, day: 1))!)
        
        let sep21 = model.getMonth(day: Calendar.current.date(from: DateComponents(year: 2021, month: 9, day: 1))!)
        
        let oct21 = model.getMonth(day: Calendar.current.date(from: DateComponents(year: 2021, month: 10, day: 1))!)
        
        let nov21 = model.getMonth(day: Calendar.current.date(from: DateComponents(year: 2021, month: 11, day: 1))!)
        
        let dec21 = model.getMonth(day: Calendar.current.date(from: DateComponents(year: 2021, month: 12, day: 1))!)
        
        let jan22 = model.getMonth(day: Calendar.current.date(from: DateComponents(year: 2022, month: 1, day: 1))!)
        
        let feb22 = model.getMonth(day: Calendar.current.date(from: DateComponents(year: 2022, month: 2, day: 1))!)
        
        let mar22 = model.getMonth(day: Calendar.current.date(from: DateComponents(year: 2022, month: 3, day: 1))!)
        
        let apr22 = model.getMonth(day: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 1))!)
        
        return [may21, jun21, jul21, aug21, sep21, oct21, nov21, dec21, jan22, feb22, mar22, apr22]
    }
    
    /**
     Generate the expected drinks from May 2021 to April 2022, regardless of type
     */
    private func getExpectedDrinks() -> [Drink] {
        // Get 12 months from May 2021 to April 2022
        let year = model.getYear(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
        
        // Create an empty drink array
        var drinks = [Drink]()
        
        // Get the drink types
        let types = model.drinkData.drinkTypes
        
        // Create type and amount indices
        var typeIndex = 0
        var amountIndex = 0
        
        // Loop through months in year
        for month in year {
            
            // Loop through day in month
            for day in month {
                
                // Create a drink using the values of typeIndex, amountIndex, and day
                drinks.append(Drink(type: types[typeIndex % 4], amount: SampleDrinkAmounts.month[amountIndex], date: day))
                
                // Increment indicies
                typeIndex += 1
                amountIndex += 1
            }
            
            // Reset amount index
            amountIndex = 0
        }
        
        // Return drink array
        return drinks
    }
}
