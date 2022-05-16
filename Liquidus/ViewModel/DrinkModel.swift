//
//  DrinkModel.swift
//  Hydration App
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

class DrinkModel: ObservableObject {
    
    @Published var drinkData = DrinkData()
    @Published var weeksPopulated = false
    
    @Published var selectedDay = Date()
    @Published var selectedWeek = [Date]()
    
    @Published var healthStore: HealthStore?
    
    @Published var grayscaleEnabled = UIAccessibility.isGrayscaleEnabled
        
    init(test: Bool, suiteName: String?) {
        // Create HealthStore
        healthStore = HealthStore()
        
        // Retrieve data from UserDefaults
        if !test || suiteName != nil {
            retrieve(test: suiteName != nil ? true : false)
        }
        
        // If unable to retrieve from UserDefaults (or Unit Testing), create a new DrinkData
        self.drinkData = DrinkData()
    }
    
    func retrieve(test: Bool) {
        if let userDefaults = UserDefaults(suiteName: test ? Constants.unitTestingKey : Constants.sharedKey) {
            if let data = userDefaults.data(forKey: Constants.savedKey) {
                if let decoded = try? JSONDecoder().decode(DrinkData.self, from: data) {
                    self.drinkData = decoded
                    
                    self.selectedWeek = self.getWeek(date: Date())
                    return
                }
            }
        }
    }
    
    /**
     Save any changes made to Drink Data
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
     Add a drink to Drink Data and save changes. If it's water sync with Apple Health if access is granted. Widgets will be updated as well.
     */
    func addDrink(drink: Drink) {
        DispatchQueue.main.async {
            // Add drink
            self.drinkData.drinks.append(drink)
            
            // If it's water, save to HealthKit
            if drink.type.name == Constants.waterKey && drink.type.enabled {
                self.saveToHealthKit()
            }
            
            // Save to UserDefaults
            self.save(test: false)
        }
        
        // Update widget
        WidgetCenter.shared.reloadAllTimelines()
        
    }
    
    func addYearDrinks() {
        // Get current year
        let year = self.getYear(date: .now)
        
        // Empty drink array
        var allDrinks = [Drink]()
        
        // Get water
        let water = self.drinkData.drinkTypes.first!
        
        // Loop through months in year
        for month in year {
            
            // Loop through days in month
            for day in month {
                // Get a random double btwn 0 and 1,600
                let rand = Double.random(in: 0...1600)
                
                // Append a Drink
                allDrinks.append(Drink(type: water, amount: rand, date: day))
            }
        }
        
        self.drinkData.drinks = allDrinks
    }
    
    // MARK: - Time Display Functions
    /**
     Checks if the week after the given week has happened yet or is happening
     */
    func isNextWeek(currentWeek: [Date]) -> Bool {
        let calendar = Calendar.current
        
        // Get the next week per currentWeek and the next week per today
        let nextWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: currentWeek[0]) ?? .now
        let upcomingWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: .now) ?? .now
        
        // Return result doesDateFallInSameWeek()
        return self.doesDateFallInSameWeek(date1: nextWeek, date2: upcomingWeek)
        
    }
    
    /**
     Checks if the month after the given month has happened yet or is happening
     */
    func isNextMonth(currentMonth: [Date]) -> Bool {
        let calendar = Calendar.current
        
        // Get the next month per currentMonth and today
        let nextMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth[0]) ?? Date()
        let upcomingMonth = calendar.date(byAdding: .month, value: 1, to: .now) ?? Date()
        
        // If both months fall are the same return true
        if Calendar.current.compare(nextMonth, to: upcomingMonth, toGranularity: .month) == .orderedSame {
            return true
        } else {
            return false
        }
    }
    
    /**
     Check if the next month in the half year has happened yet
     */
    func isNextHalfYear(currentHalfYear: [[Date]]) -> Bool {
        // Get last month in year and call isNextMonth()
        if let lastMonth = currentHalfYear.last {
            return self.isNextMonth(currentMonth: lastMonth)
        }
        
        // If can't always return false
        return false
    }
    
    func isNextYear(currentYear: [[Date]]) -> Bool {
        // Get last month in year and call isNextMonth()
        if let lastMonth = currentYear.last {
            return self.isNextMonth(currentMonth: lastMonth)
        }
        
        // If can't always return false
        return false
    }
    
    /**
     Get a week range as a String for the given week
     */
    func getWeekText(week: [Date]) -> String {
        // Create a date formatter
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        
        // Get first and last days in week
        if let first = week.first, let last = week.last {
            
            // If the year is the same
            if Calendar.current.compare(first, to: last, toGranularity: .year) == .orderedSame {
                
                // Get year string
                let year = formatter.string(from: first)
                
                // Format for month
                formatter.dateFormat = "MMM"
                
                // If the month is the same...
                if Calendar.current.compare(first, to: last, toGranularity: .month) == .orderedSame {
                    
                    // Get date1
                    formatter.dateFormat = "MMM d"
                    
                    let date1 = formatter.string(from: first)
                    
                    // Get date2
                    formatter.dateFormat = "d"
                    
                    let date2 = formatter.string(from: last)
                    
                    return "\(date1)-\(date2), \(year)"
                    
                // If not...
                } else {
                    
                    // Formatt for month and day
                    formatter.dateFormat = "MMM d"
                    
                    // Get dates
                    let date1 = formatter.string(from: first)
                    let date2 = formatter.string(from: last)
                    
                    return "\(date1) - \(date2), \(year)"
                    
                }
            } else {
                // Format for month and day
                formatter.dateFormat = "MMM d, yyyy"
                
                // Get dates
                let date1 = formatter.string(from: first)
                let date2 = formatter.string(from: last)
                
                return "\(date1) - \(date2)"
            }
        }
        
        return ""
    }
    
    /**
     Get a week range as a String specifically for Accessibility Labels throughout the app
     */
    func getAccessibilityWeekText(week: [Date]) -> String {
        // Create a date formatter
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        
        // Get first and last days in week
        if let first = week.first, let last = week.last {
            
            // If the year is the same
            if Calendar.current.compare(first, to: last, toGranularity: .year) == .orderedSame {
                
                // Get current year
                let year = formatter.string(from: first)
                
                // Format for month (i.e. Apr)
                formatter.dateFormat = "MMM"
                
                // If the month is the same...
                if Calendar.current.compare(first, to: last, toGranularity: .month) == .orderedSame {
                    
                    // Set formatter (i.e. Apr 8)
                    formatter.dateFormat = "MMM d"
                    
                    // Get date1
                    let date1 = formatter.string(from: first)
                    
                    // Set formatter (i.e. 8)
                    formatter.dateFormat = "d"
                    
                    // Get date2
                    let date2 = formatter.string(from: last)
                    
                    // Set format (i.e. 08)
                    formatter.dateFormat = "dd"
                    
                    // Get suffixes
                    let suffix1 = getDateSuffix(date: formatter.string(from: first))
                    let suffix2 = getDateSuffix(date: formatter.string(from: last))
                    
                    return "\(date1)\(suffix1) to \(date2)\(suffix2), \(year)"
                    
                // If not...
                } else {
                    
                    // Formatt for month and day
                    formatter.dateFormat = "MMM d"
                    
                    // Get month-day strings
                    let date1 = formatter.string(from: first)
                    let date2 = formatter.string(from: last)
                    
                    // Format for day
                    formatter.dateFormat = "d"
                    
                    // Get suffix strings
                    let suffix1 = self.getDateSuffix(date: formatter.string(from: first))
                    let suffix2 = self.getDateSuffix(date: formatter.string(from: last))
                    
                    return "\(date1)\(suffix1) to \(date2)\(suffix2), \(year)"
                    
                }
            // If not
            } else {
                // Format for month and day
                formatter.dateFormat = "MMM d"
                
                // Get month-day strings
                let monthDay1 = formatter.string(from: first)
                let monthDay2 = formatter.string(from: last)
                
                // Format for the day
                formatter.dateFormat = "d"
                
                // Get suffixes
                let suffix1 = self.getDateSuffix(date: formatter.string(from: first))
                let suffix2 = self.getDateSuffix(date: formatter.string(from: last))
                
                // Format for year
                formatter.dateFormat = "yyyy"
                
                // Get year string
                let year1 = formatter.string(from: first)
                let year2 = formatter.string(from: last)
                
                return "\(monthDay1)\(suffix1), \(year1) to \(monthDay2)\(suffix2), \(year2)"
            }
        }
        
        return ""
    }
    
    /**
     Get a date suffix (st, nd, rd, th). Used exclusively in getAccessibilityWeekText().
     */
    func getDateSuffix(date: String) -> String {
        // Get the number of characters in string
        let count = date.count
        
        // Store date in new variable
        var num = date
        
        // If the count is 2
        if count == 2 {
            // If 11, 12, or 13, return "th"
            if date == "11" || date == "12" || date == "13" {
                return "th"
            }
            
            // Otherwise, drop the first character
            num = String(date.dropFirst(1))
        }
        
        switch num {
        case "1":
            return "st"
        case "2":
            return "nd"
        case "3":
            return "rd"
        default:
            return "th"
        }
    }
    
    /**
     Get a month range as a string for a given half year
     */
    func getHalfYearText(halfYear: [[Date]]) -> String {
        // Create a date formatter
        let formatter = DateFormatter()
        
        // Format for year only
        formatter.dateFormat = "yyyy"
        
        // If the year is the same...
        if let first = halfYear.first?.first, let last = halfYear.last?.first {
            if formatter.string(from: first) == formatter.string(from: last) {
                
                let year = formatter.string(from: first)
                
                // Format for month
                formatter.dateFormat = "MMM"
                
                let month1 = formatter.string(from: first)
                let month2 = formatter.string(from: last)
                
                return "\(month1) - \(month2), \(year)"
            } else {
                // Format for month and day
                formatter.dateFormat = "MMM yyyy"
                
                // Get dates
                let date1 = formatter.string(from: first)
                let date2 = formatter.string(from: last)
                
                return "\(date1) - \(date2)"
            }
        }
        
        return ""
    }
    
    /**
     Get a month range as a String for a given half year exclusively for Accessibility Labels throughout the app
     */
    func getAccessibilityHalfYearText(halfYear: [[Date]]) -> String {
        // Create a date formatter
        let formatter = DateFormatter()
        
        // Format for year only
        formatter.dateFormat = "yyyy"
        
        // If the year is the same...
        if let first = halfYear.first?.first, let last = halfYear.last?.first {
            if formatter.string(from: first) == formatter.string(from: last) {
                
                let year = formatter.string(from: first)
                
                // Format for month
                formatter.dateFormat = "MMM"
                
                let month1 = formatter.string(from: first)
                let month2 = formatter.string(from: last)
                
                return "\(month1) to \(month2), \(year)"
            } else {
                // Format for month and day
                formatter.dateFormat = "MMM yyyy"
                
                // Get dates
                let date1 = formatter.string(from: first)
                let date2 = formatter.string(from: last)
                
                return "\(date1) to \(date2)"
            }
        }
        
        return ""
    }
    
    
    // MARK: - Drink Types
    /**
     Delete a custom drink type
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
     For a drink type (as a string) get the associated color. If the color for a default drink type hasn't been changed, return a system color. Otherwise and for custom drink types, return the stored color.
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
     Get a color gradient based using all drink type colors
     */
    func getDrinkTypeGradient() -> LinearGradient {
        if self.grayscaleEnabled {
            // Return solid white gradient
            return LinearGradient(colors: [.white], startPoint: .top, endPoint: .bottom)
            
        } else {
            // Return rainbow gradient
            return LinearGradient(colors: [.red, .orange, .yellow, .green, .blue, .purple], startPoint: .top, endPoint: .bottom)
        }
    }
    
    /**
     Return all drinks of a specific type
     */
    func filterByDrinkType(type: DrinkType) -> [Drink] {
        // Filter drinks by type
        return self.drinkData.drinks.filter { $0.type == type }
    }
    
    /**
     Return the total amount of all drinks of a specific type
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
     Return the total amount of all drinks
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
     Return the average for all drinks of a specific type
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
     Create a new drink using the given String and Color. Update enabled array, custom drink types array, color array, and colorChanged array.
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
     For a given amount return a specifier so a double will have 0 or 2 decimal points displayed
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
     For an old unit and new unit, convert all measurements to the new unit
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
     For a given date, return drinks for the date and hour
     */
    func filterDataByHour(hour: Date) -> [Drink] {
        
        // Filter for drinks in the same hour, day, month, and year as date and drinks
        // that have an enabled type
        return self.drinkData.drinks.filter {
            Calendar.current.compare($0.date, to: hour, toGranularity: .hour) == .orderedSame && Calendar.current.compare($0.date, to: hour, toGranularity: .day) == .orderedSame && Calendar.current.compare($0.date, to: hour, toGranularity: .month) == .orderedSame && Calendar.current.compare($0.date, to: hour, toGranularity: .year) == .orderedSame && $0.type.enabled
        }
    }
    
    func filterDataByHourAndType(hour: Date, type: DrinkType) -> [Drink] {
        return self.filterDataByHour(hour: hour).filter { $0.type == type }
    }
    
    /**
     Get the amount for the given type for a given date and hour
     */
    func getTypeAmountByHour(type: DrinkType, time: Date) -> Double {
        // Get drinks for the hour
        let drinks = self.filterDataByHour(hour: time).filter { $0.type == type }
        
        // Get total amount for the hour
        var totalAmount = 0.0
        for drink in drinks {
            totalAmount += drink.amount
        }
        
        return totalAmount
    }
    
    // MARK: - Data by Day Functions
    /**
     Filter all drinks by the day from the given date
     */
    func filterDataByDay(day: Date) -> [Drink] {
        
        // Filter for drinks in the same day, month, and year as date and drinks
        // that have an enabled type
        return self.drinkData.drinks.filter {
            Calendar.current.compare($0.date, to: day, toGranularity: .day) == .orderedSame && Calendar.current.compare($0.date, to: day, toGranularity: .month) == .orderedSame && Calendar.current.compare($0.date, to: day, toGranularity: .year) == .orderedSame && $0.type.enabled
        }
    }
    
    /**
     Filter all drinks by the given drink type and date
     */
    func filterDataByDayAndType(type: DrinkType, day: Date) -> [Drink] {
        
        // If type is the Total Type use filterDataByYear()
        if type.name == Constants.totalKey {
            return self.filterDataByDay(day: day)
            
        // If not use filterDataByYear() and filter for the given type
        } else {
            return self.filterDataByDay(day: day).filter { $0.type == type }
        }
    }
    
    /**
     Get the total amount for the given type for a given day
     */
    func getTypeAmountByDay(type: DrinkType, date: Date) -> Double {
        // Get the filtered data for the day
        let drinks = self.filterDataByDayAndType(type: type, day: date)
        
        // Add up all the amounts
        var totalAmount = 0.0
        for drink in drinks {
            totalAmount += Double(drink.amount)
        }
        
        return totalAmount
    }
    
    /**
     Get the total percent for the amount consumed vs. the user's daily goal for a given type
     */
    func getTypePercentByDay(type: DrinkType, date: Date) -> Double {
        
        // Get the amount of liquid consumed by liquid and date
        let amount = self.getTypeAmountByDay(type: type, date: date)
        
        // Get percentage
        let percent = amount / self.drinkData.dailyGoal
        
        return percent
    }
    
    /**
     Get the total amount consumed for the given day
     */
    func getTotalAmountByDay(date: Date) -> Double {
        // Track total amount
        var amount = 0.0
        
        // Filter through drinks in day and add to amount
        for drink in self.filterDataByDay(day: date) {
            amount += drink.amount
        }
        
        return amount
    }
    
    /**
     Get the total percent for the amount consumed vs. the user's daily goal
     */
    func getTotalPercentByDay(date: Date) -> Double {
        
        // Get total amount
        let totalAmount = getTotalAmountByDay(date: date)
        
        // Get percentage
        let percent = totalAmount / self.drinkData.dailyGoal
        
        return percent
    }
    
    // MARK: - Data by Week Functions
    /**
     For a given date get the week range (i.e. April 6-12, 2003). Varries for weeks across months and years.
     */
    func getWeekRange(date: Date) -> [Date] {
        
        // Get the number for the day of the week (Sun = 1 ... Sat = 7)
        let dayNum = Calendar.current.dateComponents([.weekday], from: date).weekday
        
        // If there is a non-nil value...
        if dayNum != nil {
            
            // If it's Sunday...
            if dayNum == 1 {
                // Get the Saturday for that week
                let endDate = Calendar.current.date(byAdding: .day, value: 6, to: date)!
                
                return [date, endDate]
                
            // If it's a day from Monday to Friday...
            } else if dayNum! > 1 && dayNum! < 7 {
                
                // Get the difference between the current day and the Sunday and Saturday of that week
                let startDiff = -1 + dayNum!
                let endDiff = 7 - dayNum!
                
                // Get the exact dates
                let startDate = Calendar.current.date(byAdding: .day, value: -startDiff, to: date)!
                let endDate = Calendar.current.date(byAdding: .day, value: endDiff, to: date)!
                
                return [startDate, endDate]
                
            // If it's Saturday...
            } else if dayNum == 7 {
                // Get the Sunday for that week
                let startDate = Calendar.current.date(byAdding: .day, value: -6, to: date)!
                
                return [startDate, date]
                
            } else {
                return [Date]()
            }
            
        } else {
            return [Date]()
        }
    }
    
    /**
     Return an array with each day for the week of a given day
     */
    func getWeek(date: Date) -> [Date] {
        // Get the week range
        let weekRange = self.getWeekRange(date: date)
        
        // If the array isn't empty...
        if weekRange.count == 2 {
            
            // Get the exact day for each day of the week
            let sunday = weekRange[0]
            let monday = Calendar.current.date(byAdding: .day, value: 1, to: sunday)!
            let tuesday = Calendar.current.date(byAdding: .day, value: 2, to: sunday)!
            let wednesday = Calendar.current.date(byAdding: .day, value: 3, to: sunday)!
            let thursday = Calendar.current.date(byAdding: .day, value: 4, to: sunday)!
            let friday = Calendar.current.date(byAdding: .day, value: 5, to: sunday)!
            let saturday = weekRange[1]
            
            // Update weeksPopulated if false
            if !self.weeksPopulated {
                weeksPopulated = true
            }
            
            return [sunday, monday, tuesday, wednesday, thursday, friday, saturday]
        }
        
        // Else return an empty array
        return [Date]()
    }
    
    /**
     For all drinks, get the drinks consumed in the given week
     */
    func filterDataByWeek(week: [Date]) -> [Drink] {
        
        // Filter drinks in the same week and those that have an enabled type
        return self.drinkData.drinks.filter {
            Calendar.current.compare(week[0], to: $0.date, toGranularity: .weekOfYear) == .orderedSame && $0.type.enabled
        }
    }
    
    /**
     For all drinks, get all drinks in a given week that belong to the given drink type
     */
    func filterDataByWeekAndType(type: DrinkType, week: [Date]) -> [Drink] {
        
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
     For all drinks in given week, get the total amount consumed for a given type
     */
    func getTypeAmountByWeek(type: DrinkType, week: [Date]) -> Double {
        
        // Get the drink data for the week
        let drinks = self.filterDataByWeekAndType(type: type, week: week)
        
        // Get the total amount
        var totalAmount = 0.0
        for drink in drinks {
            totalAmount += drink.amount
        }
        
        return totalAmount
    }
    
    /**
     For all drinks in a given week, get the total percentage of drinks consumed vs. the user's weekly goal for a given type
     */
    func getTypePercentByWeek(type: DrinkType, week: [Date]) -> Double {
        
        // Get the amount
        let amount = self.getTypeAmountByWeek(type: type, week: week)
        
        // Calculate percentage
        let percent = amount / (self.drinkData.dailyGoal*7)
        
        return percent
    }
    
    /**
     For all drinks in a given week, get the total amount consumed
     */
    func getTotalAmountByWeek(week: [Date]) -> Double {
        // Track the total amount
        var amount = 0.0
        
        // Loop through drinks in week and add to amount
        for drink in self.filterDataByWeek(week: week) {
            amount += drink.amount
        }
        
        return amount
    }
    
    /**
     For all drinks in a given week, get the total percentage of drinks consumed vs. the user's weekly goal
     */
    func getTotalPercentByWeek(week: [Date]) -> Double {
        
        // Get the total amount
        let totalAmount = self.getTotalAmountByWeek(week: week)
        
        // Calculate the percentage
        let percent = totalAmount / (self.drinkData.dailyGoal*7)
        
        return percent
    }
    
    /**
     For two dates determine if they are in the same week
     */
    func doesDateFallInSameWeek(date1: Date, date2: Date) -> Bool {
        // Get weeks from date1 and date2
        let week1 = self.getWeek(date: date1)
        let week2 = self.getWeek(date: date2)
        
        // Create a date formatter
        let dateFormatter = DateFormatter()
        
        // Only include the date not time
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        // Loop for days in week1
        for dayA in week1 {
            
            // Loop through days in week 2
            for dayB in week2 {
                
                // If two days are the same...
                if dateFormatter.string(from: dayA) == dateFormatter.string(from: dayB) {
                    return true
                }
            }
        }
        
        // If no two days are the same
        return false
    }
    
    // MARK: - Data by Month Functions
    /**
     For a date, return its month in a Date array
     */
    func getMonth(day: Date) -> [Date] {
        // Date Formatter
        let formatter = DateFormatter()
        formatter.dateFormat = "y"
        
        // Get the current year
        var currentYear = 0
        if let year = Int(formatter.string(from: day)) {
            currentYear = year
        }
        
        // Get the current month
        formatter.dateFormat = "M"
        var currentMonth = 0
        if let month = Int(formatter.string(from: day)) {
            currentMonth = month
        }
        
        // If currentYear and currentMonth are greater than zero...
        if currentYear > 0 && currentMonth > 0 {
            
            // Get date components
            let components = DateComponents(year: currentYear, month: currentMonth)
            
            // Get date from components
            if let date = Calendar.current.date(from: components) {
                
                // Get range for date
                if let range = Calendar.current.range(of: .day, in: .month, for: date) {
                   
                    // Get the max of the range
                    if let max = range.max() {
                        var dates = [Date]()
                        
                        // Generate an array with each date in the month
                        for index in 1...max {
                            if let date = Calendar.current.date(from: DateComponents(year: currentYear, month: currentMonth, day: index)) {
                                dates.append(date)
                            }
                        }
                        
                        return dates
                    }
                }
            }
        }
        
        // If any of the if or if-let statements fail return an empty array
        return [Date]()
    }
    
    /**
     For all drinks, return drinks that were logged in the given month
     */
    func filterDataByMonth(month: [Date]) -> [Drink] {
        // Filter drinks in the same month and year as the first day of month
        return self.drinkData.drinks.filter {
            Calendar.current.compare(month[0], to: $0.date, toGranularity: .month) == .orderedSame && Calendar.current.compare(month[0], to: $0.date, toGranularity: .year) == .orderedSame && $0.type.enabled
        }
    }
    
    /**
     For all drinks, return drinks in the given month and of the given drink type
     */
    func filterDataByMonthAndType(type: DrinkType, month: [Date]) -> [Drink] {
        
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
     For all drinks get the total amount consumed for the given month and of the given drink type
     */
    func getTypeAmountByMonth(type: DrinkType, month: [Date]) -> Double {
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
     For a given date, generate a half year, with the month of given date at the end of the array
     */
    func getHalfYear(date: Date) -> [[Date]] {
        // Get the year for the given date
        let year = self.getYear(date: date)
        
        // Create an empty 2D Date array
        var halfYear = [[Date]]()
        
        // Loop through the 7th to 12th months of year and append
        for index in 6...11 {
            halfYear.append(year[index])
        }
        
        // Break up halfYear into a 2D array of weeks
        return self.getWeeksForHalfYear(halfYear: halfYear)
    }
    
    /**
     For a given half year, return it with each index of the array corresponding with a week in the 6-month period
     */
    func getWeeksForHalfYear(halfYear: [[Date]]) -> [[Date]] {
        // Dictionary to store dates
        var weeks = [[Date]]()
        
        // Tracks how many months are processed
        var monthCount = 0
        
        // Loop through halfYear
        for i1 in 0..<halfYear.count {
            
            // Loop through the indicies of month incrementing by 7
            for i2 in stride(from: 0, through: halfYear[i1].count, by: 7) {
                
                // When i1 is 0 and i2 is not 0 OR the last week contains the associated day
                if !(i1 > 0 && i2 == 0) || !(weeks.last?.contains(halfYear[i1][i2]) ?? true) {
                    // If index doesn't exceed the count of month
                    if i2 < halfYear[i1].count {
                        
                        // Append the week for the specified day using i1 and i2
                        weeks.append(self.getWeek(date: halfYear[i1][i2]))
                        
                    // If index is the same or exceeds the count of month
                    } else if i2 >= halfYear[i1].count {
                        
                        // Assign i2 a new variable
                        var i = i2
                        
                        // Decrement i until i is less than the count of the given week
                        while i >= halfYear[i1].count {
                            i -= 1
                        }
                        
                        // Append the week for the specified day using i1 and i
                        weeks.append(self.getWeek(date: halfYear[i1][i]))
                    }
                }
            }
            
            // Increment monthCount
            monthCount += 1
        }
        
        // Remove any dates that are not in the first month
        weeks[0] = weeks[0].filter { $0 >= halfYear[0].first! }
        
        // Get the count of the last month in dictionary
        let dCount = weeks.count-1
        
        // Get the count of the last month in halfYear
        let hCount = halfYear.count-1
        
        // Filter out any days past the last day in the half year
        weeks[dCount] = weeks[dCount].filter { $0 <= halfYear[hCount].last! }
        
        // Return week arangement of the half year
        return weeks
    }
    
    /**
     For all drinks, get the drinks in the given half year
     */
    func filterDataByHalfYear(halfYear: [[Date]]) -> [Drink] {
        
        // Empty drink array
        var drinks = [Drink]()
        
        // Loop through each week and append the drinks that are in each month
        for week in halfYear {
            for drink in self.filterDataByWeek(week: week) {
                drinks.append(drink)
            }
        }
        
        // Sort drinks by date
        drinks.sort { $0.date  < $1.date }
        
        return drinks
    }
    
    /**
     For all drinks, get the drinks in the given half year and of the given drink type
     */
    func filterDataByHalfYearAndType(type: DrinkType, halfYear: [[Date]]) -> [Drink] {
        
        // If type is the Total Type use filterDataByYear()
        if type.name == Constants.totalKey {
            return self.filterDataByHalfYear(halfYear: halfYear)
        
        // If not use filterDataByYear() and filter for the specified drink type
        } else {
            return self.filterDataByHalfYear(halfYear: halfYear).filter { $0.type == type }
        }
        
    }
    
    /**
     Get the total amount of drinks consumed for the given half year and of the given type
     */
    func getTypeAmountByHalfYear(type: DrinkType,  halfYear: [[Date]]) -> Double {
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
     For a given date, generate a year going back from the month of the given date
     */
    func getYear(date: Date) -> [[Date]] {
        // Create an empty array for the months in the year
        var months = [Date]()
        
        // Get a day in each month of 12-month period
        for index in -11...0 {
            if let newDate = Calendar.current.date(byAdding: .month, value: index, to: date) {
                months.append(newDate)
            }
        }
        
        // Create empty output array
        var output = [[Date]]()
        
        // Loop through months
        for month in months {
            
            // Append the output of getMonth() for month
            output.append(self.getMonth(day: month))
        }
        
        return output
    }
    
    /**
     For all drinks, return all drinks consumed in the given year
     */
    func filterDataByYear(year: [[Date]]) -> [Drink] {
        
        // Create empty Drink array
        var drinks = [Drink]()
        
        // Loop through months in year
        for month in year {
            
            // Attempt to get the first day in the month
            if let first = month.first {
                
                // Add the drinks that are in the same month and have an enabled type
                drinks += self.drinkData.drinks.filter {
                    Calendar.current.compare(first, to: $0.date, toGranularity: .month) == .orderedSame && $0.type.enabled
                }
            }
        }
        
        // Return drinks
        return drinks
    }
    
    /**
     For all drinks, get the drinks in the given year and of the given drink type
     */
    func filterDataByYearAndType(type: DrinkType, year: [[Date]]) -> [Drink] {
        
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
     For a given year, get the total amount consumed of a given drink type
     */
    func getTypeAmountByYear(type: DrinkType, year: [[Date]]) -> Double {
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
     */
    func getProgressPercent(type: DrinkType, dates: Any) -> Double {
        // Get the index of type in drinkTypes
        let typeIndex = self.drinkData.drinkTypes.firstIndex(of: type)!
        
        // Create progress to 0.0
        var progress = 0.0
        
        // If selectedTimePeriod is Day...
        if let date = dates as? Date {
            
            // Loop through type index...
            for index in 0...typeIndex {
                
                // If the drink is enabled...
                if (self.drinkData.drinkTypes[index].enabled) {
                    
                    // Add the type's percent to progress
                    progress += self.getTypePercentByDay(type: self.drinkData.drinkTypes[index], date: date)
                }
            }
            
        // If selectedTimePeriod is Week...
        } else if let dates = dates as? [Date] {
            
            // Loop through type index...
            for index in 0...typeIndex {
                
                // If the drink is enabled...
                if (self.drinkData.drinkTypes[index].enabled) {
                    
                    // Add the type's percent to progress
                    progress += self.getTypePercentByWeek(type: self.drinkData.drinkTypes[index], week: dates)
                }
            }
        }
        
        return progress
        
    }
    
    /**
     For a given type and Date or [Date] get the highlight color for use in the Progress Bar
     */
    func getHighlightColor(type: DrinkType, dates: Any) -> Color {
        // Get the total percent using type and dates
        let totalPercent = self.getProgressPercent(type: type, dates: dates)
        
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
     */
    func getDataItemsForDay(date: Date, type: DrinkType) -> [DataItem] {
        // Create an empty date array
        var dates = [Date]()
        
        // Append dates for each hour in the day
        for num in 0...23 {
            if let date = Calendar.current.date(bySettingHour: num, minute: 0, second: 0, of: date) {
                dates.append(date)
            }
        }
        
        // Create an empty data items array
        var dataItems = [DataItem]()
        
        // Loop through hour in dates
        for hour in dates {
            
            // Get the drinks based on the presense of the Total Type
            let drinks = type.name == Constants.totalKey ? self.filterDataByHour(hour: hour) : self.filterDataByHourAndType(hour: hour, type: type)
            
            // Append the DataItem, using nil for drinks if drink array is empty
            dataItems.append(DataItem(drinks: drinks.isEmpty ? nil : drinks, type: type, date: hour))
        }
        
        return dataItems
    }
    
    /**
     For a given week and drink type, get and return Data Items for each day in the week.
     */
    func getDataItemsForWeek(week: [Date], type: DrinkType) -> [DataItem] {
        
        // Create Data Items for each day in month
        var dataItems = [DataItem]()
        
        // Loop through days in week
        for day in week {
            
            // Get the drinks based on the presense of the Total Type
            let drinks = type.name == Constants.totalKey ? self.filterDataByDay(day: day) : self.filterDataByDayAndType(type: type, day: day)
            
            // Append the DataItem, using nil for drinks if drink array is empty
            dataItems.append(DataItem(drinks: drinks.isEmpty ? nil : drinks, type: type, date: day))
        }
        
        return dataItems
        
    }
    
    /**
     For a given month and drink type, get the data items for the month
     */
    func getDataItemsForMonth(month: [Date], type: DrinkType) -> [DataItem] {
        
        // Create Data Items for each day in month
        var dataItems = [DataItem]()
        
        // Loop through months
        for day in month {
            
            // Get the drinks based on the presense of the Total Type
            let drinks = type.name == Constants.totalKey ? self.filterDataByDay(day: day) : self.filterDataByDayAndType(type: type, day: day)
            
            // Append the DataItem, using nil for drinks if drink array is empty
            dataItems.append(DataItem(drinks: drinks.isEmpty ? nil : drinks, type: type, date: day))
        }
        
        // Return data items
        return dataItems
    }
    
    /**
     For a given Half-Year and drink type, get the data items for each week in Half Year
     */
    func getDataItemsForHalfYear(halfYear: [[Date]], type: DrinkType) -> [DataItem] {
        // Create empty data items array
        var dataItems = [DataItem]()
        
        // For week in half year get drinks and create data items
        for week in halfYear {
            
            // Get all drinks in halfYear or all drinks of a specific type in halfYear
            let drinks = type.name == Constants.totalKey ? self.filterDataByWeek(week: week) : self.filterDataByWeekAndType(type: type, week: week)
            
            // Append and create data items
            dataItems.append(DataItem(drinks: drinks.isEmpty ? nil : drinks, type: type, date: week[0]))
        }
        
        return dataItems
    }
    
    /**
     For a given Year and drink type, get the data items for the year
     */
    func getDataItemsforYear(year: [[Date]], type: DrinkType) -> [DataItem] {
        // Create empty data items array
        var dataItems = [DataItem]()
        
        // For motnh in year get drinks and create data items
        for month in year {
            
            // Get all drinks in month or all drinks of a specific type in month
            let drinks = type.name == Constants.totalKey ? self.filterDataByMonth(month: month) : self.filterDataByMonthAndType(type: type, month: month)
            
            // Create and append DataItems
            dataItems.append(DataItem(drinks: drinks.isEmpty ? nil : drinks, type: type, date: month[0]))
        }
        
        return dataItems
    }
    
    // MARK: - Trends Chart Method
    /**
     Returns a String of current/selected time period based on selectedTimePeriod
     */
    func timePeriodText(timePeriod: Constants.TimePeriod, dates: Any?) -> String {
        // If a Date (daily)
        if let day = dates as? Date {
            
            // Create and configure a DateFormatter
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.timeStyle = .none
            formatter.doesRelativeDateFormatting = true
            
            return formatter.string(from: day)
            
        } else if let dates = dates as? [Date] {
            if timePeriod == .weekly {
                return self.getWeekText(week: dates)
            
            } else {
                let formatter = DateFormatter()
                formatter.dateFormat = "MMMM y"
                
                return formatter.string(from: dates[0])
            }

        } else if let dates = dates as? [[Date]] {
            return self.getHalfYearText(halfYear: dates)
        }
        
        return ""
    }
    
    /**
     Assuming a bar is not selected, return the amount of a drink type consumed over some time period for a given drink type.
     */
    func getOverallAmount(type: DrinkType, timePeriod: Constants.TimePeriod, dates: Any?) -> Double {
        
        // If a Date (daily) return getTypeAmountByDay()
        if let date = dates as? Date {
            return self.getTypeAmountByDay(type: type, date: date)
            
        // If a [Date] (weekly/monthly)...
        } else if let date = dates as? [Date] {
            
            // If weekly return getTypeAmountByWeek()
            if timePeriod == .weekly {
                return self.getTypeAmountByWeek(type: type, week: date)
                
            // If monthly return getTypeAmountByMonth()
            } else if timePeriod == .monthly {
                return self.getTypeAmountByMonth(type: type, month: date)
            }
            
        // If a [[Date]] (half-yearly/yearly)...
        } else if let date = dates as? [[Date]] {
            
            // If half-yearly return getTypeAmountByHalfYear()
            if timePeriod == .halfYearly {
                return self.getTypeAmountByHalfYear(type: type, halfYear: date)
                
            // If yearly return getTypeAmountByYear()
            } else if timePeriod == .yearly {
                return self.getTypeAmountByYear(type: type, year: date)
            }
        }
        
        // If none of the if/if-else statements trigger return 0.0
        return 0.0
    }
    
    /**
     Get the width of spacers for the Trends Chart based on the given time period
     */
    func chartSpacerMaxWidth(timePeriod: Constants.TimePeriod, isWidget: Bool) -> CGFloat {
        
        // If not called from a widget
        if !isWidget {
            
            // If daily or weekly return 10
            if timePeriod == .daily || timePeriod == .weekly {
                return 10
                
            // Otherwise return 5
            } else {
                return 5
            }
            
        // If it is, return 1
        } else {
            return 1
        }
    }
    
    /**
     Get the Max Value for an array of Data Items.
     If half-yearly data is selected, get the total of each individual week and then get the max value.
     */
    func getMaxValue(dataItems: [DataItem], timePeriod: Constants.TimePeriod) -> Double {
        // If the time period is not half year  or year, map data items to get max
        if timePeriod != .halfYearly && timePeriod != .yearly {
            return dataItems.map { $0.getMaxValue() }.max() ?? 0.0
            
        // If the time period is half year...
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
     Assuming weekly or monthly data is chosen and a bar is selected get the average of drinks consumed over the time period for a given drink type.
     */
    func getAverage(dataItems: [DataItem], timePeriod: Constants.TimePeriod) -> Double {
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
        
        // If weekly divide by 7 for average
        if timePeriod == .weekly {
            return sum/7
            
        // If monthly, divide by the number of days in month for average
        } else if timePeriod == .monthly {
            return sum/Double(dataItems.count)
            
        }
        
        // Return 0.0 if a different time period is passed in
        return 0.0
    }
    
    /**
     Return the vertical axis text in a String array depending on the selected time period
     */
    func verticalAxisText(dataItems: [DataItem], timePeriod: Constants.TimePeriod) -> [String] {
        
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
            
            // Return String array
            return text
        }
        
        // Return empty array if none of the if-statements trigger
        return [String]()
    }
    
    /**
     Return the horizontal axis text as a String array.
     If the total amount for a Data Items array is not evenly divisble by 3, increment by 100 until it is.
     */
    func horizontalAxisText(dataItems: [DataItem], type: DrinkType, timePeriod: Constants.TimePeriod, dates: Any?) -> [String] {
        
        // Get the overall amount for the type, time period, and date(s)
        var newAmount = self.getOverallAmount(type: type, timePeriod: timePeriod, dates: dates)
        
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
     */
    func seriesDataPoints(dataItems: [DataItem], timePeriod: Constants.TimePeriod, halfYearOffset: Int, test: Bool) -> [AXDataPoint] {
        
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
     For a DataItem, get the range of the displayed data
     */
    func dataPointHourRangeText(item: DataItem) -> String {
        // Create Formatter
        let formatter = DateFormatter()
        formatter.dateFormat = "H"
        
        // Create date from item
        let date1 = item.date
        
        // Create date from item advanced by 1 hour
        let date2 = Calendar.current.date(byAdding: .hour, value: 1, to: item.date) ?? Date()
        
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
        
        return ""
    }
    
    /**
     For a DataItem get the week range it represents
     */
    func dataPointWeekRange(item: DataItem, halfYearOffset: Int, test: Bool) -> String {
        
        // Get days in week for item
        let week = self.getWeek(date: item.date)
        
        // Create a test date; for use if test = true
        let testDate = Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!
        
        // Get startDate
        // Uses testDate if test = true; if not uses today
        let startDate = Calendar.current.date(byAdding: .month, value: halfYearOffset-6, to: test ? testDate : .now) ?? Date()
        
        // Get endDate
        let endDate = Calendar.current.date(byAdding: .month, value: 1, to: test ? testDate : .now) ?? Date()
                
        // Get the first and last day of the half year
        if let start = self.getMonth(day: startDate).first, let end = self.getMonth(day: endDate).last {
            
            // Check if the week contains start or end
            if week.contains(start) || week.contains(end) {
                
                // Filter out days earlier than start
                let firstWeek = week.filter {
                    Calendar.current.compare(start, to: $0, toGranularity: .month) == .orderedSame && Calendar.current.compare(start, to: $0, toGranularity: .year) == .orderedSame
                }
                
                // Filter out days later than end
                let secondWeek = week.filter {
                    Calendar.current.compare(end, to: $0, toGranularity: .month) == .orderedSame && Calendar.current.compare(end, to: $0, toGranularity: .year) == .orderedSame
                }
                                
                // If firstWeek is empty and secondWeek isn't use secondWeek
                // Means that no dates matched start and some dates matched end
                if firstWeek.isEmpty && !secondWeek.isEmpty {
                    return self.getAccessibilityWeekText(week: secondWeek)
                
                // If firstWeek isn't empty and secondWeek is use firstWeek
                // Means that some dates matched start and no dates matched end
                } else if !firstWeek.isEmpty && secondWeek.isEmpty {
                    return self.getAccessibilityWeekText(week: firstWeek)
                    
                }
            }
            
            // If not or the inner if/if-else statements both return false
            return self.getAccessibilityWeekText(week: week)
        }
        
        return ""
    }
    
    /**
     For the chart return a String detailing the data being displayed
     */
    func getChartAccessibilityLabel(timePeriod: Constants.TimePeriod, type: DrinkType, dates: Any?) -> String {
        
        // Create blank output string
        var output = ""
        
        // If all data is selected
        if type == Constants.totalType {
            output = "Data representing your intake "
            
        // If a specific drink type is selected
        } else {
            output = "Data representing your \(type.name) intake "
        }
        
        // Check for a Date (daily time period)
        if let day = dates as? Date {
            
            // Set formatter
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.timeStyle = .none
            formatter.doesRelativeDateFormatting = true
            
            // Get formatted text
            let text = formatter.string(from: day)
            
            // If text is "Today" or "Yesterday" add it on
            if text == "Today" || text == "Yesterday" {
                output += text
                
            // If not add "on Month Day, Year"
            // (i.e. "April 8, 2022")
            } else {
                output += "on \(text)."
            }
            
        // Check for [Date] (weekly or monthly)
        } else if let dates = dates as? [Date] {
            
            // If weekly, add string from getAccessibilityWeekText
            // (i.e. "from April 3rd to 9th, 2022")
            if timePeriod == .weekly {
                output += "from \(self.getAccessibilityWeekText(week: dates))."
 
            // If monthly...
            } else {
                
                // Crerate formatter
                let formatter = DateFormatter()
                formatter.dateFormat = "MMMM y"
                
                // Use the first date to add on to output
                // (i.e. "on April 2022")
                if let first = dates.first {
                    output += "on \(formatter.string(from: first))."
                }
            }
            
        // If half yearly or yearly...
        } else if let dates = dates as? [[Date]] {
            
            // Add on using getAccessibilityHalfYearText()
            // (i.e. "from May 2021 to Apr 2022")
            output += "from \(self.getAccessibilityHalfYearText(halfYear: dates))."

        }
        
        // Return output string
        return output
    }
    
    // MARK: - HealthKit Methods
    /**
     Convert stored unit to HKUnit
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
