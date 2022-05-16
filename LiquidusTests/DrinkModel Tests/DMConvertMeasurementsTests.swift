//
//  DMConvertMeasurementsTests.swift
//  LiquidusTests
//
//  Created by Christopher Engelbart on 4/30/22.
//

import XCTest
@testable import Liquidus

class DMConvertMeasurementsTests: XCTestCase {

    var model: DrinkModel!
    
    override func setUp() {
        self.model = DrinkModel(test: true, suiteName: nil)
    }
    
    override func tearDown() {
        self.model = nil
    }

    func testMillilitersToLiters() {
        // Set units to mL
        model.drinkData.units = Constants.milliliters
        
        // Add sample drinks to drink store
        let week = model.getWeek(date: .now)
        model.drinkData.drinks = SampleDrinks.week(week)
        
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
        
        // Set expected drinks
        let expected = [
            Drink(type: model.drinkData.drinkTypes[0], amount: amounts[0], date: week[0]),
            Drink(type: model.drinkData.drinkTypes[1], amount: amounts[1], date: week[1]),
            Drink(type: model.drinkData.drinkTypes[2], amount: amounts[2], date: week[2]),
            Drink(type: model.drinkData.drinkTypes[3], amount: amounts[3], date: week[3]),
            Drink(type: model.drinkData.drinkTypes[0], amount: amounts[4], date: week[4]),
            Drink(type: model.drinkData.drinkTypes[1], amount: amounts[5], date: week[5]),
            Drink(type: model.drinkData.drinkTypes[2], amount: amounts[6], date: week[6])
        ]
        
        // Convert measurements in drink store
        model.convertMeasurements(pastUnit: model.drinkData.units, newUnit: Constants.liters)
        
        // Assert the drink store and expected drinks are equal
        XCTAssertEqual(model.drinkData.drinks, expected)
    }
    
    func testMillilitersToCups() {
        // Set units to mL
        model.drinkData.units = Constants.milliliters
        
        // Add sample drinks to the drink store
        let week = model.getWeek(date: .now)
        model.drinkData.drinks = SampleDrinks.week(week)
        
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
        
        // Set expected drinks
        let expected = [
            Drink(type: model.drinkData.drinkTypes[0], amount: amounts[0], date: week[0]),
            Drink(type: model.drinkData.drinkTypes[1], amount: amounts[1], date: week[1]),
            Drink(type: model.drinkData.drinkTypes[2], amount: amounts[2], date: week[2]),
            Drink(type: model.drinkData.drinkTypes[3], amount: amounts[3], date: week[3]),
            Drink(type: model.drinkData.drinkTypes[0], amount: amounts[4], date: week[4]),
            Drink(type: model.drinkData.drinkTypes[1], amount: amounts[5], date: week[5]),
            Drink(type: model.drinkData.drinkTypes[2], amount: amounts[6], date: week[6])
        ]
        
        // Convert measurements in drink store
        model.convertMeasurements(pastUnit: model.drinkData.units, newUnit: Constants.cupsUS)
        
        // Assert the drink store and expected drinks are equal
        XCTAssertEqual(model.drinkData.drinks, expected)
    }

    func testMillilitersToFluidOunces() {
        // Set units to mL
        model.drinkData.units = Constants.milliliters
        
        // Add sample drinks to drink store
        let week = model.getWeek(date: .now)
        model.drinkData.drinks = SampleDrinks.week(week)
        
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
        
        // Set expected drinks
        let expected = [
            Drink(type: model.drinkData.drinkTypes[0], amount: amounts[0], date: week[0]),
            Drink(type: model.drinkData.drinkTypes[1], amount: amounts[1], date: week[1]),
            Drink(type: model.drinkData.drinkTypes[2], amount: amounts[2], date: week[2]),
            Drink(type: model.drinkData.drinkTypes[3], amount: amounts[3], date: week[3]),
            Drink(type: model.drinkData.drinkTypes[0], amount: amounts[4], date: week[4]),
            Drink(type: model.drinkData.drinkTypes[1], amount: amounts[5], date: week[5]),
            Drink(type: model.drinkData.drinkTypes[2], amount: amounts[6], date: week[6])
        ]
        
        // Convert measurements in drink store
        model.convertMeasurements(pastUnit: model.drinkData.units, newUnit: Constants.fluidOuncesUS)
        
        // Assert the drink store and expected drinks are equal
        XCTAssertEqual(model.drinkData.drinks, expected)
    }
    
    func testLitersToMilliliters() {
        // Set units to L
        model.drinkData.units = Constants.liters
        
        // Add sample drinks to drink store
        let week = model.getWeek(date: .now)
        model.drinkData.drinks = SampleDrinks.week(week)
        
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
        
        // Set expected drinks
        let expected = [
            Drink(type: model.drinkData.drinkTypes[0], amount: amounts[0], date: week[0]),
            Drink(type: model.drinkData.drinkTypes[1], amount: amounts[1], date: week[1]),
            Drink(type: model.drinkData.drinkTypes[2], amount: amounts[2], date: week[2]),
            Drink(type: model.drinkData.drinkTypes[3], amount: amounts[3], date: week[3]),
            Drink(type: model.drinkData.drinkTypes[0], amount: amounts[4], date: week[4]),
            Drink(type: model.drinkData.drinkTypes[1], amount: amounts[5], date: week[5]),
            Drink(type: model.drinkData.drinkTypes[2], amount: amounts[6], date: week[6])
        ]
        
        // Convert measurements in drink store
        model.convertMeasurements(pastUnit: model.drinkData.units, newUnit: Constants.milliliters)
        
        // Assert the drink store and expected drinks are equal
        XCTAssertEqual(model.drinkData.drinks, expected)
    }
    
    func testLitersToCups() {
        // Set units to liters
        model.drinkData.units = Constants.liters
        
        // Add sample drinks to drink store
        let week = model.getWeek(date: .now)
        model.drinkData.drinks = SampleDrinks.week(week)
        
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
        
        // Set expected drinks
        let expected = [
            Drink(type: model.drinkData.drinkTypes[0], amount: amounts[0], date: week[0]),
            Drink(type: model.drinkData.drinkTypes[1], amount: amounts[1], date: week[1]),
            Drink(type: model.drinkData.drinkTypes[2], amount: amounts[2], date: week[2]),
            Drink(type: model.drinkData.drinkTypes[3], amount: amounts[3], date: week[3]),
            Drink(type: model.drinkData.drinkTypes[0], amount: amounts[4], date: week[4]),
            Drink(type: model.drinkData.drinkTypes[1], amount: amounts[5], date: week[5]),
            Drink(type: model.drinkData.drinkTypes[2], amount: amounts[6], date: week[6])
        ]
        
        // Convert measurements in drink store
        model.convertMeasurements(pastUnit: model.drinkData.units, newUnit: Constants.cupsUS)
        
        // Assert the drink store and expected drinks are equal
        XCTAssertEqual(model.drinkData.drinks, expected)
    }
    
    func testLitersToFluidOunces() {
        // Set units to liters
        model.drinkData.units = Constants.liters

        // Add sample drinks to drink store
        let week = model.getWeek(date: .now)
        model.drinkData.drinks = SampleDrinks.week(week)
        
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
        
        // Set expected drinks
        let expected = [
            Drink(type: model.drinkData.drinkTypes[0], amount: amounts[0], date: week[0]),
            Drink(type: model.drinkData.drinkTypes[1], amount: amounts[1], date: week[1]),
            Drink(type: model.drinkData.drinkTypes[2], amount: amounts[2], date: week[2]),
            Drink(type: model.drinkData.drinkTypes[3], amount: amounts[3], date: week[3]),
            Drink(type: model.drinkData.drinkTypes[0], amount: amounts[4], date: week[4]),
            Drink(type: model.drinkData.drinkTypes[1], amount: amounts[5], date: week[5]),
            Drink(type: model.drinkData.drinkTypes[2], amount: amounts[6], date: week[6])
        ]
        
        // Convert measurements in drink store
        model.convertMeasurements(pastUnit: model.drinkData.units, newUnit: Constants.fluidOuncesUS)
        
        // Assert the drink store and expected drinks are equal
        XCTAssertEqual(model.drinkData.drinks, expected)
    }

    func testCupsToMilliliters() {
        // Set units to cups
        model.drinkData.units = Constants.cupsUS
        
        // Add sample drinks to drink store
        let week = model.getWeek(date: .now)
        model.drinkData.drinks = SampleDrinks.week(week)
        
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
        
        // Set expected drinks
        let expected = [
            Drink(type: model.drinkData.drinkTypes[0], amount: amounts[0], date: week[0]),
            Drink(type: model.drinkData.drinkTypes[1], amount: amounts[1], date: week[1]),
            Drink(type: model.drinkData.drinkTypes[2], amount: amounts[2], date: week[2]),
            Drink(type: model.drinkData.drinkTypes[3], amount: amounts[3], date: week[3]),
            Drink(type: model.drinkData.drinkTypes[0], amount: amounts[4], date: week[4]),
            Drink(type: model.drinkData.drinkTypes[1], amount: amounts[5], date: week[5]),
            Drink(type: model.drinkData.drinkTypes[2], amount: amounts[6], date: week[6])
        ]

        // Convert measurements in drink store
        model.convertMeasurements(pastUnit: model.drinkData.units, newUnit: Constants.milliliters)
        
        // Assert the drink store and expected drinks are equal
        XCTAssertEqual(model.drinkData.drinks, expected)
    }
    
    func testCupsToLiters() {
        // Set units to cups
        model.drinkData.units = Constants.cupsUS
        
        // Add sample drinks to drink store
        let week = model.getWeek(date: .now)
        model.drinkData.drinks = SampleDrinks.week(week)
        
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
        
        // Set expected drinks
        let expected = [
            Drink(type: model.drinkData.drinkTypes[0], amount: amounts[0], date: week[0]),
            Drink(type: model.drinkData.drinkTypes[1], amount: amounts[1], date: week[1]),
            Drink(type: model.drinkData.drinkTypes[2], amount: amounts[2], date: week[2]),
            Drink(type: model.drinkData.drinkTypes[3], amount: amounts[3], date: week[3]),
            Drink(type: model.drinkData.drinkTypes[0], amount: amounts[4], date: week[4]),
            Drink(type: model.drinkData.drinkTypes[1], amount: amounts[5], date: week[5]),
            Drink(type: model.drinkData.drinkTypes[2], amount: amounts[6], date: week[6])
        ]
        
        // Convert measurements in drink store
        model.convertMeasurements(pastUnit: model.drinkData.units, newUnit: Constants.liters)
        
        // Assert the drink store and expected drinks are equal
        XCTAssertEqual(model.drinkData.drinks, expected)
    }
    
    func testCupsToFluidOunces() {
        // Set units to cups
        model.drinkData.units = Constants.cupsUS
        
        // Add sample drinks to drink store
        let week = model.getWeek(date: .now)
        model.drinkData.drinks = SampleDrinks.week(week)
        
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
        
        // Set expected drinks
        let expected = [
            Drink(type: model.drinkData.drinkTypes[0], amount: amounts[0], date: week[0]),
            Drink(type: model.drinkData.drinkTypes[1], amount: amounts[1], date: week[1]),
            Drink(type: model.drinkData.drinkTypes[2], amount: amounts[2], date: week[2]),
            Drink(type: model.drinkData.drinkTypes[3], amount: amounts[3], date: week[3]),
            Drink(type: model.drinkData.drinkTypes[0], amount: amounts[4], date: week[4]),
            Drink(type: model.drinkData.drinkTypes[1], amount: amounts[5], date: week[5]),
            Drink(type: model.drinkData.drinkTypes[2], amount: amounts[6], date: week[6])
        ]
        
        // Convert measurements in drink store
        model.convertMeasurements(pastUnit: model.drinkData.units, newUnit: Constants.fluidOuncesUS)
        
        // Assert the drink store and expected drinks are equal
        XCTAssertEqual(model.drinkData.drinks, expected)
    }
    
    func testFluidOuncesToMilliliters() {
        // Set units to fluid ounces
        model.drinkData.units = Constants.fluidOuncesUS
        
        // Add sample drinks to drink store
        let week = model.getWeek(date: .now)
        model.drinkData.drinks = SampleDrinks.week(week)
        
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
        
        // Set expected drinks
        let expected = [
            Drink(type: model.drinkData.drinkTypes[0], amount: amounts[0], date: week[0]),
            Drink(type: model.drinkData.drinkTypes[1], amount: amounts[1], date: week[1]),
            Drink(type: model.drinkData.drinkTypes[2], amount: amounts[2], date: week[2]),
            Drink(type: model.drinkData.drinkTypes[3], amount: amounts[3], date: week[3]),
            Drink(type: model.drinkData.drinkTypes[0], amount: amounts[4], date: week[4]),
            Drink(type: model.drinkData.drinkTypes[1], amount: amounts[5], date: week[5]),
            Drink(type: model.drinkData.drinkTypes[2], amount: amounts[6], date: week[6])
        ]
        
        // Convert measurements in drink store
        model.convertMeasurements(pastUnit: model.drinkData.units, newUnit: Constants.milliliters)
        
        // Assert the drink store and expected drinks are equal
        XCTAssertEqual(model.drinkData.drinks, expected)
    }
    
    func testFluidOuncesToLiters() {
        // Set units to fluid ounces
        model.drinkData.units = Constants.fluidOuncesUS
        
        // Add sample drinks to drink store
        let week = model.getWeek(date: .now)
        model.drinkData.drinks = SampleDrinks.week(week)
        
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
        
        // Set expected drinks
        let expected = [
            Drink(type: model.drinkData.drinkTypes[0], amount: amounts[0], date: week[0]),
            Drink(type: model.drinkData.drinkTypes[1], amount: amounts[1], date: week[1]),
            Drink(type: model.drinkData.drinkTypes[2], amount: amounts[2], date: week[2]),
            Drink(type: model.drinkData.drinkTypes[3], amount: amounts[3], date: week[3]),
            Drink(type: model.drinkData.drinkTypes[0], amount: amounts[4], date: week[4]),
            Drink(type: model.drinkData.drinkTypes[1], amount: amounts[5], date: week[5]),
            Drink(type: model.drinkData.drinkTypes[2], amount: amounts[6], date: week[6])
        ]
        
        // Convert measurements in drink store
        model.convertMeasurements(pastUnit: model.drinkData.units, newUnit: Constants.liters)
        
        // Assert the drink store and expected drinks are equal
        XCTAssertEqual(model.drinkData.drinks, expected)
    }
    
    func testFluidOuncesToCups() {
        // Set units to fluid ounces
        model.drinkData.units = Constants.fluidOuncesUS
        
        // Add sample drinks to drink store
        let week = model.getWeek(date: .now)
        model.drinkData.drinks = SampleDrinks.week(week)
        
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
        
        // Set expected drinks
        let expected = [
            Drink(type: model.drinkData.drinkTypes[0], amount: amounts[0], date: week[0]),
            Drink(type: model.drinkData.drinkTypes[1], amount: amounts[1], date: week[1]),
            Drink(type: model.drinkData.drinkTypes[2], amount: amounts[2], date: week[2]),
            Drink(type: model.drinkData.drinkTypes[3], amount: amounts[3], date: week[3]),
            Drink(type: model.drinkData.drinkTypes[0], amount: amounts[4], date: week[4]),
            Drink(type: model.drinkData.drinkTypes[1], amount: amounts[5], date: week[5]),
            Drink(type: model.drinkData.drinkTypes[2], amount: amounts[6], date: week[6])
        ]
        
        // Convert measurements in drink store
        model.convertMeasurements(pastUnit: model.drinkData.units, newUnit: Constants.cupsUS)
        
        // Assert the drink store and expected drinks are equal
        XCTAssertEqual(model.drinkData.drinks, expected)
    }
}
