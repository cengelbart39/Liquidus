//
//  DrinkModel.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 9/7/21.
//
//  UserDefaults Implementation Based Off Of:
//  https://youtu.be/vsL1UemuB3U by Paul Hudson
//
//  HealthKit Implementation Based Off Of:
//  - https://developer.apple.com/videos/play/wwdc2020/10664/
//  - https://youtu.be/ohgrzM9gfvM by azamsharp
//

import Foundation
import SwiftUI
import HealthKit
import WidgetKit

/**
 A ViewModel containing inter-view data and methods
 */
class DrinkModel: ObservableObject {
    
    /// The user's data
    @Published var drinkData = DrinkData()
    
    /// The HealthKit data access point, if granted access to HealthKit Data
    @Published var healthStore: HealthStore?
    
    /// Whether or not the Grayscale setting is enabled by the user
    @Published var grayscaleEnabled = UIAccessibility.isGrayscaleEnabled
        
    /**
     Create a new DrinkModel
     - Parameter test: Whether or not it was created bu LiquidusTests; True if so
     - Parameter suiteName: Only not `nil` if running UserDefaults Test
     */
    init(test: Bool, suiteName: String?) {
        // Create HealthStore
        healthStore = HealthStore()
        
        // Retrieve data from UserDefaults
        if !test || suiteName != nil {
            retrieve(test: suiteName != nil ? true : false)
        
        } else {
            // If unable to retrieve from UserDefaults (or Unit Testing), create a new DrinkData
            self.drinkData = DrinkData()
        }
    }
    
    /**
     Retrieve data from UserDefaults
     - Parameter test: Whether or not it was created bu LiquidusTests; If True retrieves from `unitTestingKey`; If not retrieves from `sharedKey`
     */
    func retrieve(test: Bool) {
        if let userDefaults = UserDefaults(suiteName: test ? Constants.unitTestingKey : Constants.sharedKey) {
            if let data = userDefaults.data(forKey: Constants.savedKey) {
                if let decoded = try? JSONDecoder().decode(DrinkData.self, from: data) {
                    self.drinkData = decoded
                    
                    return
                }
            }
        }
    }
    
    /**
     Save any changes made to Drink Data
     - Parameter test: Whether or not it was created bu LiquidusTests; If True saves from `unitTestingKey`; If not saves to `sharedKey`
     */
    func save(test: Bool) {
        // Save data to user defaults
        if let userDefaults = UserDefaults(suiteName: test ? Constants.unitTestingKey : Constants.sharedKey) {
            if let encoded = try? JSONEncoder().encode(drinkData) {
                userDefaults.set(encoded, forKey: Constants.savedKey)
            }
        }
    }
    
    /**
     Add a `Drink` to `DrinkData` and save changes. If it's water sync with Apple Health if access is granted. Widgets will be updated as well.
     - Parameter drink: `Drink` to be saved
     */
    func addDrink(drink: Drink) {
        // Add drink
        self.drinkData.drinks.append(drink)
        
        // If it's water, save to HealthKit
        if drink.type.name == Constants.waterKey && drink.type.enabled {
            self.saveToHealthKit()
        }
        
        // Save to UserDefaults
        self.save(test: false)
        
        // Update widget
        WidgetCenter.shared.reloadAllTimelines()
        
    }
    
    /**
     Generates random drinks for a year using the current date and saves to data store
     */
    func addYearDrinks() {
        // Get current year
        let year = Year(date: .now)
        
        // Empty drink array
        var allDrinks = [Drink]()
        
        // Get water
        let water = self.drinkData.drinkTypes.first!
        
        // Loop through months in year
        for month in year.data {
            
            // Loop through days in month
            for day in month.data {
                // Get a random double btwn 0 and 1,600
                let rand = Double.random(in: 0...1600)
                
                // Append a Drink
                allDrinks.append(Drink(type: water, amount: rand, date: day.data))
            }
        }
        
        self.drinkData.drinks = allDrinks
    }
    
    // MARK: - Drink Types
    /**
     Delete a custom drink type
     - Parameter atOffsets: Which `DrinkType` index to be deleted
     */
    func deleteCustomDrinks(atOffsets: IndexSet) {
        // Get drinkType
        let drinkType = self.drinkData.drinkTypes[atOffsets.first!]
        
        // Loop through drinks
        for drink in self.drinkData.drinks {
            // If the drink type is the same...
            if drink.type == drinkType {
                // Remove drink
                self.drinkData.drinks.remove(at: self.drinkData.drinks.firstIndex(of: drink)!)
            }
        }
        
        // Remove drink type from customDrinkTypes
        self.drinkData.drinkTypes.remove(atOffsets: atOffsets)
        
        // Save
        self.save(test: false)
    
        // Update widget
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    /**
     Update a custom drink type for a name change
     - Parameter old: Old `DrinkType`
     - Parameter new: New name for `DrinkType`
     */
    func editDrinkType(old: DrinkType, new: String) {
        // Update colors
        let index = self.drinkData.drinkTypes.firstIndex(of: old)!
        self.drinkData.drinkTypes[index].name = new
        
        // Update drinks
        for drink in self.drinkData.drinks {
            if drink.type == old {
                drink.type.name = new
            }
        }
        
        // Save
        self.save(test: false)
        
        // Update Widget
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    /**
     For a `DrinkType` get the associated `Color`. If the `Color` for a default `DrinkType` hasn't been changed, return a System `Color`. Otherwise and for Custom `DrinkTypes`, return the stored `Color`.
     - Parameter type: `DrinkType` to retrieve a `Color` from
     - Returns: The saved color with the `DrinkType`, unless returning a System `Color`
     */
    func getDrinkTypeColor(type: DrinkType) -> Color {
        // Check if the color isn't changed for the given type...
        if (!type.colorChanged) {
            
            // If Water, return .systemCyan
            if type.name == Constants.waterKey {
                return Color(.systemCyan)
                
            // If Coffee, return .systemBrown
            } else if type.name == Constants.coffeeKey {
                return Color(.systemBrown)
                
            // If Soda, return .systemGreen
            } else if type.name == Constants.sodaKey {
                return Color(.systemGreen)
                
            // If Juice, return .systemOrange
            } else if type.name == Constants.juiceKey {
                return Color(.systemOrange)
                
            }
        }
        
        // If not, return the stored color
        return type.color.getColor()
    }
    
    /**
     Get a Gradient dependent on `self.grayscaleEnabled`
     - Precondition: The Total `DrinkType` is selected
     - Returns: A solid `LinearGradient` of `Color.primary`, if `self.grayscaleEnabled` is `true`, or a rainbow `LinearGradient` if not
     */
    func getDrinkTypeGradient() -> LinearGradient {
        if self.grayscaleEnabled {
            // Return solid white gradient
            return LinearGradient(colors: [.primary], startPoint: .top, endPoint: .bottom)
            
        } else {
            // Return rainbow gradient
            return LinearGradient(colors: [.red, .orange, .yellow, .green, .blue, .purple], startPoint: .top, endPoint: .bottom)
        }
    }
    
    /**
     Return all `Drink`s of a specific `DrinkType`
     - Parameter type: The `DrinkType` to filter with
     - Returns: All drinks of `type`
     */
    func filterByDrinkType(type: DrinkType) -> [Drink] {
        // Filter drinks by type
        return self.drinkData.drinks.filter { $0.type == type }
    }
    
    /**
     Return the total amount of all `Drink`s of a specific `DrinkType`
     - Parameter type: The `DrinkType` to get the type amount for
     - Returns: The total amount consumed for `type`
     */
    func getTypeAmount(type: DrinkType) -> Double {
        // Get drinks
        let drinks = self.filterByDrinkType(type: type)
        
        // Get amount by looping through drinks
        var amount = 0.0
        for drink in drinks {
            amount += drink.amount
        }
        
        // return amount
        return amount
    }
    
    /**
     Return the total amount consumed for all `Drink`s
     - Returns: The total amount consumed across all `Drink`s
     */
    func getTotalAmount() -> Double {
        // Loop through drinks to get total amount
        var amount = 0.0
        for drink in self.drinkData.drinks {
            amount += drink.amount
        }
        return amount
    }
    
    /**
     Return the average for all `Drink`s of a specific `DrinkType`
     - Parameters:
        - type: The `DrinkType` to get the average for
        - startDate: The first date in the range considered
     - Returns: An average if 3 months have passed since the first `Drink` has been logged; `nil` if 3 months haven't passed
     */
    func getTypeAverage(type: DrinkType, startDate: Date) -> Double? {
        // Get total based on passed in type
        let total = type.name == Constants.totalKey ? self.getTotalAmount() : self.getTypeAmount(type: type)
        
        // Get all drinks based on passed in type
        let drinks = type.name == Constants.totalKey ? self.drinkData.drinks : self.filterByDrinkType(type: type)
        
        // Find the minumum date from drinks
        var minDate = Date()
        for drink in drinks {
            if drink.date < minDate {
                minDate = drink.date
            }
        }
        
        // Get the difference in months between minDate and startDate
        let monthDifference = Calendar.current.dateComponents([.month], from: minDate, to: startDate)
        
        // Get the date that is three months earlier than startDate
        if let threeMonthsAgo = Calendar.current.date(byAdding: .month, value: -3, to: startDate) {
            
            // Get the components in days for threeMonthsAgo
            let threeMonths = Calendar.current.dateComponents([.day], from: threeMonthsAgo, to: .now)
            
            // Get the day count and mounth count
            if let threeDiff = threeMonths.day, let monthDiff = monthDifference.month {
                
                // If three or more months have data return the average
                if monthDiff >= 3 {
                    return floor(total/Double(threeDiff))
                    
                // If not return nil
                } else if monthDiff < 3 {
                    return nil
                }
            }
        }
        
        return 0.0
    }
    
    /**
     Create a new `DrinkType` and add to `DrinkData`
     - Parameters:
        - type: The name of the new `DrinkType`
        - color: The color of the new `DrinkType`
     */
    func saveDrinkType(type: String, color: Color) {
        // Seperate type by spaces
        let words = type.split(separator: " ")
        
        var saveType = ""
        
        // Loop through words
        for word in words {
            
            // Get first char of word and uppercase it
            let first = word.first!.uppercased()
            
            // Lowercase word
            var rest = word.lowercased()
            // Remove first char
            rest.remove(at: rest.startIndex)
            
            // Update saveType
            saveType += (first + rest)
            
            // If word isn't the end of type...
            if words.firstIndex(of: word) != words.count-1 {
                // Add space
                saveType += " "
            }
        }
        
        // Create codableColor
        let codableColor = CodableColor(color: UIColor(color))
        
        // Create new drink type
        let new = DrinkType(name: saveType, color: codableColor, isDefault: false, enabled: true, colorChanged: true)
        
        // Add to drink type store
        self.drinkData.drinkTypes.append(new)
        
        // Save model
        self.save(test: false)
    }
    
    // MARK: - Units
    /**
     Gets the appropriate specifier so a double will have 0 or 2 decimal points displayed
     - Parameter amount: The amount to get the specifier for
     - Returns: The specifier; `"%.0f"` for a whole number; `"%.2f"` for any decimal number
     */
    func getSpecifier(amount: Double) -> String {
        // Rounds amount up or down
        let rounded = amount.rounded()
        
        // When round and amount are the same return so no decimals are used
        if rounded == amount {
            return "%.0f"
            
        // If not, use 2 decimal places
        } else {
            return "%.2f"
        }
    }
    
    /**
     Get the unit abbreviation for the stored unit
     - Returns: The unit abbreviation; `"cups"`, `"floz"`, `"mL"`, `"L"`; Empty `String` for unrecognized units
     */
    func getUnits() -> String {
        
        // Check for Cups
        if self.drinkData.units == Constants.cupsUS {
            return Constants.cups
            
        // Check for Milliliters
        } else if self.drinkData.units == Constants.milliliters {
            return Constants.mL
            
        // Check for Liters
        } else if self.drinkData.units == Constants.liters {
            return Constants.L
            
        // Check for Fluid Ounces
        } else if self.drinkData.units == Constants.fluidOuncesUS {
            return Constants.flOzUS
        }
        
        // Return an empty String if none of the if/if-else conditions trigger
        return ""
    }
    
    /**
     For the stored unit return the full name of a unit to be used in Accessibility Support
     - Returns: `"milliliters"`, `"liters"`,  `"fluid ounces"`, `"cups"`
     */
    func getAccessibilityUnitLabel() -> String {
        // Get the stored units
        let units = self.drinkData.units
        
        // Check for Millliters
        if units == Constants.milliliters {
            return "milliliters"
            
        // Check for Liters
        } else if units == Constants.liters {
            return "liters"
            
        // Check for Fluid Ounces
        } else if units == Constants.fluidOuncesUS {
            return "fluid ounces"
            
        // Check for Cups
        } else {
            return "cups"
        }
    }
    
    /**
     Convert all measurements in the old unit to the new unit
     - Parameters:
        - pastUnit: The old unit used
        - newUnit: The unit to update all measurements to
     */
    func convertMeasurements(pastUnit: String, newUnit: String) {
        
        // Get measurement of daily goal from pastUnit
        let dailyGoalMeasurement = Measurement(value: self.drinkData.dailyGoal, unit: Constants.unitDictionary[pastUnit]!)
        
        // Convert daily goal to newUnit
        self.drinkData.dailyGoal = dailyGoalMeasurement.converted(to: Constants.unitDictionary[newUnit]!).value
        
        for drink in self.drinkData.drinks {
            
            // Get measurement of drink amount from pastUnit
            let drinkMeasurement = Measurement(value: drink.amount, unit: Constants.unitDictionary[pastUnit]!)
            
            // Convert drink amount to newUnit
            drink.amount = drinkMeasurement.converted(to: Constants.unitDictionary[newUnit]!).value
            
        }
        
    }
    
    // MARK: - Data by Hour Functions
    /**
     Gets `Drink`s consumed during the given `Hour`
     - Parameter hour: The `Hour` to filter by
     - Returns: A `Drink` array for all `Drink`s in `hour`
     */
    func filterDataByHour(hour: Hour) -> [Drink] {
        
        // Filter for drinks in the same hour, day, month, and year as date and drinks
        // that have an enabled type
        return self.drinkData.drinks.filter {
            Calendar.current.compare($0.date, to: hour.data, toGranularity: .hour) == .orderedSame && Calendar.current.compare($0.date, to: hour.data, toGranularity: .day) == .orderedSame && Calendar.current.compare($0.date, to: hour.data, toGranularity: .month) == .orderedSame && Calendar.current.compare($0.date, to: hour.data, toGranularity: .year) == .orderedSame && $0.type.enabled
        }
    }
    
    /**
     Gets `Drink`s consumed during the given `Hour` and of the given `DrinkType`
     - Parameter hour: The `Hour` to filter by
     - Parameter type: The `DrinkType` to filter by
     - Returns: The drinks consumed during `hour` and of `type`
     */
    func filterDataByHourAndType(hour: Hour, type: DrinkType) -> [Drink] {
        return self.filterDataByHour(hour: hour).filter {
            $0.type == type
        }
    }
    
    /**
     Get the total amount consumed of a given `DrinkType` and consumed during the given `Hour`
     - Parameter type: The `DrinkType` to get the amount for
     - Parameter hour: The `Hour` to get the amount for
     - Returns: The overall amount of the `Drink`s of `type` and consumed during `hour`
     */
    func getTypeAmountByHour(type: DrinkType, hour: Hour) -> Double {
        // Get drinks for the hour
        let drinks = self.filterDataByHour(hour: hour).filter { $0.type == type }
        
        // Get total amount for the hour
        var totalAmount = 0.0
        for drink in drinks {
            totalAmount += drink.amount
        }
        
        return totalAmount
    }
    
    // MARK: - Data by Day Functions
    /**
     Filter all `Drink`s consumed during the given `Day`
     - Parameter day: The `Day` to filter by
     - Returns: The `Drink`s consumed during `day`
     */
    func filterDataByDay(day: Day) -> [Drink] {
        
        // Filter for drinks in the same day, month, and year as date and
        // drinks that have an enabled type
        return self.drinkData.drinks.filter {
            Calendar.current.compare($0.date, to: day.data, toGranularity: .day) == .orderedSame && Calendar.current.compare($0.date, to: day.data, toGranularity: .month) == .orderedSame && Calendar.current.compare($0.date, to: day.data, toGranularity: .year) == .orderedSame && $0.type.enabled
        }
    }
    
    /**
     Filter all `Drink`s consumed during the given `Day` and of the given `DrinkType`
     - Parameter type: The `DrinkType` to filter by
     - Parameter day: The `Day` to filter by
     - Returns: The `Drink`s consumed of `type` and during `day`
     */
    func filterDataByDayAndType(type: DrinkType, day: Day) -> [Drink] {
        
        // If type is the Total Type use filterDataByYear()
        if type.name == Constants.totalKey {
            return self.filterDataByDay(day: day)
            
        // If not use filterDataByYear() and filter for the given type
        } else {
            return self.filterDataByDay(day: day).filter {
                $0.type == type
            }
        }
    }
    
    /**
     Get the total amount consumed of a given `DrinkType` during the given `Day`
     - Parameter type: The `DrinkType` to get the amount for
     - Parameter day: The `Day` to get the amount for
     - Returns: The total amount consumed of `type` during `day`
     */
    func getTypeAmountByDay(type: DrinkType, day: Day) -> Double {
        // Get the filtered data for the day
        let drinks = self.filterDataByDayAndType(type: type, day: day)
        
        // Add up all the amounts
        var totalAmount = 0.0
        for drink in drinks {
            totalAmount += drink.amount
        }
        
        return totalAmount
    }
    
    /**
     Get the total percent of the amount consumed for a given `DrinkType` during a given `Day` over the user's daily goal
     - Parameter type: The `DrinkType` to get the percentage for
     - Parameter day: The `Day` to get the percentage for
     - Returns: The total percent of the amount consumed for `type` during `day` over the user's daily goal
     */
    func getTypePercentByDay(type: DrinkType, day: Day) -> Double {
        
        // Get the amount of liquid consumed by liquid and date
        let amount = self.getTypeAmountByDay(type: type, day: day)
        
        // Get percentage
        let percent = amount / self.drinkData.dailyGoal
        
        return percent
    }
    
    /**
     Get the total amount consumed for the given `Day`
     - Parameter day: The `Day` to get the total amount of `Drink`s consumed for
     - Returns: The total amount consumed during `day`
     */
    func getTotalAmountByDay(day: Day) -> Double {
        // Track total amount
        var amount = 0.0
        
        // Filter through drinks in day and add to amount
        for drink in self.filterDataByDay(day: day) {
            amount += drink.amount
        }
        
        return amount
    }
    
    /**
     Get the total percent of the amount consumed during the given `Day` over the user's daily goal
     - Parameter day: The `Day` to get the percentage for
     - Returns: The total percent of the amount consumed during `day` over the user's daily goal
     */
    func getTotalPercentByDay(day: Day) -> Double {
        
        // Get total amount
        let totalAmount = getTotalAmountByDay(day: day)
        
        // Get percentage
        let percent = totalAmount / self.drinkData.dailyGoal
        
        return percent
    }
    
    // MARK: - Data by Week Functions
    /**
     Get the `Drink`s consumed during the given `Week`
     - Parameter week: The `Week` to filter by
     - Returns: The `Drink`s consumed during `week`
     */
    func filterDataByWeek(week: Week) -> [Drink] {
        
        var drinks = [Drink]()
        
        for day in week.data {
            drinks += self.filterDataByDay(day: day)
        }
        
        return drinks
    }
    
    /**
     Get all drinks consumed in a given `Week` that belong to the given `DrinkType`
     - Parameter type: The `DrinkType` to filter by
     - Parameter week: The `Week` to filter by
     - Returns: The drinks consumed during `week` and of  `type`
     */
    func filterDataByWeekAndType(type: DrinkType, week: Week) -> [Drink] {
        
        // If type is the Total Type use filterDataByYear()
        if type.name == Constants.totalKey {
            return self.filterDataByWeek(week: week)
        
        // If not use filterDataByYear() and filter for the given type
        } else {
            return self.filterDataByWeek(week: week).filter {
                $0.type == type
            }
        }
    }
    
    /**
     Get the total amount of `Drink`s consumed for a given `DrinkType` during a given `Week`
     - Parameter type: The `DrinkType` to get the total amount for
     - Parameter week: The `Week` to get the total amount for
     - Returns: The total amount consumed during `week` and for `type`
     */
    func getTypeAmountByWeek(type: DrinkType, week: Week) -> Double {
        
        // Get the drink data for the week
        let drinks = self.filterDataByWeekAndType(type: type, week: week)
        
        // Get the total amount
        var totalAmount = 0.0
        for drink in drinks {
            totalAmount += drink.amount
        }
        
        return totalAmount
    }
    
    // MARK: - Data by Month Functions
    /**
     Get the `Drink`s that were consumed during a given `Month`
     - Parameter month: The `Month` to filter by
     - Returns: The `Drink`s that were consumed during `month`
     */
    func filterDataByMonth(month: Month) -> [Drink] {
        // Filter drinks in the same month and year as the first day of month
        return self.drinkData.drinks.filter {
            Calendar.current.compare(month.firstDay(), to: $0.date, toGranularity: .month) == .orderedSame && Calendar.current.compare(month.firstDay(), to: $0.date, toGranularity: .year) == .orderedSame && $0.type.enabled
        }
    }
    
    /**
     Get the `Drink`s that were consumed during a given `Month` and of a given `DrinkType`
     - Parameter type: The `DrinkType` to filter by
     - Parameter month: The `Month` to filter by
     - Returns: The `Drink`s that were consumed during `month` and of `type`
     */
    func filterDataByMonthAndType(type: DrinkType, month: Month) -> [Drink] {
        
        // If type is the Total Type use filterDataByYear()
        if type.name == Constants.totalKey {
            return self.filterDataByMonth(month: month)
            
        // If not use filterDataByYear() and filter for the given type
        } else {
            return self.filterDataByMonth(month: month).filter {
                $0.type == type
            }
        }
    }
    
    /**
     Get the total amount of `Drink`s consumed during the given `Month` and of the given `DrinkType`
     - Parameter type: The `DrinkType` to get the type amount for
     - Parameter month: The `Month` to get the type amount for
     - Returns: The total amount of `Drink`s consumed during `month` and of `type`
     */
    func getTypeAmountByMonth(type: DrinkType, month: Month) -> Double {
        // Get the drinks for the given type and month
        let drinks = self.filterDataByMonthAndType(type: type, month: month)
        
        // Track the total amount consumed
        var amount = 0.0
        
        // Loop through drinks and add to amount
        for drink in drinks {
            amount += drink.amount
        }
        
        return amount
    }
    
    // MARK: - Data by Half-Yearly Methods
    /**
     Get the `Drink`s consumed during the given `HalfYear`
     - Parameter halfYear: The `HalfYear` to filter by
     - Returns: The drinks consumed during `halfYear`
     */
    func filterDataByHalfYear(halfYear: HalfYear) -> [Drink] {
        
        // Empty drink array
        var drinks = [Drink]()
        
        // Loop through each week and append the drinks that are in each month
        for week in halfYear.data {
            for drink in self.filterDataByWeek(week: week) {
                drinks.append(drink)
            }
        }
        
        // Sort drinks by date
        drinks.sort { $0.date  < $1.date }
        
        return drinks
    }
    
    /**
     Get the `Drink`s consumed during the given `HalfYear` and of the given `DrinkType`
     - Parameter type: The `DrinkType` to filter by
     - Parameter halfYear: The `HalfYear` to filter by
     - Returns: The `Drink`s consumed during `halfYear` and of `type`
     */
    func filterDataByHalfYearAndType(type: DrinkType, halfYear: HalfYear) -> [Drink] {
        
        // If type is the Total Type use filterDataByYear()
        if type.name == Constants.totalKey {
            return self.filterDataByHalfYear(halfYear: halfYear)
        
        // If not use filterDataByYear() and filter for the specified drink type
        } else {
            return self.filterDataByHalfYear(halfYear: halfYear).filter { $0.type == type }
        }
        
    }
    
    /**
     Get the total amount of `Drink`s consumed during the given `HalfYear` and of the given `DrinkType`
     - Parameter type: The `DrinkType` to get the total amount for
     - Parameter halfYear: The `HalfYear` to get the total amount for
     - Returns: The total amount of `Drink`s consumed during `halfYear` and of `type`
     */
    func getTypeAmountByHalfYear(type: DrinkType, halfYear: HalfYear) -> Double {
        // Get the drinks
        let drinks = self.filterDataByHalfYearAndType(type: type, halfYear: halfYear)
        
        // Get the total amount
        var amount = 0.0
        
        for drink in drinks {
            amount += drink.amount
        }
        
        return amount
    }
    
    // MARK: - Yearly Data Methods
    /**
     Get all `Drink`s consumed in the given `Year`
     - Parameter year: The `Year` to filter by
     - Returns: The `Drink`s consumed during `year`
     */
    func filterDataByYear(year: Year) -> [Drink] {
        
        // Create empty Drink array
        var drinks = [Drink]()
        
        // Loop through months in year
        for month in year.data {
            drinks += self.filterDataByMonth(month: month)
        }
        
        // Return drinks
        return drinks
    }
    
    /**
     Get the `Drink`s consumed during the given `Year` and of the given `DrinkType`
     - Parameter type: The `DrinkType` to filter by
     - Parameter year: The `Year` to filter by
     - Returns: The `Drink`s consumed during `year` and of `type`
     */
    func filterDataByYearAndType(type: DrinkType, year: Year) -> [Drink] {
        
        // If type is the Total Type use filterDataByYear()
        if type.name == Constants.totalKey {
            return self.filterDataByYear(year: year)
        
        // If not use filterDataByYear() and filter for the type
        } else {
            return self.filterDataByYear(year: year).filter {
                $0.type == type
            }
        }
    }
    
    /**
     Get the total amount of `Drink`s consumed during a given `Year` and of a given `DrinkType`
     - Parameter type: The `DrinkType` to get the type amount for
     - Parameter year: The `Year` to get the type amount for
     - Returns: The total amount of `Drink`s consumed during `year` and of `type`
     */
    func getTypeAmountByYear(type: DrinkType, year: Year) -> Double {
        // Get the drinks for the given year and type
        let drinks = self.filterDataByYearAndType(type: type, year: year)
        
        // Create amount and set to 0.0
        var amount = 0.0
        
        // Loop through drinks and add to amount
        for drink in drinks {
            amount += drink.amount
        }
        
        return amount
    }
    
    // MARK: - Progress Bar Methods
    /**
     Compute the user's progress to reaching their daily or weekly goal for Progress Bar Display
     - Parameters:
        - type: The `DrinkType` to get the user's progress for
        - date: A `Day` to get the user's progress for
     - Returns: The progress percent towards the user's daily goal
     */
    func getProgressPercent(type: DrinkType, date: Day) -> Double {
        // Get the index of type in drinkTypes
        let typeIndex = self.drinkData.drinkTypes.firstIndex(of: type)!
        
        // Create progress to 0.0
        var progress = 0.0
        
        // Loop through type index...
        for index in 0...typeIndex {
            
            // If the drink is enabled...
            if (self.drinkData.drinkTypes[index].enabled) {
                
                // Add the type's percent to progress
                progress += self.getTypePercentByDay(type: self.drinkData.drinkTypes[index], day: date)
            }
        }
        
        return progress
        
    }
    
    /**
     For a given `DrinkType` and `Day` get the highlight color for use in the Progress Bar
     - Parameters:
        - type: A `DrinkType`
        - date: A `Day`
     - Returns: `"GoalGreen"` if Goal is met; `Color.primary` if grayscale is enabled; result of `getDrinkTypeColor()` otherwise
     */
    func getHighlightColor(type: DrinkType, date: Day) -> Color {
        // Get the total percent using type and dates
        let totalPercent = self.getProgressPercent(type: type, date: date)
        
        // Return "GoalGreen" if the user's goal is met or exceeded
        if totalPercent >= 1.0 {
            return Color("GoalGreen")
            
        } else {
            // If grayscale is enabled, always return Color.primary
            if self.grayscaleEnabled {
                return .primary
            
            // Otherwise return the result of getDrinkTypeColor()
            } else {
                return self.getDrinkTypeColor(type: type)
                
            }
        }
    }
    
    // MARK: - Data Items
    /**
     For a given date and type, return Data Items for each hour in a day
     - Parameters:
        - day: The `Day` to get `DataItem`s for
        - type: The `DrinkType` to get `DataItem`s for
     - Returns: `DataItem`s for each `Hour` in `day`
     */
    func getDataItemsForDay(day: Day, type: DrinkType) -> [DataItem] {
        // Create an empty data items array
        var dataItems = [DataItem]()
        
        let hours = day.getHours()
        
        // Loop through hour in dates
        for hour in hours {
            
            // Get the drinks based on the presense of the Total Type
            let drinks = type.name == Constants.totalKey ? self.filterDataByHour(hour: hour) : self.filterDataByHourAndType(hour: hour, type: type)
            
            // Append the DataItem, using nil for drinks if drink array is empty
            dataItems.append(DataItem(drinks: drinks.isEmpty ? nil : drinks, type: type, date: hour.data))
        }
        
        return dataItems
    }
    
    /**
     For the given `DrinkType`, get `DataItem`s for each `Day` in the given `Week`.
     - Parameters:
        - week: The `Week` to get `DataItem`s for
        - type: The `DrinkType` to get `DataItem`s for
     - Returns: `DataItem`s for each `Day` in `week` and of `type`
     */
    func getDataItemsForWeek(week: Week, type: DrinkType) -> [DataItem] {
        
        // Create Data Items for each day in month
        var dataItems = [DataItem]()
        
        // Loop through days in week
        for day in week.data {
            
            // Get the drinks based on the presense of the Total Type
            let drinks = type.name == Constants.totalKey ? self.filterDataByDay(day: day) : self.filterDataByDayAndType(type: type, day: day)
            
            // Append the DataItem, using nil for drinks if drink array is empty
            dataItems.append(DataItem(drinks: drinks.isEmpty ? nil : drinks, type: type, date: day.data))
        }
        
        return dataItems
        
    }
    
    /**
     For the given `DrinkType`, get the `DataItem`s for the given `Month`
     - Parameters:
        - month: The `Month` to get `DataItem`s for
        - type: The `DrinkType` to get `DataItem`s for
     - Returns: `DataItem`s for each `Day` in `month` of `type`
     */
    func getDataItemsForMonth(month: Month, type: DrinkType) -> [DataItem] {
        
        // Create Data Items for each day in month
        var dataItems = [DataItem]()
        
        // Loop through months
        for day in month.data {
            
            // Get the drinks based on the presense of the Total Type
            let drinks = type.name == Constants.totalKey ? self.filterDataByDay(day: day) : self.filterDataByDayAndType(type: type, day: day)
            
            // Append the DataItem, using nil for drinks if drink array is empty
            dataItems.append(DataItem(drinks: drinks.isEmpty ? nil : drinks, type: type, date: day.data))
        }
        
        // Return data items
        return dataItems
    }
    
    /**
     For a given `DrinkType`, get the `DataItem`s for each `Week` in  the given`HalfYear`
     - Parameters:
        - halfYear: The `HalfYear` to get `DataItem`s for
        - type: The `DrinkType` to get `DataItem`s for
     - Returns: `DataItem`s for each `Week` in `halfYear` of `type`
     */
    func getDataItemsForHalfYear(halfYear: HalfYear, type: DrinkType) -> [DataItem] {
        // Create empty data items array
        var dataItems = [DataItem]()
        
        // For week in half year get drinks and create data items
        for week in halfYear.data {
            
            // Get all drinks in halfYear or all drinks of a specific type in halfYear
            let drinks = type.name == Constants.totalKey ? self.filterDataByWeek(week: week) : self.filterDataByWeekAndType(type: type, week: week)
            
            // Append and create data items
            dataItems.append(DataItem(drinks: drinks.isEmpty ? nil : drinks, type: type, date: week.firstDay()))
        }
        
        return dataItems
    }
    
    /**
     For a given `DrinkType`, get the `DataItem`s for the given `Year`
     - Parameters:
        - year: The `Year` to get `DataItem`s for
        - type: The `DrinkType` to get `DataItem`s for
     - Returns: `DataItem`s for each `Month` in `year` of `type`
     */
    func getDataItemsforYear(year: Year, type: DrinkType) -> [DataItem] {
        // Create empty data items array
        var dataItems = [DataItem]()
        
        // For motnh in year get drinks and create data items
        for month in year.data {
            
            // Get all drinks in month or all drinks of a specific type in month
            let drinks = type.name == Constants.totalKey ? self.filterDataByMonth(month: month) : self.filterDataByMonthAndType(type: type, month: month)
            
            // Create and append DataItems
            dataItems.append(DataItem(drinks: drinks.isEmpty ? nil : drinks, type: type, date: month.firstDay()))
        }
        
        return dataItems
    }
    
    // MARK: - Trends Chart Method
    /**
     Assuming a bar is not selected, return the amount of a `DrinkType` consumed over some `TimePeriod`.
     - Parameters:
        - type: A `DrinkType`
        - dates: `Day`, `Week`, `Month`, `HalfYear`, or `Year` (not strictly required by parameter)
     - Requires: `dates` to conform to `DatesProtocol` for a non-zero return
     - Precondition: In the Trends Chart, a bar is not selected
     - Returns: The amount of a `type` consumed over some time period.
     */
    func getOverallAmount(type: DrinkType, dates: Any?) -> Double {
        
        // If a Day return getTypeAmountByDay()
        if let date = dates as? Day {
            return self.getTypeAmountByDay(type: type, day: date)
            
        // If a Week return getTypeAmountByWeek()
        } else if let date = dates as? Week {
            
            return self.getTypeAmountByWeek(type: type, week: date)
            
        // If a Month return getTypeAmountByMonth()
        } else if let date = dates as? Month {
            
            return self.getTypeAmountByMonth(type: type, month: date)
            
        // If HalfYear return getTypeAmountByHalfYear()
        } else if let date = dates as? HalfYear {
            
            return self.getTypeAmountByHalfYear(type: type, halfYear: date)
            
        // If Year return getTypeAmountByYear()
        } else if let date = dates as? Year {
            
            return self.getTypeAmountByYear(type: type, year: date)
            
        }
        
        // If none of the if/if-else statements trigger return 0.0
        return 0.0
    }
    
    /**
     Get the width of spacers for the Trends Chart based on the given `TimePeriod`
     - Parameters:
        - timePeriod: The current `TimePeriod`
        - isWidget: Whether or not function is called by a Widget
     - Returns: The Maximum Spacer Width; if `isWidget` is true, it always returns 1
     */
    func chartSpacerMaxWidth(timePeriod: TimePeriod, isWidget: Bool) -> CGFloat {
        
        // If not called from a widget
        if !isWidget {
            
            // If daily or weekly return 10
            if timePeriod == .daily || timePeriod == .weekly {
                return 10
                
            // If monthly or yearly return 5
            } else if timePeriod == .monthly || timePeriod == .yearly {
                return 5
            
            // Otherwise return 2
            } else {
                return 2
            }
            
        // If it is, return 1
        } else {
            return 1
        }
    }
    
    /**
     Get the Max Value for an array of `DataItem`s.
     If half-yearly or yearly data is selected, get the total of each individual week and then get the max value.
     - Parameters:
        - dataItems: A `DataItem`s array
        - timePeriod: The current `TimePeriod`
     - Returns: The maximum value for the given `DataItem`s
     */
    func getMaxValue(dataItems: [DataItem], timePeriod: TimePeriod) -> Double {
        // If the time period is not half year  or year, map data items to get max
        if timePeriod != .halfYearly && timePeriod != .yearly {
            return dataItems.map { $0.getMaxValue() }.max() ?? 0.0
            
        // If the time period is half year or year...
        } else {
            var dailyIntake = [Double]()
            
            // Loop through data items
            for item in dataItems {
                
                var amount = 0.0
                
                // Get drinks if they exist
                if let drinks = item.drinks {
                    
                    // Loop through drinks and add to amount
                    for drink in drinks {
                        amount += drink.amount
                    }
                    
                    // Append amount to array
                    dailyIntake.append(amount)
                }
            }
            
            // Get the max of daily intake
            return dailyIntake.map { $0 }.max() ?? 0.0
        }
    }
    
    /**
     Get the average of `Drink`s consumed over a given `TimePeriod` for a given `DrinkType`.
     - Parameters:
        - dataItems: A `DataItem` array
        - timePeriod: The current `TimePeriod`
     - Precondition: `.weekly` or `.monthly` `TimePeriod` for a possible non-zero value
     - Precondition: In the Trends Chart, a bar is selected
     - Returns: The average of
     */
    func getAverage(dataItems: [DataItem], timePeriod: TimePeriod) -> Double {
        // Create sum tracker
        var sum = 0.0
        
        // Loop through data items
        for item in dataItems {
            
            // Get drinks, if they exist
            if let drinks = item.drinks {
                
                // Loop through drinks and add to sum
                for drink in drinks {
                    sum += drink.amount
                }
            }
        }
        
        // If weekly or monthly divide by dataItems count for average
        if timePeriod == .weekly || timePeriod == .monthly {
            return sum/Double(dataItems.count)
        }
        
        // Return 0.0 if a different time period is passed in
        return 0.0
    }
    
    /**
     Return the vertical axis scale in a `String` array depending on the selected `TimePeriod`
     - Parameters:
        - dataItems: Used exclusively for `HalfYear` and `Year`
        - timePeriod: Determines what to return
     - Returns: An array with the appropriate text
     */
    func verticalAxisText(dataItems: [DataItem], timePeriod: TimePeriod) -> [String] {
        
        // Daily Condition
        if timePeriod == .daily {
            return ["12A", "6A", "12P", "6P"]
            
        // Weekly Condition
        } else if timePeriod == .weekly {
            return ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
            
        // Monthly Condition
        } else if timePeriod == .monthly {
            
            // For 28 days
            if dataItems.count == 28 {
                return ["0", "7", "14", "21"]
                
            // For 29 days
            } else if dataItems.count == 29 {
                return ["0", "7", "14", "21", "28"]
                
            // For 30 days
            } else if dataItems.count == 30 {
                return ["0", "6", "12", "18", "24"]
                
            // For 31 days
            } else if dataItems.count == 31 {
                return ["0", "6", "12", "18", "24", "30"]
            }
            
        // Half-Yearly & Yearly Condition
        } else {
            // Create & Setup DateFormatter
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM"
            
            // Create empty String array
            var text = [String]()
            
            // Loop through data items
            for item in dataItems {
                
                // Get formatter string (i.e. April 2022)
                let month = formatter.string(from: item.date)
                
                // Add month to text if already doesn't exist
                if !text.contains(month) {
                    text.append(month)
                }
            }
            
            return text
        }
        
        // Return empty array if none of the if-statements trigger
        return [String]()
    }
    
    /**
     Return the horizontal axis text as a String array.
     If the total amount for a `DataItem`s array is not evenly divisble by 3, increment by 100 until it is.
     - Parameters:
        - type: To `DrinkType` to get the Overall Amount for
        - dates: The object conformant to `DatesProtocol` to get the Overall Amount
     - Requires: `getOverallAmount()` requires `dates` to conform to `DatesProtocol`
     - Returns: A `String` array with 4 values; format relative to Overall Amount: [1, 2/3, 1/3, 0]
     */
    func horizontalAxisText(type: DrinkType, dates: Any?) -> [String] {
        
        // Get the overall amount for the type, time period, and date(s)
        var newAmount = self.getOverallAmount(type: type, dates: dates)
        
        // Increment by 100 until the ceiling is divisible by 3
        while Int(ceil(newAmount)) % 3 != 0 {
            newAmount += 100
        }
        
        // Set 1/3 amount
        let one3 = Int(newAmount/3)
        
        // Set 2/3 amount
        let two3 = Int(2*newAmount/3)
        
        // Create and setup NumberFormatter
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = true
        formatter.maximumSignificantDigits = 2
        
        // Get 1/3, 2/3, 3/3 formatted strings
        if let one = formatter.string(from: NSNumber(value: Int(ceil(newAmount)))), let twoThirds = formatter.string(from: NSNumber(value: Int(two3))), let oneThird = formatter.string(from: NSNumber(value: Int(one3))) {
            
            // Return 3/3, 2/3, 1/3, 0/3 array
            return [one, twoThirds, oneThird, "0"]
        }
        
        // Return empty array if above if-let fails
        return [String]()
    }
    
    /**
     For an array of DataItem, get an array of AXDataPoint using timePeriod
     - Parameters:
        - dataItems: Pull data from `DataItem`s to `AXDataPoint`s
        - timePeriod: Determines how to generate `AXDataPoint`s
        - halfYearOffset: Exclusively used for `dataPointWeekRange()` in `HalfYear`
        - test: Only `true` if called from LiquidusTests; passed into `dataPointWeekRange()`
     - Returns: An array of `AXDataPoint`s
     */
    func seriesDataPoints(dataItems: [DataItem], timePeriod: TimePeriod, halfYearOffset: Int, test: Bool) -> [AXDataPoint] {
        
        // Empty AXDataPoint array
        var output = [AXDataPoint]()
        
        // Daily Condition
        if timePeriod == .daily {
            // Create formatter
            let formatter = DateFormatter()
            formatter.dateFormat = "H"
            
            // Loop through dataItems
            for item in dataItems {
                
                // Create and append AXDataPoints
                output.append(AXDataPoint(x: self.dataPointHourRangeText(item: item), y: item.getIndividualAmount()))
            }
            
        // Weekly/Monthly Condition
        } else if timePeriod == .weekly || timePeriod == .monthly {
            // Create formatter
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            
            // Loop through items
            for item in dataItems {
                
                // Create and append AXDataPoints
                output.append(AXDataPoint(x: formatter.string(from: item.date), y: item.getIndividualAmount()))
            }
            
        // Half-Yearly Condition
        } else if timePeriod == .halfYearly {
            // Loop through data items
            for item in dataItems {
                
                // Append AXDataPoints
                output.append(AXDataPoint(x: self.dataPointWeekRange(item: item, halfYearOffset: halfYearOffset, test: test), y: item.getIndividualAmount()))
            }
            
        // Yearly Condition
        } else if timePeriod == .yearly {
                
            // Date Formatter
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM y"
                
            // Loop through data items
            for item in dataItems {
                    
            // Create and append AXDataPoint
            output.append(AXDataPoint(x: formatter.string(from: item.date), y: item.getIndividualAmount()))
            }
        }
        
        return output
    }
    
    /**
     For a `DataItem`, get the range of the displayed data
     - Parameter item: A `DataItem`
     - Returns: An hour range for the `DataItem`; i.e.` "12 to 1 AM"`, `"11 AM to 12 PM"`, `"11 PM to 12 AM"`
     */
    func dataPointHourRangeText(item: DataItem) -> String {
        // Create Formatter
        let formatter = DateFormatter()
        formatter.dateFormat = "H"
        
        // Create date from item
        let date1 = item.date
        
        // Create date from item advanced by 1 hour
        if let date2 = Calendar.current.date(byAdding: .hour, value: 1, to: item.date) {
        
            // If the dates can be converted to doubles
            if let d1 = Int(formatter.string(from: date1)), let d2 = Int(formatter.string(from: date2)) {
                
                // Condition for 12 to 1 AM
                if d1 == 0 && d2 == 1 {
                    return "12 to 1 AM"
                    
                // Condition for 11 AM to 12 PM
                } else if d1 == 11 && d2 == 12 {
                    return "11 AM to 12 PM"
                    
                // Condition for 12 to 1 PM
                } else if d1 == 12 && d2 == 13 {
                    return "12 to 1 PM"
                    
                // Condition for 11 PM to 12 AM
                } else if d1 == 23 && d2 == 0 {
                    return "11 PM to 12 AM"
                    
                // Condition for all other AM hours
                } else if d1 < 11 && d2 < 12 {
                    return "\(d1) to \(d2) AM"
                   
                // Condition for all other PM hours
                }  else if d1 > 12 && d2 > 13 {
                    return "\(d1-12) to \(d2-12) PM"
                }
            }
        
        }
            
        return ""
    }
    
    /**
     For a DataItem get the week range it represents
     - Parameters:
        - item: A `DataItem`
        - halfYearOffset: Helps determine which `Month` is the first month of the `halfYear`
        - test: Only `true` when called from LiquidusTests; If so uses a specific date to determine return.
     - Returns: The week range of `item` (i.e. April 3rd to 9th, 2022)
     */
    func dataPointWeekRange(item: DataItem, halfYearOffset: Int, test: Bool) -> String {
        
        // Get days in week for item
        let week = Week(date: item.date)
        
        // Create a test date; for use if test = true
        let testDate = Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!
        
        // Get startDate
        // Uses testDate if test = true; if not uses today
        let startDate = Calendar.current.date(byAdding: .month, value: halfYearOffset-6, to: test ? testDate : .now) ?? Date()
        
        // Get endDate
        let endDate = Calendar.current.date(byAdding: .month, value: 1, to: test ? testDate : .now) ?? Date()
                
        // Get the first and last day of the half year
        if let start = Month(date: startDate).data.first, let end = Month(date: endDate).data.last {
            
            // Check if the week contains start or end
            if week.data.contains(start) || week.data.contains(end) {
                
                // Filter out days earlier than start
                let firstWeek = week.data.filter {
                    Calendar.current.compare(start.data, to: $0.data, toGranularity: .month) == .orderedSame && Calendar.current.compare(start.data, to: $0.data, toGranularity: .year) == .orderedSame
                }
                
                // Filter out days later than end
                let secondWeek = week.data.filter {
                    Calendar.current.compare(end.data, to: $0.data, toGranularity: .month) == .orderedSame && Calendar.current.compare(end.data, to: $0.data, toGranularity: .year) == .orderedSame
                }
                                
                // If firstWeek is empty and secondWeek isn't use secondWeek
                // Means that no dates matched start and some dates matched end
                if firstWeek.isEmpty && !secondWeek.isEmpty {
                    return Week(days: secondWeek).accessibilityDescription
                
                // If firstWeek isn't empty and secondWeek is use firstWeek
                // Means that some dates matched start and no dates matched end
                } else if !firstWeek.isEmpty && secondWeek.isEmpty {
                    return Week(days: firstWeek).accessibilityDescription
                    
                }
            }
            
            // If not or the inner if/if-else statements both return false
            return week.accessibilityDescription
        }
        
        return ""
    }
    
    /**
     For the chart return a `String` detailing the data being displayed
     - Parameters:
        - type: The `DrinkType` being represented
        - dates: The `Day`, `Week`, `Month`, `HalfYear` or `Year` being represented
     - Requires: `dates` conform to `DatesProtocol` (checked within method)
     - Returns: The accessibility label for the Chart
     */
    func getChartAccessibilityLabel(type: DrinkType, dates: Any?) -> String {
        
        // Create blank output string
        var output = ""
        
        // If all data is selected
        if type == Constants.totalType {
            output = "Data representing your intake "
            
        // If a specific drink type is selected
        } else {
            output = "Data representing your \(type.name) intake "
        }
        
        if let day = dates as? Day {
            
            if day.accessibilityDescription == "Today" || day.accessibilityDescription == "Yesterday" {
                
                output += "\(day.accessibilityDescription)."
            
            } else {
                
                output += "on \(day.accessibilityDescription)."
            }
        
        } else if let week = dates as? Week {
            output += "from \(week.accessibilityDescription)."
        
        } else if let month = dates as? Month {
            output += "on \(month.accessibilityDescription)."
            
        } else if let halfYear = dates as? HalfYear {
            output += "from \(halfYear.accessibilityDescription)."
            
        } else if let year = dates as? Year {
            output += "from \(year.accessibilityDescription)."
            
        } else {
            // Returns an empty string if can't cast
            return ""
        }
        
        // Return output string
        return output
    }
    
    // MARK: - HealthKit Methods
    /**
     Convert stored unit to `HKUnit`
     - Returns: The associated `HKUnit` with the stored unit
     */
    func getHKUnit() -> HKUnit {
        if self.drinkData.units == Constants.cupsUS {
            return HKUnit.cupUS()
            
        } else if self.drinkData.units == Constants.fluidOuncesUS {
            return HKUnit.fluidOunceUS()
            
        } else if self.drinkData.units == Constants.liters {
            return HKUnit.liter()
            
        } else if self.drinkData.units == Constants.milliliters {
            return HKUnit.literUnit(with: .milli)
            
        }
        
        return HKUnit.literUnit(with: .milli)
        
    }
    
    /**
     Retrieve data from HealthKit
     - Parameter statsCollection: The data extracted from Apple Health
     */
    func retrieveFromHealthKit(_ statsCollection: HKStatisticsCollection) {
        
        // Get start and end date
        let startDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())!
        let endDate = Date()
        
        // Go through every date pulled from HealthKit
        statsCollection.enumerateStatistics(from: startDate, to: endDate) { stats, stop in
            
            // Get the summed amount converted to unit based on user preference
            let amount = stats.sumQuantity()?.doubleValue(for: self.getHKUnit())
            
            // Create a drink
            let water = self.drinkData.drinkTypes.first { type in
                type.name == Constants.waterKey
            }
            
            let drink = Drink(type: water!, amount: amount ?? 0, date: stats.startDate)
            
            // If some amount was consumed and the drink doesn't already exist in the ViewModel...
            if drink.amount > 0 && !self.drinkData.drinks.contains(drink) {
                // Add the drink to the ViewModel
                DispatchQueue.main.async {
                    self.addDrink(drink: drink)
                }
            }
        }
    }
    
    /**
     Save a drink to HealthKit
     */
    func saveToHealthKit() {
        
        // Create HKType
        let waterType = HKSampleType.quantityType(forIdentifier: .dietaryWater)!
        
        // Check that healthStore exists
        if self.healthStore != nil && self.healthStore?.healthStore != nil {
            
            // Loop through drink store
            for drink in self.drinkData.drinks {
                
                // Check if lastHKSave exists, compare it (if exists) against the drink's
                // date, and check the type is Water
                if (self.drinkData.lastHKSave == nil || self.drinkData.lastHKSave ?? Date() < drink.date) && drink.type.name == Constants.waterKey {
                    
                    // Assign startDate and endDate
                    let startDate = drink.date
                    let endDate = startDate
                    
                    // Get the quanity as HKQuantity
                    let quantity = HKQuantity(unit: self.getHKUnit(), doubleValue: drink.amount)
                    
                    // Create a HKQuantitySample
                    let sample = HKQuantitySample(type: waterType, quantity: quantity, start: startDate, end: endDate)
                    
                    // Save to HealthKit
                    self.healthStore!.healthStore!.save(sample) { success, error in
                        
                        // Update lastHKSave
                        DispatchQueue.main.async {
                            self.drinkData.lastHKSave = Date()
                        }
                    }
                }
            }
        }
    }
}
