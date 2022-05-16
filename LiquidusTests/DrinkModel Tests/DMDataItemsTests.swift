//
//  DMDataItemsTests.swift
//  LiquidusTests
//
//  Created by Christopher Engelbart on 4/16/22.
//

import XCTest
@testable import Liquidus

class DMDataItemsTests: XCTestCase {
    
    var model: DrinkModel!

    override func setUp() {
        self.model = DrinkModel(test: true, suiteName: nil)
    }
    
    override func tearDown() {
        self.model = nil
    }
    
    func testGetDataItemsForDayTotal() {
        // Add sample drinks for today
        model.drinkData.drinks = SampleDrinks.day(.now)
        
        // Get the expected result
        let expected = self.DataItemsDayExpected(type: Constants.totalType)
        
        // Fetch the function return
        let result = model.getDataItemsForDay(date: .now, type: Constants.totalType)
        
        // Assert at the same index the test and expected arrays return the same value
        for index in 0..<expected.count {
            XCTAssertEqual(result[index], expected[index], "at index \(index)")
        }
    }
    
    func testGetDataItemsForDaySpecific() {
        // Add sample drinks for today
        model.drinkData.drinks = SampleDrinks.day(.now)
        
        // Get the expected result
        let expected = self.DataItemsDayExpected(type: model.drinkData.drinkTypes[0])
        
        // Fetch the function return
        let result = model.getDataItemsForDay(date: .now, type: model.drinkData.drinkTypes[0])
        
        // Assert at the same index the test and expected arrays return the same value
        for index in 0..<expected.count {
            XCTAssertEqual(result[index], expected[index], "at index \(index)")
        }
    }
    
    /**
     Generates the expected results for testGetDataItemsForDayTotal() and testGetDataItemsForDaySingleType()
     */
    private func DataItemsDayExpected(type: DrinkType) -> [DataItem] {
        // Create an empty DataItem array
        var items = [DataItem]()
        
        // Get the current drink type
        let types = model.drinkData.drinkTypes
        
        // Create a date for each hour for today (hour 0, hour 1, hour 2, ..., hour 23)
        let time0 = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: .now)!
        
        let time1 = Calendar.current.date(bySettingHour: 1, minute: 0, second: 0, of: .now)!
        
        let time2 = Calendar.current.date(bySettingHour: 2, minute: 0, second: 0, of: .now)!
        
        let time3 = Calendar.current.date(bySettingHour: 3, minute: 0, second: 0, of: .now)!

        let time4 = Calendar.current.date(bySettingHour: 4, minute: 0, second: 0, of: .now)!
        
        let time5 = Calendar.current.date(bySettingHour: 5, minute: 0, second: 0, of: .now)!
        
        let time6 = Calendar.current.date(bySettingHour: 6, minute: 0, second: 0, of: .now)!
        
        let time7 = Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: .now)!

        let time8 = Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: .now)!
        
        let time9 = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: .now)!
        
        let time10 = Calendar.current.date(bySettingHour: 10, minute: 0, second: 0, of: .now)!
        
        let time11 = Calendar.current.date(bySettingHour: 11, minute: 0, second: 0, of: .now)!
        
        let time12 = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: .now)!
        
        let time13 = Calendar.current.date(bySettingHour: 13, minute: 0, second: 0, of: .now)!
        
        let time14 = Calendar.current.date(bySettingHour: 14, minute: 0, second: 0, of: .now)!
        
        let time15 = Calendar.current.date(bySettingHour: 15, minute: 0, second: 0, of: .now)!
        
        let time16 = Calendar.current.date(bySettingHour: 16, minute: 0, second: 0, of: .now)!
        
        let time17 = Calendar.current.date(bySettingHour: 17, minute: 0, second: 0, of: .now)!
        
        let time18 = Calendar.current.date(bySettingHour: 18, minute: 0, second: 0, of: .now)!
        
        let time19 = Calendar.current.date(bySettingHour: 19, minute: 0, second: 0, of: .now)!
        
        let time20 = Calendar.current.date(bySettingHour: 20, minute: 0, second: 0, of: .now)!

        let time21 = Calendar.current.date(bySettingHour: 21, minute: 0, second: 0, of: .now)!

        let time22 = Calendar.current.date(bySettingHour: 22, minute: 0, second: 0, of: .now)!
        
        let time23 = Calendar.current.date(bySettingHour: 23, minute: 0, second: 0, of: .now)!

        // Arrange timeX variables in an array
        let hours = [
            time0, time1, time2, time3, time4, time5, time6, time7, time8, time9, time10, time11, time12, time13, time14, time15, time16, time17, time18, time19, time20, time21, time22, time23
        ]
        
        // Loop through the hours array
        for index in 0..<hours.count {
            
            // Check for Total Drink Type
            if type == Constants.totalType {
                
                // Append a DataItem based on the current index
                items.append(DataItem(drinks: [Drink(type: types[index % 4], amount: SampleDrinkAmounts.day[index], date: hours[index])], type: type, date: hours[index]))
            
            } else {
                // Check to filter out any drink type than water
                if index % 4 == 0 {
                    items.append(DataItem(drinks: [Drink(type: types[0], amount: SampleDrinkAmounts.day[index], date: hours[index])], type: type, date: hours[index]))

                // If false the append a DataItem with the drink parameter set to nil
                } else {
                    items.append(DataItem(type: type, date: hours[index]))

                }
            }
        }
        
        // Return array
        return items
    }
    
    func testGetDataItemsForWeekTotal() {
        // Get sample drinks for the current week
        model.drinkData.drinks = SampleDrinks.week(model.getWeek(date: .now))
        
        // Get expected result
        let expected = self.DataItemsWeekExpected(type: Constants.totalType)
        
        // Get method return
        let result = model.getDataItemsForWeek(week: model.getWeek(date: .now), type: Constants.totalType)
        
        // Assert at the same index the test and expected arrays return the same value
        for index in 0..<expected.count {
            XCTAssertEqual(result[index], expected[index], "at index \(index)")
        }
    }
    
    func testGetDataItemsForWeekSpecific() {
        // Set sample drinks for current week
        model.drinkData.drinks = SampleDrinks.week(model.getWeek(date: .now))
        
        // Get expected result
        let expected = self.DataItemsWeekExpected(type: model.drinkData.drinkTypes[0])
        
        // Get method return
        let result = model.getDataItemsForWeek(week: model.getWeek(date: .now), type: model.drinkData.drinkTypes[0])
        
        // Assert at the same index the test and expected arrays return the same value
        for index in 0..<expected.count {
            XCTAssertEqual(result[index], expected[index], "at index \(index)")
        }
    }
    
    /**
     Generates the expected results for testGetDataItemsForWeekTotal() and testGetDataItemsForWeekSingleType()
     */
    private func DataItemsWeekExpected(type: DrinkType) -> [DataItem] {
        // Create empty DataItem array
        var items = [DataItem]()
        
        // Get drink types
        let types = model.drinkData.drinkTypes
        
        // Get current week
        let week = model.getWeek(date: .now)
        
        // Loop through the indices of week
        for index in 0..<week.count {
            
            // Check for Total Drink Type
            if type == Constants.totalType {
                
                // Append a DataItem based on the current index
                items.append(DataItem(drinks: [Drink(type: types[index % 4], amount: SampleDrinkAmounts.week[index], date: week[index])], type: type, date: week[index]))
            
            } else {
                // Check to filter out any drink type than Water
                if index % 4 == 0 {
                    
                    // Append a DataItem based on the current index (always Water)
                    items.append(DataItem(drinks: [Drink(type: types[0], amount: SampleDrinkAmounts.week[index], date: week[index])], type: type, date: week[index]))

                // If false the append a DataItem with the drink parameter set to nil
                } else {
                    items.append(DataItem(type: type, date: week[index]))

                }
            }
        }
        
        // Return items array
        return items
    }
    
    func testGetDataItemsForMonthTotal() {
        // Get days in current month
        let month = model.getMonth(day: .now)
        
        // Get sample drinks for the current month
        model.drinkData.drinks = SampleDrinks.month(month)
        
        // Get expected result
        let expected = self.DataItemsMonthExpected(type: Constants.totalType)
        
        // Get method return
        let result = model.getDataItemsForMonth(month: month, type: Constants.totalType)
        
        // Assert at the same index the test and expected arrays return the same value
        for index in 0..<expected.count {
            XCTAssertEqual(result[index], expected[index], "at index \(index)")
        }
    }
    
    func testGetDataItemsForMonthSpecific() {
        // Get days in current month
        let month = model.getMonth(day: .now)
        
        // Get sample drinks for the current month
        model.drinkData.drinks = SampleDrinks.month(month)
        
        // Get expected result
        let expected = self.DataItemsMonthExpected(type: model.drinkData.drinkTypes[0])
        
        // Get method return
        let result = model.getDataItemsForMonth(month: month, type: model.drinkData.drinkTypes[0])
        
        // Assert at the same index the test and expected arrays return the same value
        for index in 0..<expected.count {
            XCTAssertEqual(result[index], expected[index], "at index \(index)")
        }
    }
    
    private func DataItemsMonthExpected(type: DrinkType) -> [DataItem] {
        // Create empty DataItem array
        var items = [DataItem]()
        
        // Get current month
        let month = model.getMonth(day: .now)

        // Get drink types
        let types = model.drinkData.drinkTypes
        
        // Loop through the indices of month
        for index in 0..<month.count {
            
            // Check for Total Drink Type
            if type == Constants.totalType {
                
                // Append a DataItem based on the current index
                items.append(DataItem(drinks: [Drink(type: types[index % 4], amount: SampleDrinkAmounts.month[index], date: month[index])], type: type, date: month[index]))
            
            } else {
                
                // Check to filter out any drink type than Water
                if index % 4 == 0 {
                    
                    // Append a DataItem based on the current index
                    items.append(DataItem(drinks: [Drink(type: types[0], amount: SampleDrinkAmounts.month[index], date: month[index])], type: type, date: month[index]))

                // If false the append a DataItem with the drink parameter set to nil
                } else {
                    items.append(DataItem(type: type, date: month[index]))

                }
            }
        }
        
        // Return items array
        return items
    }
    
    func testGetDataItemsForHalfYearTotal() {
        // Get weeks in current half year (current month is the last month)
        let halfYear = model.getHalfYear(date: .now)
        
        // Get sample drinks for the current half year
        model.drinkData.drinks = SampleDrinks.halfYear(halfYear)
        
        // Get method return
        let result = model.getDataItemsForHalfYear(halfYear: halfYear, type: Constants.totalType)
        
        // Get expected result
        let expected = self.DataItemsHalfYearExpected(type: Constants.totalType)
        
        // Assert at the same index the test and expected arrays return the same value
        for index in 0..<expected.count {
            XCTAssertEqual(result[index], expected[index], "at index \(index)")

        }
    }
    
    func testGetDataItemsForHalfYearSpecific() {
        // Get weeks in current half year (current month is the last month)
        let halfYear = model.getHalfYear(date: .now)
        
        // Get sample drinks for the current half year
        model.drinkData.drinks = SampleDrinks.halfYear(halfYear)
        
        // Get method return
        let result = model.getDataItemsForHalfYear(halfYear: halfYear, type: model.drinkData.drinkTypes.first!)
        
        // Get expected result
        let expected = self.DataItemsHalfYearExpected(type: model.drinkData.drinkTypes.first!)
        
        // Assert at the same index the test and expected arrays return the same value
        for index in 0..<expected.count {
            XCTAssertEqual(result[index], expected[index], "at index \(index)")

        }
    }
    
    private func DataItemsHalfYearExpected(type: DrinkType) -> [DataItem] {
        // Create empty DataItem array
        var items = [DataItem]()
        
        // Get current half year
        let halfYear = model.getHalfYear(date: .now)

        // Get drink types
        let types = model.drinkData.drinkTypes
        
        // Create indices
        var typeIndex = 0
        var amountIndex = 0
        
        // Loop through the weeks in halfYear
        for week in halfYear {
            // Create empty drink array
            var drinks = [Drink]()
            
            // Loop through days in week
            for day in week {
                
                // Check for Total Drink Type
                if type == Constants.totalType {
                    
                    // Append a DataItem based on the current index
                    drinks.append(Drink(type: types[typeIndex % 4], amount: SampleDrinkAmounts.week[amountIndex % 7], date: day))
                
                // Check to filter out any drink type than Water
                } else if typeIndex % 4 == 0 {
                    
                    // Append a DataItem based on the current index
                    drinks.append(Drink(type: types[typeIndex % 4], amount: SampleDrinkAmounts.week[amountIndex % 7], date: day))
                
                }
                
                // Increment indicies
                typeIndex += 1
                amountIndex += 1
            }
            
            // Append a DataItem using the drink array (nil if empty)
            items.append(DataItem(drinks: drinks.isEmpty ? nil : drinks, type: type, date: week[0]))
        }
        
        // Return items array
        return items
    }
    
    func testGetDataItemsForYearTotal() {
        // Get months in current year (current month is the last month)
        let year = model.getYear(date: .now)
        
        // Get sample drinks for the current year
        model.drinkData.drinks = SampleDrinks.year(year)
        
        // Get method return
        let result = model.getDataItemsforYear(year: year, type: Constants.totalType)
        
        // Get expected result
        let expected = self.DataItemsYearExpected(type: Constants.totalType)
        
        // Assert at the same index the test and expected arrays return the same value
        for index in 0..<expected.count {
            XCTAssertEqual(result[index], expected[index])
        }
    }
    
    func testGetDataItemsForYearSpecific() {
        // Get months in current year (current month is the last month)
        let year = model.getYear(date: .now)
        
        // Get sample drinks for the current year
        model.drinkData.drinks = SampleDrinks.year(year)
        
        // Get method return
        let result = model.getDataItemsforYear(year: year, type: model.drinkData.drinkTypes.first!)
        
        // Get expected result
        let expected = self.DataItemsYearExpected(type: model.drinkData.drinkTypes.first!)
        
        // Assert at the same index the test and expected arrays return the same value
        for index in 0..<expected.count {
            XCTAssertEqual(result[index], expected[index])
        }
    }
    
    private func DataItemsYearExpected(type: DrinkType) -> [DataItem] {
        // Get empty DataItem array
        var items = [DataItem]()
        
        // Get current year
        let year = model.getYear(date: .now)
        
        // Get drink types
        let types = model.drinkData.drinkTypes
        
        // Create indices
        var typeIndex = 0
        var amountIndex = 0
        
        // Loop through the months in year
        for month in year {
            
            // Create empty drink array
            var drinks = [Drink]()

            // Loop through days in month
            for day in month {
                
                // Check for Total Drink Type
                if type == Constants.totalType {
                    
                    // Append a DataItem based on the current index
                    drinks.append(Drink(type: types[typeIndex % 4], amount: SampleDrinkAmounts.month[amountIndex], date: day))
                
                // Check to filter out any drink type than Water
                } else if typeIndex % 4 == 0 {
                    
                    // Append a DataItem based on the current index
                    drinks.append(Drink(type: types[typeIndex % 4], amount: SampleDrinkAmounts.month[amountIndex], date: day))

                }
                
                // Increment indicies
                typeIndex += 1
                amountIndex += 1
            }
            
            // Reset amountIndex
            amountIndex = 0
            
            // Append a DataItem using the drink array (nil if empty)
            items.append(DataItem(drinks: drinks.isEmpty ? nil : drinks, type: type, date: month.first!))
        }
        
        // Return items array
        return items
    }
}
