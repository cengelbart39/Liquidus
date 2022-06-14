//
//  DTWeekTests.swift
//  LiquidusTests
//
//  Created by Christopher Engelbart on 6/13/22.
//

import XCTest
import CoreData
@testable import Liquidus

class DTWeekTests: XCTestCase {

    var context: NSManagedObjectContext!
    
    override func setUp() {
        self.context = PersistenceController.inMemory.container.viewContext
    }
    
    override func tearDown() {
        self.context = nil
    }
    
    func testFilterDataByWeek() {
        let testDay = Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!
        
        let testWeek = Week(date: testDay)
        
        let types = SampleDrinks.week(testWeek, context: context)
        
        let result1 = types[0].filterDataByWeek(week: testWeek)
        let expected1 = self.getExpectedFilteredDrinks(order: 0)
        for index in 0..<expected1.count {
            XCTAssertTrue(result1[index] == expected1[index], "failed at index \(index)")
        }
        
        let result2 = types[1].filterDataByWeek(week: testWeek)
        let expected2 = self.getExpectedFilteredDrinks(order: 1)
        for index in 0..<expected2.count {
            XCTAssertTrue(result2[index] == expected2[index], "failed at index \(index)")
        }
        
        let result3 = types[2].filterDataByWeek(week: testWeek)
        let expected3 = self.getExpectedFilteredDrinks(order: 2)
        for index in 0..<expected3.count {
            XCTAssertTrue(result3[index] == expected3[index], "failed at index \(index)")
        }
        
        let result4 = types[3].filterDataByWeek(week: testWeek)
        let expected4 = self.getExpectedFilteredDrinks(order: 3)
        for index in 0..<expected4.count {
            XCTAssertTrue(result4[index] == expected4[index], "failed at index \(index)")
        }
    }
    
    func testGetTypeAmountByWeek() {
        let testWeek = Week()
        
        let types = SampleDrinks.week(testWeek, context: context)
        
        XCTAssertEqual(types[0].getTypeAmountByWeek(week: testWeek), 400)
        
        XCTAssertEqual(types[1].getTypeAmountByWeek(week: testWeek), 400)

        XCTAssertEqual(types[2].getTypeAmountByWeek(week: testWeek), 400)

        XCTAssertEqual(types[3].getTypeAmountByWeek(week: testWeek), 400)
    }
    
    func testGetDataItemsByWeek() {
        let testWeek = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
        
        let types = SampleDrinks.week(testWeek, context: context)
        
        let result1 = types[0].getDataItemsByWeek(week: testWeek)
        let expected1 = self.getExpectedDataItems(choice: 0)
        
        for index in 0..<expected1.count {
            XCTAssertTrue(result1[index] == expected1[index], "failed at index \(index)")
        }
        
        let result2 = types[1].getDataItemsByWeek(week: testWeek)
        let expected2 = self.getExpectedDataItems(choice: 1)
        
        for index in 0..<expected2.count {
            XCTAssertEqual(result2[index], expected2[index], "failed at index \(index)")
        }
        
        let result3 = types[2].getDataItemsByWeek(week: testWeek)
        let expected3 = self.getExpectedDataItems(choice: 2)
        
        for index in 0..<expected3.count {
            XCTAssertEqual(result3[index], expected3[index], "failed at index \(index)")
        }
        
        let result4 = types[3].getDataItemsByWeek(week: testWeek)
        let expected4 = self.getExpectedDataItems(choice: 3)
        
        for index in 0..<expected4.count {
            XCTAssertEqual(result4[index], expected4[index], "failed at index \(index)")
        }
    }
    
    /**
     Generates the expected results of `testFilterDataByWeek()`
     - Parameter order: The `DrinkType` to test for
     - Returns: The appropriate `Drink`s
     */
    private func getExpectedFilteredDrinks(order: Int) -> [Drink] {
        let week = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
        
        if order == 0 {
            let water = SampleDrinkTypes.water(context)
            
            let sun = Drink(context: context)
            sun.id = UUID()
            sun.amount = 100
            sun.date = week.data[0]
            sun.type = water
            water.addToDrinks(sun)
            
            let thu = Drink(context: context)
            thu.id = UUID()
            thu.amount = 300
            thu.date = week.data[4]
            thu.type = water
            water.addToDrinks(thu)
            
            return [sun, thu]
        
        } else if order == 1 {
            let coffee = SampleDrinkTypes.coffee(context)
            
            let mon = Drink(context: context)
            mon.id = UUID()
            mon.amount = 200
            mon.date = week.data[1]
            mon.type = coffee
            coffee.addToDrinks(mon)
            
            let fri = Drink(context: context)
            fri.id = UUID()
            fri.amount = 200
            fri.date = week.data[5]
            fri.type = coffee
            coffee.addToDrinks(fri)
            
            return [mon, fri]
        
        } else if order == 2 {
            let soda = SampleDrinkTypes.soda(context)
            
            let tue = Drink(context: context)
            tue.id = UUID()
            tue.amount = 300
            tue.date = week.data[2]
            tue.type = soda
            soda.addToDrinks(tue)
            
            let sat = Drink(context: context)
            sat.id = UUID()
            sat.amount = 100
            sat.date = week.data[6]
            sat.type = soda
            soda.addToDrinks(sat)
            
            return [tue, sat]
        
        } else if order == 3 {
            let juice = SampleDrinkTypes.juice(context)
            
            let wed = Drink(context: context)
            wed.id = UUID()
            wed.amount = 400
            wed.date = week.data[3]
            wed.type = juice
            juice.addToDrinks(wed)
            
            return [wed]
        }
        
        return [Drink]()
    }
    
    /**
     Generate the expected `DataItem`s for the week April 3-9, 2022 for the appropriate `DrinkType`
     - Parameter choice: Which `DrinkType` is being tested for
     - Returns: The appropriate `DataItem`s
     */
    private func getExpectedDataItems(choice: Int) -> [DataItem] {
        
        let testWeek = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)

        var output = [DataItem]()
        
        var drinkType: DrinkType {
            if choice == 0 { return SampleDrinkTypes.water(context) }
            if choice == 1 { return SampleDrinkTypes.coffee(context) }
            if choice == 2 { return SampleDrinkTypes.soda(context) }
            if choice == 3 { return SampleDrinkTypes.juice(context) }

            return SampleDrinkTypes.water(context)
        }
        
        for index in 0..<7 {
            if index % 4 == choice {
                let drink = Drink(context: context)
                drink.id = UUID()
                drink.amount = SampleDrinkAmounts.week[index]
                drink.date = testWeek.data[index]
                drink.type = drinkType
                
                drinkType.addToDrinks(drink)
                
                output.append(DataItem(drinks: [drink], type: drinkType, total: false, date: testWeek.data[index]))
            
            } else {
                output.append(DataItem(drinks: nil, type: drinkType, total: false, date: testWeek.data[index]))
            }
            
        }
        
        return output
    }
}
