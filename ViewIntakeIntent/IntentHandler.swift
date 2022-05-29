//
//  IntentHandler.swift
//  ViewIntakeIntent
//
//  Created by Christopher Engelbart on 1/22/22.
//
//  Implementation Based Off Of:
//  https://www.answertopia.com/swiftui/a-swiftui-siri-shortcut-tutorial/
//

import Intents
import SwiftUI

class IntentHandler: INExtension, ViewIntakeIntentHandling {
    
    var data = DrinkData()
    
    override func handler(for intent: INIntent) -> Any {
        
        guard intent is ViewIntakeIntent else {
            fatalError("Unknown intent type: \(intent)")
        }
        
        return self
    }
    
    func handle(intent: ViewIntakeIntent, completion: @escaping (ViewIntakeIntentResponse) -> Void) {
        guard let _ = timePeriod(for: intent) else {
            completion(ViewIntakeIntentResponse(code: .failure, userActivity: nil))
            return
        }
        
        let result = getData()
        
        if result {
            completion(ViewIntakeIntentResponse.success(amount: self.getAmount(intent: intent), goal: self.getGoal(intent: intent), units: self.getUnits(), percent: self.getPercent(intent: intent), timePeriod: intent.timePeriod))
        } else {
            completion(ViewIntakeIntentResponse(code: .failure, userActivity: nil))
        }
    }
    
    func resolveTimePeriod(for intent: ViewIntakeIntent, with completion: @escaping (EnumResolutionResult) -> Void) {
        if let _ = timePeriod(for: intent) {
            completion(EnumResolutionResult.success(with: intent.timePeriod))
        } else {
            completion(EnumResolutionResult.needsValue())
        }
    }
    
    public func confirm(intent: ViewIntakeIntent, completion: @escaping (ViewIntakeIntentResponse) -> Void) {
        completion(ViewIntakeIntentResponse(code: .ready, userActivity: nil))
    }
    
    /**
     Retrieve User Data
     - Returns: `true` if data is successfully retrieved; `false` if not
     */
    func getData() -> Bool {
        if let userDefaults = UserDefaults(suiteName: Constants.sharedKey) {
            if let data = userDefaults.data(forKey: Constants.savedKey) {
                if let decoded = try? JSONDecoder().decode(DrinkData.self, from: data) {
                    self.data = decoded
                    return true
                }
            }
        }
        return false
    }
    
    /**
     Converts `ViewIntakeIntent.timePeriod` to `TimePeriod`
     - Parameter configuration: The `ViewIntakeIntent`
     - Returns: The appropriate `TimePeriod`; `nil` if there is an unrecognized `configuration.timePeriod` case
     */
    private func timePeriod(for configuration: ViewIntakeIntent) -> TimePeriod? {
        switch configuration.timePeriod {
        case .day:
            return .daily
        case .week:
            return .weekly
        default:
            return nil
        }
    }
    
    /**
     Returns a `String` for the appropriate `TimePeriod`
     - Parameter timePeriod: A case of `TimePeriod`
     - Returns: "Daily" or "Weekly"; An empty `String` will be returned for the monthly, half-yearly, or yearly cases
     */
    private func toString(for timePeriod: TimePeriod) -> String {
        switch timePeriod {
        case .daily:
            return "Daily"
            
        case .weekly:
            return "Weekly"
            
        default:
            return ""
        }
    }
    
    /**
     Returns the appropriate Unit Abbreviation for the stored unit
     - Returns: A unit abbreviation
     */
    private func getUnits() -> String {
        if self.data.units == Constants.cupsUS {
            return Constants.cups
            
        } else if self.data.units == Constants.milliliters {
            return Constants.mL
            
        } else if self.data.units == Constants.liters {
            return Constants.L
            
        } else if self.data.units == Constants.fluidOuncesUS {
            return Constants.flOzUS
            
        }
        
        return ""
    }
    
    /**
     Get the user's daily or weekly goal
     - Parameter intent: A `ViewIntakeIntent`
     - Returns: The user's daily or weekly goal
     */
    private func getGoal(intent: ViewIntakeIntent) -> NSNumber {
        let goal = self.data.dailyGoal
        
        if self.timePeriod(for: intent) == .daily {
            return NSNumber.init(value: goal)
            
        } else {
            return NSNumber.init(value: goal*7)
        }
    }
    
    /**
     Get the total amount consumed today
     - Parameter intent: A `ViewIntakeIntent`
     - Returns: The total amount consumed during the user's current day or week
     */
    private func getAmount(intent: ViewIntakeIntent) -> NSNumber {
        
        // If the timePeriod is daily
        if self.timePeriod(for: intent) == .daily {
            
            // Get the total amount
            let totalAmount = IntentLogic.getTotalAmountByDay(date: .now, data: self.data)
            
            // Return totalAmount as a NSNumber
            return NSNumber.init(value: totalAmount)
           
        // If timePeriod is weekly
        } else {
            // Get the current week
            let week = IntentLogic.getDaysInWeek(date: .now)
            
            // Get the total amount
            let totalAmount = IntentLogic.getTotalAmountByWeek(week: week, data: self.data)
            
            // Return totalAmount as a NSNumber
            return NSNumber.init(value: totalAmount)
        }
    }
    
    /**
     Ge the percentage towards the user's daily or weekly goal
     - Parameter intent: A `ViewIntakeIntent`
     - Returns: The percentage towards the user's daily or weekly goal
     */
    private func getPercent(intent: ViewIntakeIntent) -> NSNumber {
        
        // If timePeriod is daily
        if self.timePeriod(for: intent) == .daily {
            
            // Get the percentage
            let percent = IntentLogic.getTotalPercentByDay(date: .now, data: data)*100
            
            // Configure Number formatter
            let formatter = NumberFormatter()
            formatter.usesSignificantDigits = true
            formatter.maximumSignificantDigits = 2
            formatter.minimumSignificantDigits = 2
            
            // Convert the percent to a formatted string
            if let str = formatter.string(from: NSNumber.init(value: percent)) {
                
                // Convert String to Double
                if let double = Double(str) {
                    
                    // Return Double as NSNumber
                    return NSNumber.init(value: double)
                }
            }
            
            // If ether if-let fails return 0
            return 0.0
            
        } else {
            
            // Get days in week
            let week = IntentLogic.getDaysInWeek(date: .now)
            
            // Get percentage
            let percent = IntentLogic.getTotalPercentByWeek(week: week, data: self.data)
            
            // Configure Number Formatter
            let formatter = NumberFormatter()
            formatter.usesSignificantDigits = true
            formatter.maximumSignificantDigits = 2
            formatter.minimumSignificantDigits = 2
            
            // Convert percentage to formatted string
            if let str = formatter.string(from: NSNumber.init(value: percent)) {
                
                // Convert String to Double
                if let double = Double(str) {
                    
                    // Return Double as NSNumber
                    return NSNumber.init(value: double)
                }
                
            }

            // If either if-let fails return 0
            return 0
        }
    }
    
}
