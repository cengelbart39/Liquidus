//
//  IntentHandler.swift
//  ViewIntakeIntent
//
//  Created by Christopher Engelbart on 1/22/22.
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
    
    private func timePeriod(for configuration: ViewIntakeIntent) -> Constants.TimePeriod? {
        switch configuration.timePeriod {
        case .day:
            return .daily
        case .week:
            return .weekly
        default:
            return nil
        }
    }
    
    private func toString(for timePeriod: Constants.TimePeriod) -> String {
        switch timePeriod {
        case .daily:
            return "Daily"
            
        case .weekly:
            return "Weekly"
            
        default:
            return ""
        }
    }
    
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
    
    private func getGoal(intent: ViewIntakeIntent) -> NSNumber {
        let goal = self.data.dailyGoal
        
        if self.timePeriod(for: intent) == .daily {
            return NSNumber.init(value: goal)
        } else {
            return NSNumber.init(value: goal*7)
        }
    }
    
    private func getAmount(intent: ViewIntakeIntent) -> NSNumber {
        
        if self.timePeriod(for: intent) == .daily {
            return NSNumber.init(value: IntentLogic.getTotalAmountByDay(date: .now, data: self.data))
        } else {
            let week = IntentLogic.getDaysInWeek(date: .now)
            
            return NSNumber.init(value: IntentLogic.getTotalAmountByWeek(week: week, data: self.data))
        }
    }
    
    private func getPercent(intent: ViewIntakeIntent) -> NSNumber {
        
        if self.timePeriod(for: intent) == .daily {
            let percent = IntentLogic.getTotalPercentByDay(date: .now, data: data)*100
            
            let formatter = NumberFormatter()
            formatter.usesSignificantDigits = true
            formatter.maximumSignificantDigits = 2
            formatter.minimumSignificantDigits = 2
            
            if let num = Double(formatter.string(from: NSNumber.init(value: percent)) ?? "") {
                return NSNumber.init(value: num)
            }
            
            return 0.0
        } else {
            
            let week = IntentLogic.getDaysInWeek(date: .now)
            
            let percent = IntentLogic.getTotalPercentByWeek(week: week, data: self.data)
            
            let formatter = NumberFormatter()
            formatter.usesSignificantDigits = true
            formatter.maximumSignificantDigits = 2
            formatter.minimumSignificantDigits = 2
            
            if let num = Double(formatter.string(from: NSNumber.init(value: percent)) ?? "") {
                return NSNumber.init(value: num)
            } else {
                return 0.0
            }
        }
    }
    
}
