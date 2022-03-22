//
//  DrinkModel.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/7/21.
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
    
    init() {
        // Create HealthStore
        healthStore = HealthStore()
        
        // Retrieve data from UserDefaults
        if let userDefaults = UserDefaults(suiteName: Constants.sharedKey) {
            if let data = userDefaults.data(forKey: Constants.savedKey) {
                if let decoded = try? JSONDecoder().decode(DrinkData.self, from: data) {
                    self.drinkData = decoded
                    
                    self.selectedWeek = self.getDaysInWeek(date: Date())
                    return
                }
            }
        }
        
        // If unable to retrieve from UserDefaults, create a new DrinkData
        self.drinkData = DrinkData()
    }
    
    /**
     Save any changes made to Drink Data
     */
    func save() {
        // Save data to user defaults
        if let userDefaults = UserDefaults(suiteName: Constants.sharedKey) {
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
            if self.drinkData.units == Constants.waterKey && self.drinkData.enabled[drink.type]! {
                self.saveToHealthKit()
            }
            
            // Save to UserDefaults
            self.save()
        }
        
        // Update widget
        WidgetCenter.shared.reloadAllTimelines()
        
    }
    
    func addYearDrinks() {
        let year = self.getYear(date: .now)
        
        var allDrinks = [Drink]()
        
        for month in year {
            for day in month {
                let rand = Double.random(in: 0...1600)
                allDrinks.append(Drink(type: Constants.waterKey, amount: rand, date: day))
            }
        }
        
        self.drinkData.drinks = allDrinks
    }
    
    // MARK: - Data Items
    /**
     For a given date and type, return Data Items for each hour in a day
     */
    func getDataItemsForDay(date: Date, type: String) -> [DataItem] {
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
        
        for hour in dates {
            let drinks = type == Constants.totalKey ? self.filterDataByHour(hour: hour) : self.filterDataByHourAndType(hour: hour, type: type)
            
            dataItems.append(DataItem(drinks: drinks.isEmpty ? nil : drinks, type: type, date: hour))
        }
        
        return dataItems
    }
    
    /**
     For a given week and drink type, get and return Data Items for each day in the week.
     */
    func getDataItemsForWeek(week: [Date], type: String) -> [DataItem] {
        
        // Create Data Items for each day in month
        var dataItems = [DataItem]()
        
        for day in week {
            let drinks = type == Constants.totalKey ? self.filterDataByDay(day: day) : self.filterDataByDayAndType(type: type, day: day)
            
            dataItems.append(DataItem(drinks: drinks.isEmpty ? nil : drinks, type: type, date: day))
        }
        
        return dataItems
        
    }
    
    /**
     For a given month and drink type, get the data items for the month
     */
    func getDataItemsForMonth(month: [Date], type: String) -> [DataItem] {
        
        // Create Data Items for each day in month
        var dataItems = [DataItem]()
        
        for day in month {
            let drinks = type == Constants.totalKey ? self.filterDataByDay(day: day) : self.filterDataByDayAndType(type: type, day: day)
            
            dataItems.append(DataItem(drinks: drinks.isEmpty ? nil : drinks, type: type, date: day))
        }
        
        return dataItems
    }
    
    /**
     For a given Half-Year and drink type, get the data items for each week in Half Year
     */
    func getDataItemsForHalfYear(halfYear: [[Date]], type: String) -> [DataItem] {
        // Create empty data items array
        var dataItems = [DataItem]()
        
        // For week in half year get drinks and create data items
        for week in halfYear {
            
            // Get all drinks in halfYear or all drinks of a specific type in halfYear
            let drinks = type == Constants.totalKey ? self.filterDataByWeek(week: week) : self.filterDataByWeekAndType(type: type, week: week)
            
            // Append and create data items
            dataItems.append(DataItem(drinks: drinks.isEmpty ? nil : drinks, type: type, date: week[0]))
        }
        
        return dataItems
    }
    
    /**
     For a given Year and drink type, get the data items for the year
     */
    func getDataItemsforYear(year: [[Date]], type: String) -> [DataItem] {
        // Create empty data items array
        var dataItems = [DataItem]()
        
        // For motnh in year get drinks and create data items
        for month in year {
            
            // Get all drinks in month or all drinks of a specific type in month
            let drinks = type == Constants.totalKey ? self.filterDataByMonth(month: month) : self.filterDataByMonthAndType(type: type, month: month)
            
            // Create and append DataItems
            dataItems.append(DataItem(drinks: drinks.isEmpty ? nil : drinks, type: type, date: month[0]))
        }
        
        return dataItems
    }
    
    // MARK: - Time Display Functions
    /**
     Checks if the day after the given date has happened yet
     */
    func isTomorrow(currentDate: Date) -> Bool {
        let calendar = Calendar.current
        
        // Get the next day and tomorrow date
        let nextDay = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? Date()
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .long
        
        // If they are the same...
        if dateFormatter.string(from: nextDay) == dateFormatter.string(from: tomorrow) {
            return true
            // If not
        } else {
            return false
        }
    }
    
    /**
     Checks if the week after the given week has happened yet or is happening
     */
    func isNextWeek(currentWeek: [Date]) -> Bool {
        let calendar = Calendar.current
        
        // Get the next week per currentWeek and the next week per today
        let nextWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: currentWeek[0]) ?? Date()
        let upcomingWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: Date()) ?? Date()
        
        // If both dates fall in the same week...
        if self.doesDateFallInWeek(date1: nextWeek, date2: upcomingWeek) {
            return true
        } else {
            return false
        }
        
    }
    
    /**
     Checks if the month after the given month has happened yet or is happening
     */
    func isNextMonth(currentMonth: [Date]) -> Bool {
        let calendar = Calendar.current
        
        // Get the next month per currentMonth and today
        let nextMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth[0]) ?? Date()
        let upcomingMonth = calendar.date(byAdding: .month, value: 1, to: .now) ?? Date()
        
        // Create date formatter
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        
        // If both months fall are the same...
        if formatter.string(from: nextMonth) == formatter.string(from: upcomingMonth) {
            return true
        } else {
            return false
        }
    }
    
    /**
     Check if the next month in the half year has happened yet
     */
    func isNextHalfYear(currentHalfYear: [[Date]]) -> Bool {
        // If the next month hasn't happened yet
        if let lastMonth = currentHalfYear.last {
            return self.isNextMonth(currentMonth: lastMonth)
        }
        
        return false
    }
    
    func isNextYear(currentYear: [[Date]]) -> Bool {
        if let lastMonth = currentYear.last {
            return self.isNextMonth(currentMonth: lastMonth)
        }
        
        return false
    }
    
    /**
     Get a week range as a String for the given week
     */
    func getWeekText(week: [Date]) -> String {
        // Create a date formatter
        let formatter = DateFormatter()
        
        // Format for year only
        formatter.dateFormat = "yyyy"
        
        // If the year is the same...
        if let first = week.first, let last = week.last {
            if formatter.string(from: first) == formatter.string(from: last) {
                
                let year = formatter.string(from: first)
                
                // Format for month
                formatter.dateFormat = "MMM"
                
                // If the month is the same...
                if formatter.string(from: first) == formatter.string(from: last) {
                    
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
        
        // Format for year only
        formatter.dateFormat = "yyyy"
        
        // If the year is the same...
        if let first = week.first, let last = week.last {
            if formatter.string(from: first) == formatter.string(from: last) {
                
                let year = formatter.string(from: first)
                
                // Format for month
                formatter.dateFormat = "MMM."
                
                // If the month is the same...
                if formatter.string(from: first) == formatter.string(from: last) {
                    
                    // Get date1
                    formatter.dateFormat = "MMM. d"
                    
                    let date1 = formatter.string(from: first)
                    
                    // Get date2
                    formatter.dateFormat = "d"
                    
                    let date2 = formatter.string(from: last)
                    
                    let suffix1 = getDateSuffix(date: formatter.string(from: first))
                    let suffix2 = getDateSuffix(date: formatter.string(from: last))
                    
                    return "\(date1)\(suffix1) to \(date2)\(suffix2), \(year)"
                    
                    // If not...
                } else {
                    
                    // Formatt for month and day
                    formatter.dateFormat = "MMM. d"
                    
                    // Get dates
                    let date1 = formatter.string(from: first)
                    let date2 = formatter.string(from: last)
                    
                    formatter.dateFormat = "d"
                    
                    let suffix1 = self.getDateSuffix(date: formatter.string(from: first))
                    let suffix2 = self.getDateSuffix(date: formatter.string(from: last))
                    
                    return "\(date1)\(suffix1) to \(date2)\(suffix2), \(year)"
                    
                }
            } else {
                // Format for month and day
                formatter.dateFormat = "MMM. d"
                
                // Get dates
                let monthDay1 = formatter.string(from: first)
                let monthDay2 = formatter.string(from: last)
                
                formatter.dateFormat = "d"
                
                let suffix1 = self.getDateSuffix(date: formatter.string(from: first))
                let suffix2 = self.getDateSuffix(date: formatter.string(from: last))
                
                formatter.dateFormat = "yyyy"
                
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
        let count = date.count
        
        var num = date
        if count == 2 {
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
        let drinkType = self.drinkData.customDrinkTypes[atOffsets.first!]
        
        // Loop through drinks
        for index in 0..<self.drinkData.drinks.count {
            // If the drink type is the same...
            if self.drinkData.drinks[index].type == drinkType {
                // Remove drink
                self.drinkData.drinks.remove(at: index)
            }
        }
        
        // Save
        self.save()
        
        // Update widget
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    /**
     Update a custom drink type for a name change
     */
    func editDrinkType(old: String, new: String) {
        // Update colors
        if let entry = self.drinkData.colors.removeValue(forKey: old) {
            self.drinkData.colors[new] = entry
        }
        
        // Update enabled
        if let entry = self.drinkData.enabled.removeValue(forKey: old) {
            self.drinkData.enabled[new] = entry
        }
        
        // Update drinks
        for drink in self.drinkData.drinks {
            if drink.type == old {
                drink.type = new
            }
        }
        
        // Get index of old drink type name
        let index = self.drinkData.customDrinkTypes.firstIndex(of: old)!
        
        // Add new name at index
        self.drinkData.customDrinkTypes[index] = new
        
        // Save
        self.save()
        
        // Update Widget
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    /**
     For a drink type (as a string) get the associated color. If the color for a default drink type hasn't been changed, return a system color. Otherwise and for custom drink types, return the stored color.
     */
    func getDrinkTypeColor(type: String) -> Color {
        if !self.drinkData.colorChanged[type]! {
            if type == Constants.waterKey {
                return Color(.systemCyan)
            } else if type == Constants.coffeeKey {
                return Color(.systemBrown)
            } else if type == Constants.sodaKey {
                return Color(.systemGreen)
            } else if type == Constants.juiceKey {
                return Color(.systemOrange)
            }
        }
        
        return self.drinkData.colors[type]!.getColor()
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
    func filterByDrinkType(type: String) -> [Drink] {
        return self.drinkData.drinks.filter { $0.type == type }
    }
    
    /**
     Return the total amount of all drinks of a specific type
     */
    func getTypeAmount(type: String) -> Double {
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
    func getTypeAverage(type: String, startDate: Date) -> Double? {
        // Get total based on passed in type
        let total = type == Constants.totalKey ? self.getTotalAmount() : self.getTypeAmount(type: type)
        
        // Get all drinks based on passed in type
        let drinks = type == Constants.totalKey ? self.drinkData.drinks : self.filterByDrinkType(type: type)
        
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
        
        // Set as enabled
        self.drinkData.enabled[saveType] = true
        
        // Add saveType and codableColor to model
        self.drinkData.customDrinkTypes.append(saveType)
        self.drinkData.colors[saveType] = codableColor
        self.drinkData.colorChanged[saveType] = true
        
        // Save model
        self.save()
    }
    
    // MARK: - Units
    /**
     For a given amount return a specifier so a double will have 0 or 2 decimal points displayed
     */
    func getSpecifier(amount: Double) -> String {
        let rounded = amount.rounded()
        
        if rounded == amount {
            return "%.0f"
        } else {
            return "%.2f"
        }
    }
    
    /**
     Get the unit abbreviation for the stored unit
     */
    func getUnits() -> String {
        if self.drinkData.units == Constants.cupsUS {
            return Constants.cups
        } else if self.drinkData.units == Constants.milliliters {
            return Constants.mL
        } else if self.drinkData.units == Constants.liters {
            return Constants.L
        } else if self.drinkData.units == Constants.fluidOuncesUS {
            return Constants.flOzUS
        }
        return ""
    }
    
    /**
     For the stored unit return the full name of a unit to be used in Accessibility Support
     */
    func getAccessibilityUnitLabel() -> String {
        let units = self.drinkData.units
        
        if units == Constants.milliliters {
            return "milliliters"
        } else if units == Constants.liters {
            return "liters"
        } else if units == Constants.fluidOuncesUS {
            return "fluid ounces"
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
    
    // MARK: - Data by Data Functions
    /**
     For a given date, return drinks for the date and hour
     */
    func filterDataByHour(hour: Date) -> [Drink] {
        
        return self.drinkData.drinks.filter {
            Calendar.current.compare($0.date, to: hour, toGranularity: .hour) == .orderedSame && self.drinkData.enabled[$0.type]!
        }
    }
    
    func filterDataByHourAndType(hour: Date, type: String) -> [Drink] {
        return self.filterDataByHour(hour: hour).filter { $0.type == type }
    }
    
    
    /**
     Filter all drinks by the day from the given date
     */
    func filterDataByDay(day: Date) -> [Drink] {
        return self.drinkData.drinks.filter {
            Calendar.current.compare($0.date, to: day, toGranularity: .day) == .orderedSame && self.drinkData.enabled[$0.type]!
        }
    }
    
    /**
     Filter all drinks by the given drink type and date
     */
    func filterDataByDayAndType(type: String, day: Date) -> [Drink] {
        if type == Constants.totalKey {
            return self.filterDataByDay(day: day)
            
        } else {
            return self.filterDataByDay(day: day).filter { $0.type == type }
        }
    }
    
    /**
     Get the amount for the given type for a given date and hour
     */
    func getTypeAmountByTime(type: String, time: Date) -> Double {
        // Get drinks for the hour
        let drinks = self.filterDataByHour(hour: time).filter { $0.type == type }
        
        // Get total amount for the hour
        var totalAmount = 0.0
        for drink in drinks {
            totalAmount += drink.amount
        }
        
        return totalAmount
    }
    
    /**
     Get the total amount for the given type for a given day
     */
    func getTypeAmountByDay(type: String, date: Date) -> Double {
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
    func getTypePercentByDay(type: String, date: Date) -> Double {
        
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
        
        var amount = 0.0
        
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
    func getDaysInWeek(date: Date) -> [Date] {
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
        
        return self.drinkData.drinks.filter {
            Calendar.current.compare(week[0], to: $0.date, toGranularity: .weekOfYear) == .orderedSame && self.drinkData.enabled[$0.type]!
        }
    }
    
    /**
     For all drinks, get all drinks in a given week that belong to the given drink type
     */
    func filterDataByWeekAndType(type: String, week: [Date]) -> [Drink] {
        
        if type == Constants.totalKey {
            return self.filterDataByWeek(week: week)
        
        } else {
            return self.filterDataByWeek(week: week).filter {
                $0.type == type
            }
        }
    }
    
    /**
     For all drinks in given week, get the total amount consumed for a given type
     */
    func getTypeAmountByWeek(type: String, week: [Date]) -> Double {
        
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
    func getTypePercentByWeek(type: String, week: [Date]) -> Double {
        
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
        
        var amount = 0.0
        
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
    func doesDateFallInWeek(date1: Date, date2: Date) -> Bool {
        let week1 = self.getDaysInWeek(date: date1)
        let week2 = self.getDaysInWeek(date: date2)
        
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
        
        return [Date]()
    }
    
    /**
     For all drinks, return drinks that were logged in the given month
     */
    func filterDataByMonth(month: [Date]) -> [Drink] {
        return self.drinkData.drinks.filter {
            Calendar.current.compare(month[0], to: $0.date, toGranularity: .month) == .orderedSame && self.drinkData.enabled[$0.type]!
        }
    }
    
    /**
     For all drinks, return drinks in the given month and of the given drink type
     */
    func filterDataByMonthAndType(type: String, month: [Date]) -> [Drink] {
        
        if type == Constants.totalKey {
            return self.filterDataByMonth(month: month)
            
        } else {
            return self.filterDataByMonth(month: month).filter {
                $0.type == type
            }
        }
    }
    
    /**
     For all drinks get the total amount consumed for the given month and of the given drink type
     */
    func getTypeAmountByMonth(type: String, month: [Date]) -> Double {
        let drinks = self.filterDataByMonthAndType(type: type, month: month)
        
        var amount = 0.0
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
        let year = self.getYear(date: date)
        
        var halfYear = [[Date]]()
        
        for index in 6...11 {
            halfYear.append(year[index])
        }
        
        return self.getWeeksForHalfYear(halfYear: halfYear)
    }
    
    /**
     For a given half year, return it with each index of the array corresponding with a week in the 6-month period
     */
    func getWeeksForHalfYear(halfYear: [[Date]]) -> [[Date]] {
        // Dictionary to store dates
        var weeks = [[Date]]()
        
        var monthCount = 0
        
        // Loop through halfYear
        for month in halfYear {
            // Loop through the indicies of month incrementing by 7
            for index in stride(from: 0, through: month.count, by: 7) {
                
                // If index doesn't exceed the count of month append to dictionary
                if index < month.count {
                    weeks.append(self.getDaysInWeek(date: month[index]))
                } else if index >= month.count {
                    var i = index
                    while i >= month.count {
                        i -= 1
                    }
                    weeks.append(self.getDaysInWeek(date: month[i]))
                }
                
            }
            monthCount += 1
        }
        
        // Remove any dates that are not in the first month
        weeks[0] = weeks[0].filter { $0 >= halfYear[0].first! }
        
        // Get the count of the last month in dictionary
        let dCount = weeks.count-1
        
        // Get the count of the last month in halfYear
        let hCount = halfYear.count-1
        
        // Filter out any
        weeks[dCount] = weeks[dCount].filter { $0 <= halfYear[hCount].last! }
        
        return weeks
    }
    
    /**
     For all drinks, get the drinks in the given half year
     */
    func filterDataByHalfYear(halfYear: [[Date]]) -> [Drink] {
        
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
    func filterDataByHalfYearAndType(type: String, halfYear: [[Date]]) -> [Drink] {
        
        if type == Constants.totalKey {
            return self.filterDataByHalfYear(halfYear: halfYear)
        
        } else {
            return self.filterDataByHalfYear(halfYear: halfYear).filter { $0.type == type }
        }
        
    }
    
    /**
     Get the total amount of drinks consumed for the given half year and of the given type
     */
    func getTypeAmountByHalfYear(type: String,  halfYear: [[Date]]) -> Double {
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
        // Get a day in each month of 12-month period
        var months = [Date]()
        for index in -11...0 {
            if let newDate = Calendar.current.date(byAdding: .month, value: index, to: date) {
                months.append(newDate)
            }
        }
        
        var output = [[Date]]()
        // Get the month for each day
        for month in months {
            output.append(self.getMonth(day: month))
        }
        
        return output
    }
    
    /**
     For all drinks, return all drinks consumed in the given year
     */
    func filterDataByYear(year: [[Date]]) -> [Drink] {
        
        var drinks = [Drink]()
        
        for month in year {
            if let first = month.first {
                drinks += self.drinkData.drinks.filter {
                    Calendar.current.compare(first, to: $0.date, toGranularity: .month) == .orderedSame && self.drinkData.enabled[$0.type]!
                }
            }
        }
        
        return drinks
    }
    
    /**
     For all drinks, get the drinks in the given year and of the given drink type
     */
    func filterDataByYearAndType(type: String, year: [[Date]]) -> [Drink] {
        
        if type == Constants.totalKey {
            return self.filterDataByYear(year: year)
            
        } else {
            return self.filterDataByYear(year: year).filter {
                $0.type == type
            }
        }
    }
    
    /**
     For a given year, get the total amount consumed of a given drink type
     */
    func getTypeAmountByYear(type: String, year: [[Date]]) -> Double {
        let drinks = self.filterDataByYearAndType(type: type, year: year)
        
        var amount = 0.0
        for drink in drinks {
            amount += drink.amount
        }
        
        return amount
    }
    
    // MARK: - Trends Chart Method
    /**
     Returns a String of current/selected time period based on selectedTimePeriod
     */
    func timePeriodText(timePeriod: Constants.TimePeriod, dates: Any?) -> String {
        if let day = dates as? Date {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.timeStyle = .none
            formatter.doesRelativeDateFormatting = true
            
            return formatter.string(from: day)
            
        } else if let dates = dates as? [Date] {
            if timePeriod == .weekly {
                return self.getWeekText(week: selectedWeek)
            
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
    func getOverallAmount(dataItems: [DataItem], type: String, timePeriod: Constants.TimePeriod, dates: Any?) -> Double {
        
        if let date = dates as? Date {
            return self.getTypeAmountByDay(type: type, date: date)
            
        } else if let date = dates as? [Date] {
            
            if timePeriod == .weekly {
                return self.getTypeAmountByWeek(type: type, week: date)
                
            } else if timePeriod == .monthly {
                return self.getTypeAmountByMonth(type: type, month: date)
            }
            
        } else if let date = dates as? [[Date]] {
            if timePeriod == .halfYearly {
                return self.getTypeAmountByHalfYear(type: type, halfYear: date)
            } else if timePeriod == .yearly {
                return self.getTypeAmountByYear(type: type, year: date)
            }
        }
        
        return 0.0
    }
    
    /**
     Get the width of spacers for the Trends Chart based on the given time period
     */
    func chartSpacerMaxWidth(timePeriod: Constants.TimePeriod, isWidget: Bool) -> CGFloat {
        if !isWidget {
            if timePeriod == .daily || timePeriod == .weekly {
                return 10
            } else {
                return 5
            }
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
            
            // If the time period is half year
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
    
    func getDailyTotal(dataItems: [DataItem]) -> Double {
        
        var total = 0.0
        
        for item in dataItems {
            if let drinks = item.drinks {
                for drink in drinks {
                    total += drink.amount
                }
            }
        }
        
        return total
        
    }
    
    /**
     Assuming weekly or monthly data is chosen and a bar is selected get the average of drinks consumed over the time period for a given drink type.
     */
    func getAverage(dataItems: [DataItem], timePeriod: Constants.TimePeriod) -> Double {
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
        
        // Get the average
        if timePeriod == .weekly {
            return sum/7
        } else if timePeriod == .monthly {
            return sum/Double(dataItems.count)
        }
        
        return 0.0
    }
    
    /**
     Assuming half-yearly data is chosen, get the daily average depending on if a bar is selected
     */
    func getDailyAverage(dataItems: [DataItem], timePeriod: Constants.TimePeriod, touchLocation: Int, dates: [[Date]]?, count: Int?) -> Double {
        var sum = 0.0
        
        // If selected time period is half year or yearly
        if timePeriod == .halfYearly || timePeriod == .yearly {
            
            // If a bar isn't selected
            if touchLocation == -1 {
                // Loop through data items
                for item in dataItems {
                    
                    // Get drinks if they exist
                    if let drinks = item.drinks {
                        
                        // Loop through drinks and add to sum
                        for drink in drinks {
                            sum += drink.amount
                        }
                    }
                }
                
                // Get the dividend of the half year
                var dividend = 0.0
                
                // Get the count of each week in the half year
                if let count = count {
                    dividend = Double(count)
                    
                } else if let dates = dates {
                    if timePeriod == .halfYearly {
                        for week in dates {
                            dividend += Double(week.count)
                        }
                        
                    // Get the count of each month in the year
                    } else if timePeriod == .yearly {
                        for month in dates {
                            dividend += Double(month.count)
                        }
                    }
                }
            
                return sum/dividend
                
            // If a bar is selected
            } else {
                
                // Get the drinks at the touch location if theye exist
                if let drinks = dataItems[touchLocation].drinks {
                    
                    // Loop through all drinks and add to sum
                    for drink in drinks {
                        sum += drink.amount
                    }
                }
                
                var dividend = 0.0
                
                // Set dividend to the count of days at the selected bar
                if timePeriod == .halfYearly {
                    dividend = Double(dates![touchLocation].count)
                } else if timePeriod == .yearly {
                    dividend = Double(dates![touchLocation].count)
                }
                
                return sum/dividend
            }
        }
        
        return 0.0
    }
    
    /**
     Return the vertical axis text in a String array depending on the selected time period
     */
    func verticalAxisText(dataItems: [DataItem], timePeriod: Constants.TimePeriod) -> [String] {
        
        if timePeriod == .daily {
            return ["12A", "6A", "12P", "6P"]
            
        } else if timePeriod == .weekly {
            return ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
            
        } else if timePeriod == .monthly {
            if dataItems.count == 28 {
                return ["0", "7", "14", "21"]
                
            } else if dataItems.count == 29 {
                return ["0", "7", "14", "21", "28"]
                
            } else if dataItems.count == 30 {
                return ["0", "6", "12", "18", "24"]
                
            } else if dataItems.count == 31 {
                return ["0", "6", "12", "18", "24", "30"]
            }
            
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM"
            
            var text = [String]()
            for item in dataItems {
                let month = formatter.string(from: item.date)
                if !text.contains(month) {
                    text.append(month)
                }
            }
            
            return text
        }
        
        return [String]()
    }
    
    /**
     Return the horizontal axis text as a String array.
     If the total amount for a Data Items array is not evenly divisble by 3, increment by 100 until it is.
     */
    func horizontalAxisText(dataItems: [DataItem], type: String, timePeriod: Constants.TimePeriod, dates: Any?) -> [String] {
        
        var newAmount = self.getOverallAmount(dataItems: dataItems, type: type, timePeriod: timePeriod, dates: dates)
        
        while Int(ceil(newAmount)) % 3 != 0 {
            newAmount += 100
        }
        
        let one3 = Int(newAmount/3)
        let two3 = Int(2*newAmount/3)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = true
        formatter.maximumSignificantDigits = 2
        
        if let one = formatter.string(from: NSNumber(value: Int(ceil(newAmount)))), let twoThirds = formatter.string(from: NSNumber(value: Int(two3))), let oneThird = formatter.string(from: NSNumber(value: Int(one3))) {
            
            return [one, twoThirds, oneThird, "0"]
        }
        
        return [String]()
    }
    
    /**
     For an array of DataItem, get an array of AXDataPoint using timePeriod
     */
    func seriesDataPoints(dataItems: [DataItem], timePeriod: Constants.TimePeriod, halfYearOffset: Int) -> [AXDataPoint] {
        
        var output = [AXDataPoint]()
        
        if timePeriod == .daily {
            // Create formatter
            let formatter = DateFormatter()
            formatter.dateFormat = "H"
            
            // Loop through dataItems
            for item in dataItems {
                
                // Create and append AXDataPoints
                output.append(AXDataPoint(x: self.dataPointHourRangeText(item: item), y: item.getIndividualAmount()))
            }
            
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
            
        } else if timePeriod == .halfYearly {
            // Loop through data items
            for item in dataItems {
                
                // Append AXDataPoints
                output.append(AXDataPoint(x: self.dataPointWeekRange(item: item, halfYearOffset: halfYearOffset), y: item.getIndividualAmount()))
            }
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
        if let d1 = Double(formatter.string(from: date1)), let d2 = Double(formatter.string(from: date2)) {
            
            if d1 == 12 && d2 == 13 {
                return "12 AM to 1 PM"
                
            } else if d1 == 23 && d2 == 0 {
                return "11 PM to 12 AM"
                
            } else if d1 <= 12 && d2 <= 12 {
                return "\(d1) to \(d2) AM"
                
            }  else if d1 > 12 && d2 > 12 {
                return "\(d1) to \(d2) PM"
            }
        }
        
        return ""
    }
    
    /**
     For a DataItem get the week range it represents
     */
    func dataPointWeekRange(item: DataItem, halfYearOffset: Int) -> String {
        
        // Get days in week for item
        var week = self.getDaysInWeek(date: item.date)
        
        // Get start and end date
        let startDate = Calendar.current.date(byAdding: .month, value: halfYearOffset-6, to: .now) ?? Date()
        let endDate = Calendar.current.date(byAdding: .month, value: halfYearOffset, to: .now) ?? Date()
                
        // If week exists in selectedHalfYear
        // i.e. week wasn't cut off for containg dates out of 6-month period
        if let start = self.getMonth(day: startDate).first, let end = self.getMonth(day: endDate).last {
            if !week.contains(start) || !week.contains(end) {
                return self.getAccessibilityWeekText(week: week)
                
            } else {
                // Filter out dates
                week = week.filter {
                    Calendar.current.compare(start, to: $0, toGranularity: .month) == .orderedSame
                }
                
                if week.count == 7 {
                    week = week.filter {
                        Calendar.current.compare(end, to: $0, toGranularity: .month) == .orderedSame
                    }
                }
            }
        }
        
        return ""
    }
    
    /**
     For the chart return a String detailing the data being displayed
     */
    func getChartAccessibilityLabel(timePeriod: Constants.TimePeriod, type: String, dates: Any?) -> String {
        var output = ""
        
        // If all data is selected
        if type == Constants.totalKey {
            output = "Data representing your intake "
            
        // If a specific drink type is selected
        } else {
            output = "Data representing your \(type) intake "
        }
        
        if let day = dates as? Date {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.timeStyle = .none
            formatter.doesRelativeDateFormatting = true
            
            let text = formatter.string(from: day)
            
            if text == "Today" || text == "Yesterday" {
                output += text
            } else {
                output += "on \(text)."
            }
            
        } else if let dates = dates as? [Date] {
            if timePeriod == .weekly {
                output += "from \(self.getAccessibilityWeekText(week: dates))."
 
            } else {
                let formatter = DateFormatter()
                formatter.dateFormat = "MMMM y"
                
                if let first = dates.first {
                    output += "on \(formatter.string(from: first))."
                }
            }
        } else if let dates = dates as? [[Date]] {
            output += "from \(self.getAccessibilityHalfYearText(halfYear: dates))."

        }
        
        return ""
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
            let drink = Drink(type: Constants.waterKey, amount: amount ?? 0, date: stats.startDate)
            
            // If some amount was consumed and the drink doesn't already exist in the ViewModel...
            if drink.amount > 0 && !self.doesDrinkExist(drink: drink) {
                // Add the drink to the ViewModel
                DispatchQueue.main.async {
                    self.addDrink(drink: drink)
                }
            }
        }
    }
    
    /**
     Checks if a drink exists in local data
     */
    func doesDrinkExist(drink: Drink) -> Bool {
        
        // Create a date formatter
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        
        for data in self.drinkData.drinks {
            
            // If the amount, type, and date are the same...
            if data.amount == drink.amount && data.type == drink.type && formatter.string(from: data.date) == formatter.string(from: drink.date) {
                return true
            }
        }
        
        // Else
        return false
    }
    
    /**
     Save a drink to HealthKit
     */
    func saveToHealthKit() {
        
        let waterType = HKSampleType.quantityType(forIdentifier: .dietaryWater)!
        
        if self.healthStore != nil && self.healthStore?.healthStore != nil {
            
            for drink in self.drinkData.drinks {
                
                if (self.drinkData.lastHKSave == nil || self.drinkData.lastHKSave ?? Date() < drink.date) && drink.type == Constants.waterKey {
                    
                    let startDate = drink.date
                    let endDate = startDate
                    
                    let quantity = HKQuantity(unit: self.getHKUnit(), doubleValue: drink.amount)
                    
                    let sample = HKQuantitySample(type: waterType, quantity: quantity, start: startDate, end: endDate)
                    
                    self.healthStore!.healthStore!.save(sample) { success, error in
                        DispatchQueue.main.async {
                            self.drinkData.lastHKSave = Date()
                        }
                    }
                }
            }
        }
    }
}
