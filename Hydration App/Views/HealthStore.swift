//
//  HealthStore.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/11/21.
//

import Foundation
import HealthKit

extension Date {
    static func mondayAt12AM() -> Date {
        return Calendar(identifier: .iso8601).date(from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
    }
}

class HealthStore {
    
    var healthStore: HKHealthStore?
    var waterQuery: HKStatisticsCollectionQuery?
    var caffeineQuery: HKStatisticsCollectionQuery?
    
    init() {
        // Check if there is authorization to access Health data
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }
    
    func getHealthKitData(completion: @escaping (HKStatisticsCollection?) -> Void) {
        
        // Set what data to pull
        let waterType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryWater)!
        let caffeineType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCaffeine)!
        
        // Create dates
        let startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())
        let endDate = Date()
        
        // Set to pull data by the minute
        let second = DateComponents(minute: 1)
        
        // Set bounds on what data is pulled
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        
        // Pull data for water
        waterQuery = HKStatisticsCollectionQuery(quantityType: waterType, quantitySamplePredicate: predicate, options: .separateBySource, anchorDate: Date.mondayAt12AM(), intervalComponents: minute)
        
        // Pull data for caffeine
        caffeineQuery = HKStatisticsCollectionQuery(quantityType: caffeineType, quantitySamplePredicate: predicate, options: .separateBySource, anchorDate: Date.mondayAt12AM(), intervalComponents: minute)
        
        waterQuery!.initialResultsHandler = { query, statisticsCollection, error in
            completion(statisticsCollection)
        }
        
        caffeineQuery!.initialResultsHandler = { query, statisticsCollection, error in
            completion(statisticsCollection)
        }
        
        // If the health store exists and waterQuery exists
        if let healthStore = healthStore, let water = self.waterQuery {
            healthStore.execute(water)
            //healthStore.execute(caffeine)
        }
        
    }
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        
        // Set HealthKit data types
        let waterType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryWater)!
        let caffeineType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCaffeine)!
    
        // Check if healthStore exists
        guard let healthStore = self.healthStore else { return completion(false) }
        
        // Request read/write access to Water and Caffeine Data
        healthStore.requestAuthorization(toShare: [waterType, caffeineType], read: [waterType, caffeineType]) { success, error in
            completion(success)
        }
    }
    
}
