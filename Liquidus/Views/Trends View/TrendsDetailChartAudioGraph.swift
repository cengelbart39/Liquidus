//
//  TrendsDetailChartAudioGraph.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 2/16/22.
//

import SwiftUI

extension TrendsDetailChartView: AXChartDescriptorRepresentable {
    
    func makeChartDescriptor() -> AXChartDescriptor {
        // X-Axis
        let xAxis = AXCategoricalDataAxisDescriptor(
            attributedTitle: self.xAxisTitle(),
            categoryOrder: verticalAxisText)
        
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
            dataPoints: model.seriesDataPoints(dataItems: dataItems, timePeriod: timePeriod, halfYearOffset: halfYearOffset))
        
        return AXChartDescriptor(
            attributedTitle: NSAttributedString(string: chartAccessibilityLabel),
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
        if timePeriod == .daily {
            return NSAttributedString(string: "Hours in Day")
            
        } else if timePeriod == .weekly {
            return NSAttributedString(string: "Days in Week")
            
        } else if timePeriod == .monthly {
            return NSAttributedString(string: "Days in Month")
            
        } else if timePeriod == .halfYearly {
            return NSAttributedString(string: "Weeks in Half Year")
            
        } else if timePeriod == .yearly {
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
        let text = horizontalAxisText
        
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
        let text = horizontalAxisText
        
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
        if timePeriod != .halfYearly && timePeriod != .yearly {
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
     Get accessibility label for AXChart
     */
    func getAXChartAccessibilityLabel() -> NSAttributedString {
        
        // If monthly isn't selected use getChartAccessibilityLabel
        if timePeriod != .monthly {
            return NSAttributedString(string: chartAccessibilityLabel)
            
        } else {
            //Get formatter
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM y"
            
            // Get date in selected month
            if let startDate = Calendar.current.date(byAdding: .month, value: monthOffset, to: .now) {
                
                // Get first element
                if let first = model.getMonth(day: startDate).first {
                    
                    // If all data is selected
                    if type.name == Constants.totalKey {
                        return NSAttributedString(string: "Data representing your data on \(formatter.string(from: first))")
                        
                    // If a specific drink type is selected
                    } else {
                        return NSAttributedString(string: "Data representing your \(type) data on \(formatter.string(from: first))")
                    }
                }
            }
            
            return NSAttributedString(string: "")
        }
    }
}
