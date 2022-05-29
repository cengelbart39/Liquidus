//
//  SampleAXDataPoints.swift
//  LiquidusTests
//
//  Created by Christopher Engelbart on 5/12/22.
//

import Foundation
import SwiftUI
@testable import Liquidus

/**
 A container class for static methods that generate a set of `AXDataPoint`s for objects conformant to `DatesProtocol`
 */
class SampleAXDataPoints {
    /**
     Gets a sample set of `AXDataPoint`s with a `AXDataPoint` for every `Hour` in the `Day`
     - Parameter day: The `Day` to create `AXDataPoint`s for
     - Returns: A sample set of `AXDataPoint`s
     */
    static func day(_ day: Day) -> [AXDataPoint] {
        // Empty AXDataPoint array
        var dataPoints = [AXDataPoint]()
        
        // Append dates for each hour in the day
        let hours = day.getHours()
        
        // Set X-Axis Text
        let text = [
            "12 to 1 AM",
            "1 to 2 AM",
            "2 to 3 AM",
            "3 to 4 AM",
            "4 to 5 AM",
            "5 to 6 AM",
            "6 to 7 AM",
            "7 to 8 AM",
            "8 to 9 AM",
            "9 to 10 AM",
            "10 to 11 AM",
            "11 AM to 12 PM",
            "12 to 1 PM",
            "1 to 2 PM",
            "2 to 3 PM",
            "3 to 4 PM",
            "4 to 5 PM",
            "5 to 6 PM",
            "6 to 7 PM",
            "7 to 8 PM",
            "8 to 9 PM",
            "9 to 10 PM",
            "10 to 11 PM",
            "11 PM to 12 AM"
        ]
        
        // Loop through dates array
        for index in 0..<hours.count {
            
            // Append AXDataPoint based on index
            dataPoints.append(AXDataPoint(x: text[index], y: SampleDrinkAmounts.day[index]))
        }
        
        // Return dataPoints
        return dataPoints
    }
    
    /**
     Gets a sample set of `AXDataPoint`s with a `AXDataPoint` for every `Day` in the `Week`
     - Parameter day: The `Week` to create `AXDataPoint`s for
     - Returns: A sample set of `AXDataPoint`s
     */
    static func week(_ week: Week) -> [AXDataPoint] {
        // Empty AXDataPoint array
        var dataPoints = [AXDataPoint]()

        // Set X-Axis Text
        let text = [
            "Apr 3, 2022",
            "Apr 4, 2022",
            "Apr 5, 2022",
            "Apr 6, 2022",
            "Apr 7, 2022",
            "Apr 8, 2022",
            "Apr 9, 2022"
        ]
        
        // Loop through weeks array
        for index in 0..<week.data.count {
            
            // Append AXDataPoint based on index
            dataPoints.append(AXDataPoint(x: text[index], y: SampleDrinkAmounts.week[index]))
        }
        
        // Return dataPoints
        return dataPoints
    }
    
    /**
     Gets a sample set of `AXDataPoint`s with a `AXDataPoint` for every `Day` in the `Month`
     - Parameter day: The `Month` to create `AXDataPoint`s for
     - Returns: A sample set of `AXDataPoint`s
     */
    static func month(_ month: Month) -> [AXDataPoint] {
        // Empty AXDataPoint array
        var dataPoints = [AXDataPoint]()
        
        // Set X-Axis Text
        let text = [
            "Apr 1, 2022",
            "Apr 2, 2022",
            "Apr 3, 2022",
            "Apr 4, 2022",
            "Apr 5, 2022",
            "Apr 6, 2022",
            "Apr 7, 2022",
            "Apr 8, 2022",
            "Apr 9, 2022",
            "Apr 10, 2022",
            "Apr 11, 2022",
            "Apr 12, 2022",
            "Apr 13, 2022",
            "Apr 14, 2022",
            "Apr 15, 2022",
            "Apr 16, 2022",
            "Apr 17, 2022",
            "Apr 18, 2022",
            "Apr 19, 2022",
            "Apr 20, 2022",
            "Apr 21, 2022",
            "Apr 22, 2022",
            "Apr 23, 2022",
            "Apr 24, 2022",
            "Apr 25, 2022",
            "Apr 26, 2022",
            "Apr 27, 2022",
            "Apr 28, 2022",
            "Apr 29, 2022",
            "Apr 30, 2022"
        ]
        
        // Loop through months array
        for index in 0..<month.data.count {
            
            // Append AXDataPoint based on index
            dataPoints.append(AXDataPoint(x: text[index], y: SampleDrinkAmounts.month[index]))
        }
        
        // Return dataPoints
        return dataPoints
    }
    
    /**
     Gets a sample set of `AXDataPoint`s with a `AXDataPoint` for every `Week` in the `HalfYear`
     - Parameter day: The `HalfYear` to create `AXDataPoint`s for
     - Returns: A sample set of `AXDataPoint`s
     */
    static func halfYear(_ halfYear: HalfYear) -> [AXDataPoint] {
        // Empty AXDataPoint array
        var dataPoints = [AXDataPoint]()
        
        // Set X-Axis Text
        let text = [
            "Nov 1st to 6th, 2021",
            "Nov 7th to 13th, 2021",
            "Nov 14th to 20th, 2021",
            "Nov 21st to 27th, 2021",
            "Nov 28th to Dec 4th, 2021",
            "Dec 5th to 11th, 2021",
            "Dec 12th to 18th, 2021",
            "Dec 19th to 25th, 2021",
            "Dec 26th, 2021 to Jan 1st, 2022",
            "Jan 2nd to 8th, 2022",
            "Jan 9th to 15th, 2022",
            "Jan 16th to 22nd, 2022",
            "Jan 23rd to 29th, 2022",
            "Jan 30th to Feb 5th, 2022",
            "Feb 6th to 12th, 2022",
            "Feb 13th to 19th, 2022",
            "Feb 20th to 26th, 2022",
            "Feb 27th to Mar 5th, 2022",
            "Mar 6th to 12th, 2022",
            "Mar 13th to 19th, 2022",
            "Mar 20th to 26th, 2022",
            "Mar 27th to Apr 2nd, 2022",
            "Apr 3rd to 9th, 2022",
            "Apr 10th to 16th, 2022",
            "Apr 17th to 23rd, 2022",
            "Apr 24th to 30th, 2022"
        ]
        
        // Loop through halfYear
        for i1 in 0..<halfYear.data.count {
            // Create weekAmount
            var weekAmount = 0.0
            
            // Loop through halfYear[i1]
            for i2 in 0..<halfYear.data[i1].data.count {
                
                // Cut off for Oct 31 so it starts at 200 instead of 100
                if (i1 == 0 && i2 < 6) {
                    weekAmount += SampleDrinkAmounts.week[i2+1]
                
                // Add using i2
                } else {
                    weekAmount += SampleDrinkAmounts.week[i2]
                }
            }
            
            // Append data point
            dataPoints.append(AXDataPoint(x: text[i1], y: weekAmount))
        }
        
        // Return data points
        return dataPoints
    }
    
    /**
     Gets a sample set of `AXDataPoint`s with a `AXDataPoint` for every `Month` in the `Year`
     - Parameter day: The `Year` to create `AXDataPoint`s for
     - Returns: A sample set of `AXDataPoint`s
     */
    static func year(_ year: Year) -> [AXDataPoint] {
        // Empty AXDataPoint array
        var dataPoints = [AXDataPoint]()
        
        // Set X-Axis Text
        let text = [
            "May 2021",
            "June 2021",
            "July 2021",
            "August 2021",
            "September 2021",
            "October 2021",
            "November 2021",
            "December 2021",
            "January 2022",
            "February 2022",
            "March 2022",
            "April 2022"
        ]
        
        // Loop through year
        for i1 in 0..<year.data.count {
            // Create drinkAmount
            var drinkAmount = 0.0
            
            // Loop through year[i1] and add to drinkAmount
            for i2 in 0..<year.data[i1].data.count {
                drinkAmount += SampleDrinkAmounts.month[i2]
            }
            
            // Append data point
            dataPoints.append(AXDataPoint(x: text[i1], y: drinkAmount))
        }
        
        // Return data points
        return dataPoints
    }
}
