//
//  DrinkModel.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/7/21.
//

import Foundation

class DrinkModel: ObservableObject {
    
    @Published var drinkData = DrinkData()
    
    init() {
        if let data = UserDefaults.standard.data(forKey: Constants.savedKey) {
            if let decoded = try? JSONDecoder().decode(DrinkData.self, from: data) {
                self.drinkData = decoded
                return
            }
        }
        
        self.drinkData = DrinkData()
    }
    
    func save() {
        if let encoded = try? JSONEncoder().encode(drinkData) {
            UserDefaults.standard.set(encoded, forKey: Constants.savedKey)
        }
    }
    
    func addDrink(drink: Drink) {
        drinkData.drinks.append(drink)
        self.save()
    }
    
    func convertMeasurements() {
        if self.drinkData.units == Constants.milliliters {
            self.drinkData.dailyGoal *= Constants.ozTOml
            
            for drink in drinkData.drinks {
                drink.amount *= Constants.ozTOml
            }
        } else {
            self.drinkData.dailyGoal *= Constants.mlTOoz
            
            for drink in drinkData.drinks {
                drink.amount *= Constants.mlTOoz
            }
        }
        self.save()
    }
    
    func filterDataByDay(day: Date) -> [Drink] {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        var filtered = drinkData.drinks.filter { dateFormatter.string(from: $0.date) == dateFormatter.string(from: day) }
        
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        
        filtered.sort { $0.date > $1.date }
        return filtered
    }
    
    func filterByDrinkType(type: String, date: Date) -> [Drink] {
        let time = filterDataByDay(day: date)
        
        let filtered = time.filter { $0.type == type }
        
        return filtered
    }
    
    func getDrinkTypeAmount(type: String, date: Date) -> Double {
        let drinks = self.filterByDrinkType(type: type, date: date)
        
        var totalAmount = 0.0
        for drink in drinks {
            totalAmount += Double(drink.amount)
        }
        
        return totalAmount
    }
    
    func getDrinkTypePercent(type: String, date: Date) -> Double {
        
        let amount = self.getDrinkTypeAmount(type: type, date: date)
        
        let percent = amount / self.drinkData.dailyGoal
        
        return percent
    }
    
    func getTotalAmount(date: Date) -> Double {
        let water = self.getDrinkTypeAmount(type: Constants.waterKey, date: date)
        let coffee = self.getDrinkTypeAmount(type: Constants.coffeeKey, date: date)
        let soda = self.getDrinkTypeAmount(type: Constants.sodaKey, date: date)
        let juice = self.getDrinkTypeAmount(type: Constants.juiceKey, date: date)
        
        let totalAmount = water+coffee+soda+juice
        
        return totalAmount
    }
    
    func getTotalPercent(date: Date) -> Double {
        
        let totalAmount = getTotalAmount(date: date)
        
        let percent = totalAmount / self.drinkData.dailyGoal
        
        return percent
        
    }
}
