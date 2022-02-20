//
//  TrendsBarChartAudioGraph.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 2/16/22.
//

import SwiftUI

extension TrendsBarChartView: AXChartDescriptorRepresentable {
    
    func makeChartDescriptor() -> AXChartDescriptor {
        // Data Items
        let dataItems = self.getDataItems()
        
        // X-Axis
        let xAxis = AXCategoricalDataAxisDescriptor(
            attributedTitle: self.xAxisTitle(),
            categoryOrder: self.verticalAxisText(dataItems: dataItems))
        
        // Y-Axis
        let yAxis = AXNumericDataAxisDescriptor(
            attributedTitle: self.yAxisTite(),
            range: self.yAxisRange(dataItems: dataItems),
            gridlinePositions: self.yAxisGridlines(dataItems: dataItems)) { value in
                "\(value) \(model.getAccessibilityUnitLabel())"
            }
        
        // Series
        let series = AXDataSeriesDescriptor(
            attributedName: NSAttributedString(string: ""),
            isContinuous: false,
            dataPoints: self.seriesDataPoints(dataItems: dataItems))
        
        return AXChartDescriptor(
            attributedTitle: NSAttributedString(string: self.getChartAccessibilityLabel()),
            summary: nil,
            xAxis: xAxis,
            yAxis: yAxis,
            additionalAxes: [],
            series: [series])
    }

    /**
     Based on the selected time period, return the title of the X-Axis as a NSAttributed String
     */
    func xAxisTitle() -> NSAttributedString {
        if selectedTimePeriod == .daily {
            return NSAttributedString(string: "Hours in Day")
            
        } else if selectedTimePeriod == .weekly {
            return NSAttributedString(string: "Days in Week")
            
        } else if selectedTimePeriod == .monthly {
            return NSAttributedString(string: "Days in Month")
            
        } else if selectedTimePeriod == .halfYearly {
            return NSAttributedString(string: "Weeks in Half Year")
            
        } else if selectedTimePeriod == .yearly {
            return NSAttributedString(string: "Months in Year")
        }
        
        return NSAttributedString()
    }
    
    /**
     Return the Y-Axis Title as a NSAttributedString
     */
    func yAxisTite() -> NSAttributedString {
        return NSAttributedString(string: "\(model.drinkData.units) consumed")
    }
    
    /**
     Return the range of the Y-Axis as a ClosedRange Double
     */
    func yAxisRange(dataItems: [DataItem]) -> ClosedRange<Double> {
        // Get horizontal axis text
        let text = self.horizontalAxisText(dataItems: dataItems)
        
        // Get first element
        if let first = text.first {
            // Convert text to double and return range
            if let max = Double(first) {
                return 0...max
            }
        }
        
        // If unable to convert double or get first element
        return 0...0
    }
    
    /**
     Get the placement of gridlines for the Y-Axis
     */
    func yAxisGridlines(dataItems: [DataItem]) -> [Double] {
        // Get horizontal axis text
        let text = self.horizontalAxisText(dataItems: dataItems)
        
        // Empty double array
        var output = [Double]()
        
        // Loop through text
        for t in text {
            
            // Try to convert text to double
            if let d = Double(t) {
                
                // Append to output
                output.append(d)
            }
        }
        
        return output
    }
    
    /**
     For an array of DataItem, get the minimum value
     */
    func getMinValue(dataItems: [DataItem]) -> Double {
        // If the time period is not half year  or year, map data items to get max
        if selectedTimePeriod != .halfYearly && selectedTimePeriod != .yearly {
            return dataItems.map { $0.getMinValue() }.min() ?? 0.0
            
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
            return dailyIntake.map { $0 }.min() ?? 0.0
        }
    }
    
    /**
     For an array of DataItem, get an array of AXDataPoint using selectedTimePeriod
     */
    func seriesDataPoints(dataItems: [DataItem]) -> [AXDataPoint] {
        var output = [AXDataPoint]()
        
        // If daily is selected
        if selectedTimePeriod == .daily {
            // Create formatter
            let formatter = DateFormatter()
            formatter.dateFormat = "H"
            
            // Loop through dataItems
            for item in dataItems {
                
                // Create and append AXDataPoints
                output.append(AXDataPoint(x: self.dataPointHourRangeText(item: item), y: item.getIndividualAmount()))
            }
            
        // If weekly or monthly is selected
        } else if selectedTimePeriod == .weekly || selectedTimePeriod == .monthly {
            
            // Create formatter
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            
            // Loop through items
            for item in dataItems {
                
                // Create and append AXDataPoints
                output.append(AXDataPoint(x: formatter.string(from: item.date), y: item.getIndividualAmount()))
            }
            
        // If half yearly
        } else if selectedTimePeriod == .halfYearly {
            
            // Loop through data items
            for item in dataItems {
                
                // Append AXDataPoints
                output.append(AXDataPoint(x: self.dataPointWeekRange(item: item), y: item.getIndividualAmount()))
            }
        
        // If yearly
        } else if selectedTimePeriod == .yearly {
            
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
    func dataPointWeekRange(item: DataItem) -> String {
        // Get days in week for item
        let week = model.getDaysInWeek(date: item.date)
        
        // If week exists in selectedHalfYear
        // i.e. week wasn't cut off for containg dates out of 6-month period
        if selectedHalfYear.contains(week) {
            return model.getAccessibilityWeekText(week: week)
            
        } else {
            // Get the first and last elements of selectedHalfYear
            if let first = selectedHalfYear.first, let last = selectedHalfYear.last {
                
                var cutWeek = [Date]()
                
                // Loop through first
                for day in first {
                    
                    // Append dates that are in week
                    if week.contains(day) {
                        cutWeek.append(day)
                    }
                }
                
                // If no matching dates exist in first
                if cutWeek.count == 0 {
                    
                    // Loop through last
                    for day in last {
                        
                        // Append dates that are in week
                        if week.contains(day) {
                            cutWeek.append(day)
                        }
                    }
                }
                
                // Return text if dates are in cutWeek
                if cutWeek.count < 0 {
                    return model.getAccessibilityWeekText(week: cutWeek)
                }
            }
        }
        
        return ""
    }
    
    /**
     Get accessibility label for AXChart
     */
    func getAXChartAccessibilityLabel() -> NSAttributedString {
        
        // If monthly isn't selected use getChartAccessibilityLabel
        if selectedTimePeriod != .monthly {
            return NSAttributedString(string: self.getChartAccessibilityLabel())
            
        } else {
            //Get formatter
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM y"
            
            // Get first element
            if let first = selectedMonth.first {
                
                // If all data is selected
                if type == Constants.allKey {
                    return NSAttributedString(string: "Data representing your data on \(formatter.string(from: first))")
                    
                // If a specific drink type is selected
                } else {
                    return NSAttributedString(string: "Data representing your \(type) data on \(formatter.string(from: first))")
                }
            }
            
            return NSAttributedString(string: "")
        }
    }
    
    
}
