//
//  DTMonthTests.swift
//  LiquidusTests
//
//  Created by Christopher Engelbart on 6/14/22.
//

import XCTest
import CoreData
@testable import Liquidus

class DTMonthTests: XCTestCase {

    var context: NSManagedObjectContext!
    
    override func setUp() {
        self.context = PersistenceController.inMemory.container.viewContext
    }
    
    override func tearDown() {
        self.context = nil
    }

    func testFilterDataByMonth() {
        let testMonth = Month(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
        
        let types = SampleDrinks.month(testMonth, context: context)
        
        let result1 = types[0].filterDataByMonth(month: testMonth).sorted { $0.date < $1.date }
        let expected1 = self.getExpectedFilteredDrinks(order: 0)
        for index in 0..<expected1.count {
            XCTAssertTrue(result1[index] == expected1[index], "failed at index \(index)")
        }
        
        let result2 = types[1].filterDataByMonth(month: testMonth).sorted { $0.date < $1.date }
        let expected2 = self.getExpectedFilteredDrinks(order: 1)
        for index in 0..<expected2.count {
            XCTAssertTrue(result2[index] == expected2[index], "failed at index \(index)")
        }
        
        let result3 = types[2].filterDataByMonth(month: testMonth).sorted { $0.date < $1.date }
        let expected3 = self.getExpectedFilteredDrinks(order: 2)
        for index in 0..<expected3.count {
            XCTAssertTrue(result3[index] == expected3[index], "failed at index \(index)")
        }
        
        let result4 = types[3].filterDataByMonth(month: testMonth).sorted { $0.date < $1.date }
        let expected4 = self.getExpectedFilteredDrinks(order: 3)
        for index in 0..<expected4.count {
            XCTAssertTrue(result4[index] == expected4[index], "failed at index \(index)")
        }
    }
    
    func testGetTypeAmountByMonth() {
        let testMonth = Month(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
        
        let types = SampleDrinks.month(testMonth, context: context)
        
        XCTAssertEqual(types[0].getTypeAmountByMonth(month: testMonth), 3200)
        
        XCTAssertEqual(types[1].getTypeAmountByMonth(month: testMonth), 3200)

        XCTAssertEqual(types[2].getTypeAmountByMonth(month: testMonth), 3150)

        XCTAssertEqual(types[3].getTypeAmountByMonth(month: testMonth), 3200)
    }
    
    func testGetDataItemsByMonth() {
        let testMonth = Month(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
        
        let types = SampleDrinks.month(testMonth, context: context)
        
        let result1 = types[0].getDataItemsByMonth(month: testMonth)
        let expected1 = self.getExpectedDataItems(choice: 0)
        
        for index in 0..<expected1.count {
            XCTAssertTrue(result1[index] == expected1[index], "failed at index \(index)")
        }
        
        let result2 = types[1].getDataItemsByMonth(month: testMonth)
        let expected2 = self.getExpectedDataItems(choice: 1)
        
        for index in 0..<expected2.count {
            XCTAssertEqual(result2[index], expected2[index], "failed at index \(index)")
        }
        
        let result3 = types[2].getDataItemsByMonth(month: testMonth)
        let expected3 = self.getExpectedDataItems(choice: 2)
        
        for index in 0..<expected3.count {
            XCTAssertEqual(result3[index], expected3[index], "failed at index \(index)")
        }
        
        let result4 = types[3].getDataItemsByMonth(month: testMonth)
        let expected4 = self.getExpectedDataItems(choice: 3)
        
        for index in 0..<expected4.count {
            XCTAssertEqual(result4[index], expected4[index], "failed at index \(index)")
        }
    }
    
    /**
     Generates the expected results of `testFilterDataByMonth()`
     - Parameter order: The `DrinkType` to test for
     - Returns: The appropriate `Drink`s
     */
    private func getExpectedFilteredDrinks(order: Int) -> [Drink] {
        var drinks = [Drink]()
        
        if order == 0 {
            let water = SampleDrinkTypes.water(context)
            
            let dates = [
                Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 1))!,
                Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 5))!,
                Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 9))!,
                Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 13))!,
                Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 17))!,
                Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 21))!,
                Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 25))!,
                Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 29))!
            ]
            
            let amounts: [Double] = [50, 250, 450, 650, 750, 550, 350, 150]
                        
            for index in 0..<dates.count {
                let drink = Drink(context: context)
                drink.id = UUID()
                drink.amount = amounts[index]
                drink.date = dates[index]
                drink.type = water
                water.addToDrinks(drink)
                
                drinks.append(drink)
            }
            
            return drinks
            
        } else if order == 1 {
            let coffee = SampleDrinkTypes.coffee(context)
            
            let dates = [
                Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 2))!,
                Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 6))!,
                Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 10))!,
                Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 14))!,
                Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 18))!,
                Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 22))!,
                Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 26))!,
                Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 30))!
            ]
            
            let amounts: [Double] = [100, 300, 500, 700, 700, 500, 300, 100]
                        
            for index in 0..<dates.count {
                let drink = Drink(context: context)
                drink.id = UUID()
                drink.amount = amounts[index]
                drink.date = dates[index]
                drink.type = coffee
                coffee.addToDrinks(drink)
                
                drinks.append(drink)
            }
            
        } else if order == 2 {
            let soda = SampleDrinkTypes.soda(context)
            
            let dates = [
                Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 3))!,
                Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 7))!,
                Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 11))!,
                Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 15))!,
                Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 19))!,
                Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 23))!,
                Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 27))!
            ]
            
            let amounts: [Double] = [150, 350, 550, 750, 650, 450, 250]
                        
            for index in 0..<dates.count {
                let drink = Drink(context: context)
                drink.id = UUID()
                drink.amount = amounts[index]
                drink.date = dates[index]
                drink.type = soda
                soda.addToDrinks(drink)
                
                drinks.append(drink)
            }
            
        } else if order == 3 {
            let juice = SampleDrinkTypes.juice(context)

            let dates = [
                Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 4))!,
                Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!,
                Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 12))!,
                Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 16))!,
                Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 20))!,
                Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 24))!,
                Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 28))!
            ]
            
            let amounts: [Double] = [200, 400, 600, 800, 600, 400, 200]
                        
            for index in 0..<dates.count {
                let drink = Drink(context: context)
                drink.id = UUID()
                drink.amount = amounts[index]
                drink.date = dates[index]
                drink.type = juice
                juice.addToDrinks(drink)
                
                drinks.append(drink)
            }
        }
        
        return drinks
    }
    
    /**
     Generate the expected `DataItem`s for the month of April 2022 for the appropriate `DrinkType`
     - Parameter choice: Which `DrinkType` is being tested for
     - Returns: The appropriate `DataItem`s
     */
    private func getExpectedDataItems(choice: Int) -> [DataItem] {
        
        let testMonth = Month(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)

        var output = [DataItem]()
        
        var drinkType: DrinkType {
            if choice == 0 { return SampleDrinkTypes.water(context) }
            if choice == 1 { return SampleDrinkTypes.coffee(context) }
            if choice == 2 { return SampleDrinkTypes.soda(context) }
            if choice == 3 { return SampleDrinkTypes.juice(context) }

            return SampleDrinkTypes.water(context)
        }
        
        for index in 0..<testMonth.data.count {
            if index % 4 == choice {
                let drink = Drink(context: context)
                drink.id = UUID()
                drink.amount = SampleDrinkAmounts.month[index]
                drink.date = testMonth.data[index]
                drink.type = drinkType
                
                drinkType.addToDrinks(drink)
                
                output.append(DataItem(drinks: [drink], type: drinkType, total: false, date: testMonth.data[index]))
            
            } else {
                output.append(DataItem(drinks: nil, type: drinkType, total: false, date: testMonth.data[index]))
            }
            
        }
        
        return output
    }
}
