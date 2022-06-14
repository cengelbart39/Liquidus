//
//  DTYearTests.swift
//  LiquidusTests
//
//  Created by Christopher Engelbart on 6/14/22.
//

import XCTest
import CoreData
@testable import Liquidus

class DTYearTests: XCTestCase {

    var context: NSManagedObjectContext!
    
    override func setUp() {
        self.context = PersistenceController.inMemory.container.viewContext
    }
    
    override func tearDown() {
        self.context = nil
    }

    func testFilterDataByYear() {
        let testYear = Year(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
        
        let types = SampleDrinks.year(testYear, context: context)
        
        let result1 = types[0].filterDataByYear(year: testYear).sorted { $0.date < $1.date }
        let expected1 = self.getExpectedFilteredDrinks(order: 0)
        for index in 0..<expected1.count {
            XCTAssertTrue(result1[index] == expected1[index], "failed at index \(index)")
        }
        
        let result2 = types[1].filterDataByYear(year: testYear).sorted { $0.date < $1.date }
        let expected2 = self.getExpectedFilteredDrinks(order: 1)
        for index in 0..<expected2.count {
            XCTAssertTrue(result2[index] == expected2[index], "failed at index \(index)")
        }
        
        let result3 = types[2].filterDataByYear(year: testYear).sorted { $0.date < $1.date }
        let expected3 = self.getExpectedFilteredDrinks(order: 2)
        for index in 0..<expected3.count {
            XCTAssertTrue(result3[index] == expected3[index], "failed at index \(index)")
        }
        
        let result4 = types[3].filterDataByYear(year: testYear).sorted { $0.date < $1.date }
        let expected4 = self.getExpectedFilteredDrinks(order: 3)
        for index in 0..<expected4.count {
            XCTAssertTrue(result4[index] == expected4[index], "failed at index \(index)")
        }
    }
    
    func testGetTypeAmountByYear() {
        let testYear = Year(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
        
        let types = SampleDrinks.year(testYear, context: context)
        
        XCTAssertEqual(types[0].getTypeAmountByYear(year: testYear), 38250)
        
        XCTAssertEqual(types[1].getTypeAmountByYear(year: testYear), 38150)

        XCTAssertEqual(types[2].getTypeAmountByYear(year: testYear), 38300)

        XCTAssertEqual(types[3].getTypeAmountByYear(year: testYear), 38400)
    }
    
    func testGetDataItemsByYear() {
        let testYear = Year(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
        
        let types = SampleDrinks.year(testYear, context: context)
        
        let result1 = types[0].getDataItemsByYear(year: testYear)
        let expected1 = self.getExpectedDataItems(choice: 0)
        
        for index in 0..<expected1.count {
            XCTAssertTrue(result1[index] == expected1[index], "failed at index \(index)")
        }
        
        let result2 = types[1].getDataItemsByYear(year: testYear)
        let expected2 = self.getExpectedDataItems(choice: 1)
        
        for index in 0..<expected2.count {
            XCTAssertEqual(result2[index], expected2[index], "failed at index \(index)")
        }
        
        let result3 = types[2].getDataItemsByYear(year: testYear)
        let expected3 = self.getExpectedDataItems(choice: 2)
        
        for index in 0..<expected3.count {
            XCTAssertEqual(result3[index], expected3[index], "failed at index \(index)")
        }
        
        let result4 = types[3].getDataItemsByYear(year: testYear)
        let expected4 = self.getExpectedDataItems(choice: 3)
        
        for index in 0..<expected4.count {
            XCTAssertEqual(result4[index], expected4[index], "failed at index \(index)")
        }
    }
    
    /**
     Generates the expected results of `testFilterDataByYear()`
     - Parameter order: The `DrinkType` to test for
     - Returns: The appropriate `Drink`s
     */
    private func getExpectedFilteredDrinks(order: Int) -> [Drink] {
        let testYear = Year(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)

        var output = [Drink]()
        
        var drinkType: DrinkType {
            if order == 0 { return SampleDrinkTypes.water(context) }
            if order == 1 { return SampleDrinkTypes.coffee(context) }
            if order == 2 { return SampleDrinkTypes.soda(context) }
            if order == 3 { return SampleDrinkTypes.juice(context) }

            return SampleDrinkTypes.water(context)
        }
        
        var totalCount = 0
        var amountIndex = 0
        
        for month in testYear.data {
            for day in month.data {
                if totalCount % 4 == order {
                    let drink = Drink(context: context)
                    drink.id = UUID()
                    drink.amount = SampleDrinkAmounts.month[amountIndex]
                    drink.date = day
                    drink.type = drinkType
                    
                    drinkType.addToDrinks(drink)
                    
                    output.append(drink)
                }
                
                totalCount += 1
                amountIndex += 1
            }
            
            amountIndex = 0
        }
        
        return output
    }
    
    /**
     Generate the expected `DataItem`s for the months May 2021 to April 2022 for the appropriate `DrinkType`
     - Parameter choice: Which `DrinkType` is being tested for
     - Returns: The appropriate `DataItem`s
     */
    private func getExpectedDataItems(choice: Int) -> [DataItem] {
        let testYear = Year(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)

        var output = [DataItem]()
        
        var drinkType: DrinkType {
            if choice == 0 { return SampleDrinkTypes.water(context) }
            if choice == 1 { return SampleDrinkTypes.coffee(context) }
            if choice == 2 { return SampleDrinkTypes.soda(context) }
            if choice == 3 { return SampleDrinkTypes.juice(context) }

            return SampleDrinkTypes.water(context)
        }
        
        var totalCount = 0
        var amountIndex = 0
        
        for month in testYear.data {
            
            var drinks = [Drink]()
            
            for day in month.data {
                if totalCount % 4 == choice {
                    let drink = Drink(context: context)
                    drink.id = UUID()
                    drink.amount = SampleDrinkAmounts.month[amountIndex]
                    drink.date = day
                    drink.type = drinkType
                    
                    drinkType.addToDrinks(drink)
                
                    drinks.append(drink)
                }
                
                totalCount += 1
                amountIndex += 1
            }
            
            amountIndex = 0
            
            output.append(DataItem(drinks: drinks, type: drinkType, total: false, date: month.firstDay()))
        }
        
        return output
    }

}
