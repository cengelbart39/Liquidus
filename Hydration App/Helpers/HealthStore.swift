//
//  HealthStore.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/11/21.
//

import Foundation
import HealthKit
import SwiftUI

extension Date {
    static func mondayAt12AM() -> Date {
        return Calendar(identifier: .iso8601).date(from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
    }
}

class HealthStore {
    
    var healthStore: HKHealthStore?
    var waterQuery: HKStatisticsCollectionQuery?
    var caffeineQuery: HKStatisticsCollectionQuery?
    var lastSaved: Date? = nil
    
    
    init() {
        // Check if there is authorization to access Health data
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }
    
    func getHealthKitData(completion: @escaping (HKStatisticsCollection?) -> Void) {
        
        // Set what data to pull
        let waterType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryWater)!
        
        // Create dates
        let startDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())
        let endDate = Date()
        
        // Set to pull data by the second
        let second = DateComponents(second: 1)
        
        // Set bounds on what data is pulled
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        // Pull data for water
        waterQuery = HKStatisticsCollectionQuery(quantityType: waterType, quantitySamplePredicate: predicate, options: .separateBySource, anchorDate: Date.mondayAt12AM(), intervalComponents: second)
        
        waterQuery!.initialResultsHandler = { query, statisticsCollection, error in
            completion(statisticsCollection)
        }
        
        // If the health store exists and waterQuery exists
        if let healthStore = healthStore, let water = self.waterQuery {
            healthStore.execute(water)
        }
        
    }
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        
        // Set HealthKit data types
        let waterType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryWater)!
    
        // Check if healthStore exists
        guard let healthStore = self.healthStore else { return completion(false) }
        
        // Request read/write access to Water and Caffeine Data
        healthStore.requestAuthorization(toShare: [waterType], read: [waterType]) { success, error in
            completion(success)
        }
    }
}
