//
//  DrinkModel.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/7/21.
//

import Foundation
import HealthKit

class DrinkModel: ObservableObject {
    
    @Published var drinkData = DrinkData()
    @Published var weeksPopulated = false
    
    @Published var healthStore: HealthStore?
    
    init() {
        // Create HealthStore
        healthStore = HealthStore()
        
        // Retrieve data from UserDefaults
        if let data = UserDefaults.standard.data(forKey: Constants.savedKey) {
            if let decoded = try? JSONDecoder().decode(DrinkData.self, from: data) {
                self.drinkData = decoded
                // Populate the selectedWeek property
                self.drinkData.selectedWeek = self.getDaysInWeek(date: Date())
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
            self.drinkData.drinks.append(drink)
        }
        self.saveToHealthKit()
        self.save()
    }
    
    func convertMeasurements() {
        // If units are changed to mL
        if self.drinkData.units == Constants.mL {
            // Convert daily goal to mL
            self.drinkData.dailyGoal *= Constants.flOzUSToMl
            
            // Convert all drink amounts to mL
            for drink in drinkData.drinks {
                drink.amount *= Constants.flOzUSToMl
            }
        // If units are changed to oz
        } else {
            // Convert daily goal to oz
            self.drinkData.dailyGoal *= Constants.mlToFlOzUS
            
            // Convert all drink amounts to oz
            for drink in drinkData.drinks {
                drink.amount *= Constants.mlToFlOzUS
            }
        }
        
        // Save to user defaults
        self.save()
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
        return filtered
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
        // Get the amount for each drink type
        let water = self.getDrinkTypeAmount(type: Constants.waterKey, date: date)
        let coffee = self.getDrinkTypeAmount(type: Constants.coffeeKey, date: date)
        let soda = self.getDrinkTypeAmount(type: Constants.sodaKey, date: date)
        let juice = self.getDrinkTypeAmount(type: Constants.juiceKey, date: date)
        
        // Add up all the amounts
        let totalAmount = water+coffee+soda+juice
        
        return totalAmount
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
        // Get the drink amount for each drink type
        let water = self.getDrinkTypeAmount(type: Constants.waterKey, week: week)
        let coffee = self.getDrinkTypeAmount(type: Constants.coffeeKey, week: week)
        let soda = self.getDrinkTypeAmount(type: Constants.sodaKey, week: week)
        let juice = self.getDrinkTypeAmount(type: Constants.juiceKey, week: week)
        
        // Sum the amounts
        let totalAmount = water+coffee+soda+juice
        
        return totalAmount
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
    
    func waterFromHealthKit(_ statsCollection: HKStatisticsCollection) {
        
        // Get start and end date
        let startDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())!
        let endDate = Date()
        
        // Go through every date pulled from HealthKit
        statsCollection.enumerateStatistics(from: startDate, to: endDate) { stats, stop in
            
            // Get the summed amount converted to unit based on user preference
            let amount = stats.sumQuantity()?.doubleValue(for: self.drinkData.units == Constants.mL ? HKUnit.literUnit(with: .milli) : HKUnit.fluidOunceUS())
            
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
                    
                    let quantity = HKQuantity(unit: self.drinkData.units == Constants.mL ? HKUnit.literUnit(with: .milli) : HKUnit.fluidOunceUS(), doubleValue: drink.amount)
                    
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
