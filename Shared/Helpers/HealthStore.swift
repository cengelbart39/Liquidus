//
//  HealthStore.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 9/11/21.
//
//  Implementation Based Off Of:
//  - https://developer.apple.com/videos/play/wwdc2020/10664/
//  - https://youtu.be/ohgrzM9gfvM by azamsharp
//

import Foundation
import HealthKit
import SwiftUI

extension Date {
    static func mondayAt12AM() -> Date {
        return Calendar(identifier: .iso8601).date(from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
    }
}

/**
 A class representing HealthKit-related data and methods
 */
class HealthStore {
    
    /// Store for all HealthKit Data granted access to
    var healthStore: HKHealthStore?
    
    /// Water Data retrieved from Apple Health (if there is any)
    var waterQuery: HKStatisticsCollectionQuery?
    
    /**
     Create a `HKHealthStore`
     - Precondition: The user authorized access to Apple Health data
     */
    init() {
        // Check if there is authorization to access Health data
        if HKHealthStore.isHealthDataAvailable() {
            // If so, create a HKHealthStore
            healthStore = HKHealthStore()
        }
    }
    
    /**
     Retrieve Water data from HealthKit
     - Parameter completion: An `@escaping HKStatisticsCollection?` that returns retrived HealthKit data
     - Precondition: User has granted access to HealthKit
     */
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
    
    /**
     Requests authorization to access HealthKit data
     - Parameter completion: Returns whether or not the user granted HealthKit access
     */
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
