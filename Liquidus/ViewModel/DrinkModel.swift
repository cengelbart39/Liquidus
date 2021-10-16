//
//  DrinkModel.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/7/21.
//

import Foundation
import SwiftUI
import HealthKit

class DrinkModel: ObservableObject {
    
    @Published var drinkData = DrinkData()
    @Published var weeksPopulated = false
    
    @Published var selectedDay = Date()
    @Published var selectedWeek = [Date]()
    
    @Published var healthStore: HealthStore?
    
    init() {
        // Create HealthStore
        healthStore = HealthStore()
        
        // Retrieve data from UserDefaults
        if let data = UserDefaults.standard.data(forKey: Constants.savedKey) {
            if let decoded = try? JSONDecoder().decode(DrinkData.self, from: data) {
                self.drinkData = decoded
                // Populate the selectedWeek property
                self.selectedWeek = self.getDaysInWeek(date: Date())
                return
            }
        }
        
        // If unable to retrieve from UserDefaults, create a new DrinkData
        self.drinkData = DrinkData()
    }
    
    func save() {
        // Save data to user defaults
        if let encoded = try? JSONEncoder().encode(drinkData) {
            UserDefaults.standard.set(encoded, forKey: Constants.savedKey)
        }
    }
    
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
        
    }
    
    func isToday() -> Bool {
        // Get DateFormatter
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        
        // If selectedDay and today are different dates
        if formatter.string(from: self.selectedDay) != formatter.string(from: Date()) {
            return false
        } else {
            return true
        }
    }
    
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
        
        // Save model
        self.save()
    }
    
    // MARK: - Drink Type Customization
    
    func deleteDefaultDrinks(type: String) {
        
        // Loop through drinks index
        for index in 0..<self.drinkData.drinks.count {
            // If the types are the same...
            if self.drinkData.drinks[index].type == type {
                // Remove drink
                self.drinkData.drinks.remove(at: index)
            }
        }
        
        // Save
        self.save()
    }
    
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
    }
    
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
    }
    
    // MARK: - Units
    
    func getSpecifier(amount: Double) -> String {
        let rounded = amount.rounded()
        
        if rounded == amount {
            return "%.0f"
        } else {
            return "%.2f"
        }
    }
    
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
    
    func filterDataByDay(day: Date) -> [Drink] {
        
        // Create a date formatter
        let dateFormatter = DateFormatter()
        
        // Only include the date not time
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        // Filter by matching days
        var filtered = drinkData.drinks.filter { dateFormatter.string(from: $0.date) == dateFormatter.string(from: day) }
        
        // Filter by times
        filtered.sort { $0.date > $1.date }
        
        // Filter out disabled types
        return filtered.filter { self.drinkData.enabled[$0.type]! }
    }
    
    func getDrinkTypeAmount(type: String, date: Date) -> Double {
        // Get the filtered data for the day
        let time = filterDataByDay(day: date)
        
        // Filter by the drink type
        let drinks = time.filter { $0.type == type }
        
        // Add up all the amounts
        var totalAmount = 0.0
        for drink in drinks {
            totalAmount += Double(drink.amount)
        }
        
        return totalAmount
    }
    
    func getDrinkTypePercent(type: String, date: Date) -> Double {
        
        // Get the amount of liquid consumed by liquid and date
        let amount = self.getDrinkTypeAmount(type: type, date: date)
        
        // Get percentage
        let percent = amount / self.drinkData.dailyGoal
        
        return percent
    }
    
    func getTotalAmount(date: Date) -> Double {
        
        var amount = 0.0
        
        // Get the amount for each drink type
        let drinkTypes = self.drinkData.defaultDrinkTypes + self.drinkData.customDrinkTypes
        
        for type in drinkTypes {
            if self.drinkData.enabled[type]! {
                amount += self.getDrinkTypeAmount(type: type, date: date)
            }
        }
        
        return amount
    }
    
    func getTotalPercent(date: Date) -> Double {
        
        // Get total amount
        let totalAmount = getTotalAmount(date: date)
        
        // Get percentage
        let percent = totalAmount / self.drinkData.dailyGoal
        
        return percent
        
    }
    
    // MARK: - Data by Week Functions
    
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
    
    func filterDataByWeek(week: [Date]) -> [Drink] {
        
        // Create a date formatter to get dates in Month Day, Year format
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        // Filter the drink data for each day
        let sunday = self.drinkData.drinks.filter { dateFormatter.string(from: $0.date) == dateFormatter.string(from: week[0]) }
        let monday = self.drinkData.drinks.filter { dateFormatter.string(from: $0.date) == dateFormatter.string(from: week[1]) }
        let tuesday = self.drinkData.drinks.filter { dateFormatter.string(from: $0.date) == dateFormatter.string(from: week[2]) }
        let wednesday = self.drinkData.drinks.filter { dateFormatter.string(from: $0.date) == dateFormatter.string(from: week[3]) }
        let thursday = self.drinkData.drinks.filter { dateFormatter.string(from: $0.date) == dateFormatter.string(from: week[4]) }
        let friday = self.drinkData.drinks.filter { dateFormatter.string(from: $0.date) == dateFormatter.string(from: week[5]) }
        let saturday = self.drinkData.drinks.filter { dateFormatter.string(from: $0.date) == dateFormatter.string(from: week[6]) }
        
        // Combine the arrays
        var weekData = sunday + monday + tuesday + wednesday + thursday + friday + saturday
        
        // Sort the array by date
        weekData.sort { $0.date > $1.date }
        
        return weekData
    }
    
    func getDrinkTypeAmount(type: String, week: [Date]) -> Double {
        
        // Get the drink data for the week
        let data = filterDataByWeek(week: week)
        
        // Filter by drink type
        let drinks = data.filter { $0.type == type }
        
        // Get the total amount
        var totalAmount = 0.0
        for drink in drinks {
            totalAmount += drink.amount
        }
        
        return totalAmount
    }
    
    func getDrinkTypePercent(type: String, week: [Date]) -> Double {
        
        // Get the amount
        let amount = self.getDrinkTypeAmount(type: type, week: week)
        
        // Calculate percentage
        let percent = amount / (self.drinkData.dailyGoal*7)
        
        return percent
    }
    
    func getTotalAmount(week: [Date]) -> Double {
        
        var amount = 0.0
        
        // Get the amount for each drink type
        let drinkTypes = self.drinkData.defaultDrinkTypes + self.drinkData.customDrinkTypes
        
        for type in drinkTypes {
            if self.drinkData.enabled[type]! {
                amount += self.getDrinkTypeAmount(type: type, week: week)
            }
        }
        
        return amount
    }
    
    func getTotalPercent(week: [Date]) -> Double {
        
        // Get the total amount
        let totalAmount = self.getTotalAmount(week: week)
        
        // Calculate the percentage
        let percent = totalAmount / (self.drinkData.dailyGoal*7)
        
        return percent
    }
    
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
    
    // MARK: - HealthKit Methods
    
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
