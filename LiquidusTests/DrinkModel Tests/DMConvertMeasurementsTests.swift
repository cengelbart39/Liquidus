//
//  DMConvertMeasurementsTests.swift
//  LiquidusTests
//
//  Created by Christopher Engelbart on 4/30/22.
//

import XCTest
import CoreData

@testable import Liquidus

class DMConvertMeasurementsTests: XCTestCase {

    var context: NSManagedObjectContext!
    
    var model: DrinkModel!
    
    override func setUp() {
        self.context = PersistenceController.inMemory.container.viewContext
        self.model = DrinkModel(test: true, suiteName: nil)
    }
    
    override func tearDown() {
        self.context = nil
        self.model = nil
    }

    func testMillilitersToLiters() {
        // Set units to mL
        model.userInfo.units = Constants.milliliters

        // Add sample drinks to drink store
        let week = Week()
        let types = SampleDrinks.week(week, context: context)

        var currentDrinks = [Drink]()

        for type in types {
            if let drinks = type.drinks?.allObjects as? [Drink] {
                currentDrinks += drinks
            }
        }

        currentDrinks = currentDrinks.sorted(by: { d1, d2 in
            d1.date < d2.date
        })

        model.convertMeasurements(pastUnit: model.userInfo.units, newUnit: Constants.liters, drinks: currentDrinks)

        let result = currentDrinks.sorted(by: { d1, d2 in
            d1.date < d2.date
        })
        
        // Set expected amount conversions
        let amounts = [
            Measurement(value: 100, unit: UnitVolume.milliliters).converted(to: UnitVolume.liters).value,
            Measurement(value: 200, unit: UnitVolume.milliliters).converted(to: UnitVolume.liters).value,
            Measurement(value: 300, unit: UnitVolume.milliliters).converted(to: UnitVolume.liters).value,
            Measurement(value: 400, unit: UnitVolume.milliliters).converted(to: UnitVolume.liters).value,
            Measurement(value: 300, unit: UnitVolume.milliliters).converted(to: UnitVolume.liters).value,
            Measurement(value: 200, unit: UnitVolume.milliliters).converted(to: UnitVolume.liters).value,
            Measurement(value: 100, unit: UnitVolume.milliliters).converted(to: UnitVolume.liters).value
        ]

        let expected = self.getExpectedDrinks(week: week, types: SampleDrinkTypes.allTypes(context), amounts: amounts)

        for index in 0..<expected.count {
            XCTAssertTrue(result[index] == expected[index])
        }
    }
    
    func testMillilitersToCups() {
        // Set units to mL
        model.userInfo.units = Constants.milliliters
        
        // Add sample drinks to drink store
        let week = Week()
        let types = SampleDrinks.week(week, context: context)

        var currentDrinks = [Drink]()

        for type in types {
            if let drinks = type.drinks?.allObjects as? [Drink] {
                currentDrinks += drinks
            }
        }

        currentDrinks = currentDrinks.sorted(by: { d1, d2 in
            d1.date < d2.date
        })

        model.convertMeasurements(pastUnit: model.userInfo.units, newUnit: Constants.cupsUS, drinks: currentDrinks)

        let result = currentDrinks.sorted(by: { d1, d2 in
            d1.date < d2.date
        })
        
        // Set expected amount conversions
        let amounts = [
            Measurement(value: 100, unit: UnitVolume.milliliters).converted(to: UnitVolume.cups).value,
            Measurement(value: 200, unit: UnitVolume.milliliters).converted(to: UnitVolume.cups).value,
            Measurement(value: 300, unit: UnitVolume.milliliters).converted(to: UnitVolume.cups).value,
            Measurement(value: 400, unit: UnitVolume.milliliters).converted(to: UnitVolume.cups).value,
            Measurement(value: 300, unit: UnitVolume.milliliters).converted(to: UnitVolume.cups).value,
            Measurement(value: 200, unit: UnitVolume.milliliters).converted(to: UnitVolume.cups).value,
            Measurement(value: 100, unit: UnitVolume.milliliters).converted(to: UnitVolume.cups).value
        ]

        let expected = self.getExpectedDrinks(week: week, types: SampleDrinkTypes.allTypes(context), amounts: amounts)

        for index in 0..<expected.count {
            XCTAssertTrue(result[index] == expected[index])
        }
    }

    func testMillilitersToFluidOunces() {
        // Set units to mL
        model.userInfo.units = Constants.milliliters
        
        // Add sample drinks to drink store
        let week = Week()
        let types = SampleDrinks.week(week, context: context)

        var currentDrinks = [Drink]()

        for type in types {
            if let drinks = type.drinks?.allObjects as? [Drink] {
                currentDrinks += drinks
            }
        }

        currentDrinks = currentDrinks.sorted(by: { d1, d2 in
            d1.date < d2.date
        })

        model.convertMeasurements(pastUnit: model.userInfo.units, newUnit: Constants.fluidOuncesUS, drinks: currentDrinks)

        let result = currentDrinks.sorted(by: { d1, d2 in
            d1.date < d2.date
        })
        
        // Set expected amount conversions
        let amounts = [
            Measurement(value: 100, unit: UnitVolume.milliliters).converted(to: UnitVolume.fluidOunces).value,
            Measurement(value: 200, unit: UnitVolume.milliliters).converted(to: UnitVolume.fluidOunces).value,
            Measurement(value: 300, unit: UnitVolume.milliliters).converted(to: UnitVolume.fluidOunces).value,
            Measurement(value: 400, unit: UnitVolume.milliliters).converted(to: UnitVolume.fluidOunces).value,
            Measurement(value: 300, unit: UnitVolume.milliliters).converted(to: UnitVolume.fluidOunces).value,
            Measurement(value: 200, unit: UnitVolume.milliliters).converted(to: UnitVolume.fluidOunces).value,
            Measurement(value: 100, unit: UnitVolume.milliliters).converted(to: UnitVolume.fluidOunces).value
        ]

        let expected = self.getExpectedDrinks(week: week, types: SampleDrinkTypes.allTypes(context), amounts: amounts)

        for index in 0..<expected.count {
            XCTAssertTrue(result[index] == expected[index])
        }
    }
    
    func testLitersToMilliliters() {
        // Set units to L
        model.userInfo.units = Constants.liters
        
        // Add sample drinks to drink store
        let week = Week()
        let types = SampleDrinks.week(week, context: context)

        var currentDrinks = [Drink]()

        for type in types {
            if let drinks = type.drinks?.allObjects as? [Drink] {
                currentDrinks += drinks
            }
        }

        currentDrinks = currentDrinks.sorted(by: { d1, d2 in
            d1.date < d2.date
        })

        model.convertMeasurements(pastUnit: model.userInfo.units, newUnit: Constants.milliliters, drinks: currentDrinks)

        let result = currentDrinks.sorted(by: { d1, d2 in
            d1.date < d2.date
        })
        
        // Set expected amount conversions
        let amounts = [
            Measurement(value: 100, unit: UnitVolume.liters).converted(to: UnitVolume.milliliters).value,
            Measurement(value: 200, unit: UnitVolume.liters).converted(to: UnitVolume.milliliters).value,
            Measurement(value: 300, unit: UnitVolume.liters).converted(to: UnitVolume.milliliters).value,
            Measurement(value: 400, unit: UnitVolume.liters).converted(to: UnitVolume.milliliters).value,
            Measurement(value: 300, unit: UnitVolume.liters).converted(to: UnitVolume.milliliters).value,
            Measurement(value: 200, unit: UnitVolume.liters).converted(to: UnitVolume.milliliters).value,
            Measurement(value: 100, unit: UnitVolume.liters).converted(to: UnitVolume.milliliters).value
        ]

        let expected = self.getExpectedDrinks(week: week, types: SampleDrinkTypes.allTypes(context), amounts: amounts)

        for index in 0..<expected.count {
            XCTAssertTrue(result[index] == expected[index])
        }
    }
    
    func testLitersToCups() {
        // Set units to L
        model.userInfo.units = Constants.liters
        
        // Add sample drinks to drink store
        let week = Week()
        let types = SampleDrinks.week(week, context: context)

        var currentDrinks = [Drink]()

        for type in types {
            if let drinks = type.drinks?.allObjects as? [Drink] {
                currentDrinks += drinks
            }
        }

        currentDrinks = currentDrinks.sorted(by: { d1, d2 in
            d1.date < d2.date
        })

        model.convertMeasurements(pastUnit: model.userInfo.units, newUnit: Constants.cupsUS, drinks: currentDrinks)

        let result = currentDrinks.sorted(by: { d1, d2 in
            d1.date < d2.date
        })
        
        // Set expected amount conversions
        let amounts = [
            Measurement(value: 100, unit: UnitVolume.liters).converted(to: UnitVolume.cups).value,
            Measurement(value: 200, unit: UnitVolume.liters).converted(to: UnitVolume.cups).value,
            Measurement(value: 300, unit: UnitVolume.liters).converted(to: UnitVolume.cups).value,
            Measurement(value: 400, unit: UnitVolume.liters).converted(to: UnitVolume.cups).value,
            Measurement(value: 300, unit: UnitVolume.liters).converted(to: UnitVolume.cups).value,
            Measurement(value: 200, unit: UnitVolume.liters).converted(to: UnitVolume.cups).value,
            Measurement(value: 100, unit: UnitVolume.liters).converted(to: UnitVolume.cups).value
        ]

        let expected = self.getExpectedDrinks(week: week, types: SampleDrinkTypes.allTypes(context), amounts: amounts)

        for index in 0..<expected.count {
            XCTAssertTrue(result[index] == expected[index])
        }
    }
    
    func testLitersToFluidOunces() {
        // Set units to L
        model.userInfo.units = Constants.liters
        
        // Add sample drinks to drink store
        let week = Week()
        let types = SampleDrinks.week(week, context: context)

        var currentDrinks = [Drink]()

        for type in types {
            if let drinks = type.drinks?.allObjects as? [Drink] {
                currentDrinks += drinks
            }
        }

        currentDrinks = currentDrinks.sorted(by: { d1, d2 in
            d1.date < d2.date
        })

        model.convertMeasurements(pastUnit: model.userInfo.units, newUnit: Constants.fluidOuncesUS, drinks: currentDrinks)

        let result = currentDrinks.sorted(by: { d1, d2 in
            d1.date < d2.date
        })
        
        // Set expected amount conversions
        let amounts = [
            Measurement(value: 100, unit: UnitVolume.liters).converted(to: UnitVolume.fluidOunces).value,
            Measurement(value: 200, unit: UnitVolume.liters).converted(to: UnitVolume.fluidOunces).value,
            Measurement(value: 300, unit: UnitVolume.liters).converted(to: UnitVolume.fluidOunces).value,
            Measurement(value: 400, unit: UnitVolume.liters).converted(to: UnitVolume.fluidOunces).value,
            Measurement(value: 300, unit: UnitVolume.liters).converted(to: UnitVolume.fluidOunces).value,
            Measurement(value: 200, unit: UnitVolume.liters).converted(to: UnitVolume.fluidOunces).value,
            Measurement(value: 100, unit: UnitVolume.liters).converted(to: UnitVolume.fluidOunces).value
        ]

        let expected = self.getExpectedDrinks(week: week, types: SampleDrinkTypes.allTypes(context), amounts: amounts)

        for index in 0..<expected.count {
            XCTAssertTrue(result[index] == expected[index])
        }
    }

    func testCupsToMilliliters() {
        // Set units to cups
        model.userInfo.units = Constants.cupsUS
        
        // Add sample drinks to drink store
        let week = Week()
        let types = SampleDrinks.week(week, context: context)

        var currentDrinks = [Drink]()

        for type in types {
            if let drinks = type.drinks?.allObjects as? [Drink] {
                currentDrinks += drinks
            }
        }

        currentDrinks = currentDrinks.sorted(by: { d1, d2 in
            d1.date < d2.date
        })

        model.convertMeasurements(pastUnit: model.userInfo.units, newUnit: Constants.milliliters, drinks: currentDrinks)

        let result = currentDrinks.sorted(by: { d1, d2 in
            d1.date < d2.date
        })
        
        // Set expected amount conversions
        let amounts = [
            Measurement(value: 100, unit: UnitVolume.cups).converted(to: UnitVolume.milliliters).value,
            Measurement(value: 200, unit: UnitVolume.cups).converted(to: UnitVolume.milliliters).value,
            Measurement(value: 300, unit: UnitVolume.cups).converted(to: UnitVolume.milliliters).value,
            Measurement(value: 400, unit: UnitVolume.cups).converted(to: UnitVolume.milliliters).value,
            Measurement(value: 300, unit: UnitVolume.cups).converted(to: UnitVolume.milliliters).value,
            Measurement(value: 200, unit: UnitVolume.cups).converted(to: UnitVolume.milliliters).value,
            Measurement(value: 100, unit: UnitVolume.cups).converted(to: UnitVolume.milliliters).value
        ]

        let expected = self.getExpectedDrinks(week: week, types: SampleDrinkTypes.allTypes(context), amounts: amounts)

        for index in 0..<expected.count {
            XCTAssertTrue(result[index] == expected[index])
        }
    }
    
    func testCupsToLiters() {
        // Set units to cups
        model.userInfo.units = Constants.cupsUS
        
        // Add sample drinks to drink store
        let week = Week()
        let types = SampleDrinks.week(week, context: context)

        var currentDrinks = [Drink]()

        for type in types {
            if let drinks = type.drinks?.allObjects as? [Drink] {
                currentDrinks += drinks
            }
        }

        currentDrinks = currentDrinks.sorted(by: { d1, d2 in
            d1.date < d2.date
        })

        model.convertMeasurements(pastUnit: model.userInfo.units, newUnit: Constants.liters, drinks: currentDrinks)

        let result = currentDrinks.sorted(by: { d1, d2 in
            d1.date < d2.date
        })
        
        // Set expected amount conversions
        let amounts = [
            Measurement(value: 100, unit: UnitVolume.cups).converted(to: UnitVolume.liters).value,
            Measurement(value: 200, unit: UnitVolume.cups).converted(to: UnitVolume.liters).value,
            Measurement(value: 300, unit: UnitVolume.cups).converted(to: UnitVolume.liters).value,
            Measurement(value: 400, unit: UnitVolume.cups).converted(to: UnitVolume.liters).value,
            Measurement(value: 300, unit: UnitVolume.cups).converted(to: UnitVolume.liters).value,
            Measurement(value: 200, unit: UnitVolume.cups).converted(to: UnitVolume.liters).value,
            Measurement(value: 100, unit: UnitVolume.cups).converted(to: UnitVolume.liters).value
        ]

        let expected = self.getExpectedDrinks(week: week, types: SampleDrinkTypes.allTypes(context), amounts: amounts)

        for index in 0..<expected.count {
            XCTAssertTrue(result[index] == expected[index])
        }
    }
    
    func testCupsToFluidOunces() {
        // Set units to cups
        model.userInfo.units = Constants.cupsUS
        
        // Add sample drinks to drink store
        let week = Week()
        let types = SampleDrinks.week(week, context: context)

        var currentDrinks = [Drink]()

        for type in types {
            if let drinks = type.drinks?.allObjects as? [Drink] {
                currentDrinks += drinks
            }
        }

        currentDrinks = currentDrinks.sorted(by: { d1, d2 in
            d1.date < d2.date
        })

        model.convertMeasurements(pastUnit: model.userInfo.units, newUnit: Constants.fluidOuncesUS, drinks: currentDrinks)

        let result = currentDrinks.sorted(by: { d1, d2 in
            d1.date < d2.date
        })
        
        // Set expected amount conversions
        let amounts = [
            Measurement(value: 100, unit: UnitVolume.cups).converted(to: UnitVolume.fluidOunces).value,
            Measurement(value: 200, unit: UnitVolume.cups).converted(to: UnitVolume.fluidOunces).value,
            Measurement(value: 300, unit: UnitVolume.cups).converted(to: UnitVolume.fluidOunces).value,
            Measurement(value: 400, unit: UnitVolume.cups).converted(to: UnitVolume.fluidOunces).value,
            Measurement(value: 300, unit: UnitVolume.cups).converted(to: UnitVolume.fluidOunces).value,
            Measurement(value: 200, unit: UnitVolume.cups).converted(to: UnitVolume.fluidOunces).value,
            Measurement(value: 100, unit: UnitVolume.cups).converted(to: UnitVolume.fluidOunces).value
        ]

        let expected = self.getExpectedDrinks(week: week, types: SampleDrinkTypes.allTypes(context), amounts: amounts)

        for index in 0..<expected.count {
            XCTAssertTrue(result[index] == expected[index])
        }
    }
    
    func testFluidOuncesToMilliliters() {
        // Set units to fl oz
        model.userInfo.units = Constants.fluidOuncesUS
        
        // Add sample drinks to drink store
        let week = Week()
        let types = SampleDrinks.week(week, context: context)

        var currentDrinks = [Drink]()

        for type in types {
            if let drinks = type.drinks?.allObjects as? [Drink] {
                currentDrinks += drinks
            }
        }

        currentDrinks = currentDrinks.sorted(by: { d1, d2 in
            d1.date < d2.date
        })

        model.convertMeasurements(pastUnit: model.userInfo.units, newUnit: Constants.milliliters, drinks: currentDrinks)

        let result = currentDrinks.sorted(by: { d1, d2 in
            d1.date < d2.date
        })
        
        // Set expected amount conversions
        let amounts = [
            Measurement(value: 100, unit: UnitVolume.fluidOunces).converted(to: UnitVolume.milliliters).value,
            Measurement(value: 200, unit: UnitVolume.fluidOunces).converted(to: UnitVolume.milliliters).value,
            Measurement(value: 300, unit: UnitVolume.fluidOunces).converted(to: UnitVolume.milliliters).value,
            Measurement(value: 400, unit: UnitVolume.fluidOunces).converted(to: UnitVolume.milliliters).value,
            Measurement(value: 300, unit: UnitVolume.fluidOunces).converted(to: UnitVolume.milliliters).value,
            Measurement(value: 200, unit: UnitVolume.fluidOunces).converted(to: UnitVolume.milliliters).value,
            Measurement(value: 100, unit: UnitVolume.fluidOunces).converted(to: UnitVolume.milliliters).value
        ]

        let expected = self.getExpectedDrinks(week: week, types: SampleDrinkTypes.allTypes(context), amounts: amounts)

        for index in 0..<expected.count {
            XCTAssertTrue(result[index] == expected[index])
        }
    }
    
    func testFluidOuncesToLiters() {
        // Set units to fl oz
        model.userInfo.units = Constants.fluidOuncesUS
        
        // Add sample drinks to drink store
        let week = Week()
        let types = SampleDrinks.week(week, context: context)

        var currentDrinks = [Drink]()

        for type in types {
            if let drinks = type.drinks?.allObjects as? [Drink] {
                currentDrinks += drinks
            }
        }

        currentDrinks = currentDrinks.sorted(by: { d1, d2 in
            d1.date < d2.date
        })

        model.convertMeasurements(pastUnit: model.userInfo.units, newUnit: Constants.liters, drinks: currentDrinks)

        let result = currentDrinks.sorted(by: { d1, d2 in
            d1.date < d2.date
        })
        
        // Set expected amount conversions
        let amounts = [
            Measurement(value: 100, unit: UnitVolume.fluidOunces).converted(to: UnitVolume.liters).value,
            Measurement(value: 200, unit: UnitVolume.fluidOunces).converted(to: UnitVolume.liters).value,
            Measurement(value: 300, unit: UnitVolume.fluidOunces).converted(to: UnitVolume.liters).value,
            Measurement(value: 400, unit: UnitVolume.fluidOunces).converted(to: UnitVolume.liters).value,
            Measurement(value: 300, unit: UnitVolume.fluidOunces).converted(to: UnitVolume.liters).value,
            Measurement(value: 200, unit: UnitVolume.fluidOunces).converted(to: UnitVolume.liters).value,
            Measurement(value: 100, unit: UnitVolume.fluidOunces).converted(to: UnitVolume.liters).value
        ]

        let expected = self.getExpectedDrinks(week: week, types: SampleDrinkTypes.allTypes(context), amounts: amounts)

        for index in 0..<expected.count {
            XCTAssertTrue(result[index] == expected[index])
        }
    }
    
    func testFluidOuncesToCups() {
        // Set units to fl oz
        model.userInfo.units = Constants.fluidOuncesUS
        
        // Add sample drinks to drink store
        let week = Week()
        let types = SampleDrinks.week(week, context: context)

        var currentDrinks = [Drink]()

        for type in types {
            if let drinks = type.drinks?.allObjects as? [Drink] {
                currentDrinks += drinks
            }
        }

        currentDrinks = currentDrinks.sorted(by: { d1, d2 in
            d1.date < d2.date
        })

        model.convertMeasurements(pastUnit: model.userInfo.units, newUnit: Constants.cupsUS, drinks: currentDrinks)

        let result = currentDrinks.sorted(by: { d1, d2 in
            d1.date < d2.date
        })
        
        // Set expected amount conversions
        let amounts = [
            Measurement(value: 100, unit: UnitVolume.fluidOunces).converted(to: UnitVolume.cups).value,
            Measurement(value: 200, unit: UnitVolume.fluidOunces).converted(to: UnitVolume.cups).value,
            Measurement(value: 300, unit: UnitVolume.fluidOunces).converted(to: UnitVolume.cups).value,
            Measurement(value: 400, unit: UnitVolume.fluidOunces).converted(to: UnitVolume.cups).value,
            Measurement(value: 300, unit: UnitVolume.fluidOunces).converted(to: UnitVolume.cups).value,
            Measurement(value: 200, unit: UnitVolume.fluidOunces).converted(to: UnitVolume.cups).value,
            Measurement(value: 100, unit: UnitVolume.fluidOunces).converted(to: UnitVolume.cups).value
        ]

        let expected = self.getExpectedDrinks(week: week, types: SampleDrinkTypes.allTypes(context), amounts: amounts)

        for index in 0..<expected.count {
            XCTAssertTrue(result[index] == expected[index])
        }
    }
    
    /**
     Generates an array of `Drink`s that is equal to the result of `convertMeasurements()`
     - Parameters:
        - week: The `Week` the `Drink`s are created for
        - types: The 4 Default `DrinkType`s
        - amounts: The amout consumed in the appropriate unit
     - Returns: An array of `Drink`s with converted measurements
     */
    private func getExpectedDrinks(week: Week, types: [DrinkType], amounts: [Double]) -> [Drink] {
        let sun = Drink(context: context)
        sun.id = UUID()
        sun.amount = amounts[0]
        sun.date = week.data[0]
        sun.type = types[0]
        types[0].addToDrinks(sun)
        
        let mon = Drink(context: context)
        mon.id = UUID()
        mon.amount = amounts[1]
        mon.date = week.data[1]
        mon.type = types[1]
        types[1].addToDrinks(mon)
        
        let tue = Drink(context: context)
        tue.id = UUID()
        tue.amount = amounts[2]
        tue.date = week.data[2]
        tue.type = types[2]
        types[2].addToDrinks(tue)
        
        let wed = Drink(context: context)
        wed.id = UUID()
        wed.amount = amounts[3]
        wed.date = week.data[3]
        wed.type = types[3]
        types[3].addToDrinks(wed)
        
        let thu = Drink(context: context)
        thu.id = UUID()
        thu.amount = amounts[4]
        thu.date = week.data[4]
        thu.type = types[0]
        types[0].addToDrinks(thu)
        
        let fri = Drink(context: context)
        fri.id = UUID()
        fri.amount = amounts[5]
        fri.date = week.data[5]
        fri.type = types[1]
        types[1].addToDrinks(fri)
        
        let sat = Drink(context: context)
        sat.id = UUID()
        sat.amount = amounts[6]
        sat.date = week.data[6]
        sat.type = types[2]
        types[2].addToDrinks(sat)
        
        return [sun, mon, tue, wed, thu, fri, sat]
    }
}
