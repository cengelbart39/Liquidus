//
//  DTDayTests.swift
//  LiquidusTests
//
//  Created by Christopher Engelbart on 6/13/22.
//

import XCTest
import CoreData
@testable import Liquidus

class DTDayTests: XCTestCase {

    var context: NSManagedObjectContext!
    
    override func setUp() {
        self.context = PersistenceController.inMemory.container.viewContext
    }
    
    override func tearDown() {
        self.context = nil
    }
    
    func testFilterDataByDay() {
        let testDay = Day(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
        
        let types = SampleDrinks.week(Week(date: testDay.data), context: context)
        
        let expectedDrink = Drink(context: context)
        expectedDrink.id = UUID()
        expectedDrink.amount = 200
        expectedDrink.date = testDay.data
        expectedDrink.type = SampleDrinkTypes.coffee(context)
        
        expectedDrink.type.addToDrinks(expectedDrink)
        
        XCTAssertEqual(types[0].filterDataByDay(day: testDay), [])
        
        XCTAssertTrue(types[1].filterDataByDay(day: testDay)[0] == expectedDrink)

        XCTAssertEqual(types[2].filterDataByDay(day: testDay), [])

        XCTAssertEqual(types[3].filterDataByDay(day: testDay), [])
    }
    
    func testGetTypeAmountByDay() {
        let testDay = Day(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
        
        let types = SampleDrinks.week(Week(date: testDay.data), context: context)
        
        XCTAssertEqual(types[0].getTypeAmountByDay(day: testDay), 0)
        
        XCTAssertEqual(types[1].getTypeAmountByDay(day: testDay), 200)

        XCTAssertEqual(types[2].getTypeAmountByDay(day: testDay), 0)

        XCTAssertEqual(types[3].getTypeAmountByDay(day: testDay), 0)
    }
    
    func testGetTypePercentByDay() {
        let testDay = Day(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
        
        let types = SampleDrinks.week(Week(date: testDay.data), context: context)
        
        XCTAssertEqual(types[0].getTypePercentByDay(day: testDay, goal: 2000), 0)
        
        XCTAssertEqual(types[1].getTypePercentByDay(day: testDay, goal: 2000), 0.1)

        XCTAssertEqual(types[2].getTypePercentByDay(day: testDay, goal: 2000), 0)

        XCTAssertEqual(types[3].getTypePercentByDay(day: testDay, goal: 2000), 0)
    }
    
    func testGetDataItemsByDay() {
        let testDay = Day(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
        
        let types = SampleDrinks.day(testDay, context: context)
        
        // Water Test
        let result1 = types[0].getDataItemsByDay(day: testDay)
        let expected1 = self.getExpectedDataItems(choice: 0)
        
        for index in 0..<expected1.count {
            XCTAssertEqual(result1[index], expected1[index], "failed at index \(index)")
        }
        
        // Coffee Test
        let result2 = types[1].getDataItemsByDay(day: testDay)
        let expected2 = self.getExpectedDataItems(choice: 1)
        
        for index in 0..<expected2.count {
            XCTAssertEqual(result2[index], expected2[index], "failed at index \(index)")
        }
        
        // Soda Test
        let result3 = types[2].getDataItemsByDay(day: testDay)
        let expected3 = self.getExpectedDataItems(choice: 2)
        
        for index in 0..<expected3.count {
            XCTAssertEqual(result3[index], expected3[index], "failed at index \(index)")
        }
        
        // Juice Test
        let result4 = types[3].getDataItemsByDay(day: testDay)
        let expected4 = self.getExpectedDataItems(choice: 3)
        
        for index in 0..<expected4.count {
            XCTAssertEqual(result4[index], expected4[index], "failed at index \(index)")
        }
    }
    
    /**
     Generate the expected `DataItem`s for April 8, 2022 for the appropriate `DrinkType`
     - Parameter choice: Which `DrinkType` is being tested for
     - Returns: The appropriate `DataItem`s
     */
    private func getExpectedDataItems(choice: Int) -> [DataItem] {
        
        let testDate = Day(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)

        let hours = testDate.getHours()
        
        var output = [DataItem]()
        
        var drinkType: DrinkType {
            if choice == 0 { return SampleDrinkTypes.water(context) }
            if choice == 1 { return SampleDrinkTypes.coffee(context) }
            if choice == 2 { return SampleDrinkTypes.soda(context) }
            if choice == 3 { return SampleDrinkTypes.juice(context) }

            return SampleDrinkTypes.water(context)
        }
        
        for index in 0..<23 {
            if index % 4 == choice {
                let drink = Drink(context: context)
                drink.id = UUID()
                drink.amount = SampleDrinkAmounts.day[index]
                drink.date = hours[index].data
                drink.type = drinkType
                
                drinkType.addToDrinks(drink)
                
                output.append(DataItem(drinks: [drink], type: drinkType, total: false, date: hours[index].data))
            
            } else {
                output.append(DataItem(drinks: nil, type: drinkType, total: false, date: hours[index].data))
            }
            
        }
        
        return output
    }
}
