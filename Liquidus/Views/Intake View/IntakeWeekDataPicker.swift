//
//  IntakeWeekDataPicker.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/7/21.
//

import SwiftUI

struct IntakeWeekDataPicker: View {
    
    @EnvironmentObject var model: DrinkModel
    
    @Binding var currentWeek: [Date]
    @State var selectedDay = Date()
    
    @State var isNextWeek = false
    
    let dateFormatter: DateFormatter = { () -> DateFormatter in
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .long
        return formatter
    }()
    
    var body: some View {
        
        let displayText = self.getWeekText(weekRange: model.getWeekRange(date: self.currentWeek[0]))
        
        HStack {
            Button(action: {
                let calendar = Calendar.current
                // Get each day of the week
                self.currentWeek = model.getDaysInWeek(date: calendar.date(byAdding: .day, value: -1, to: self.currentWeek[0]) ?? Date())
                // Check if any day in the next week has occured
                self.isNextWeek = self.isNextWeek(currentWeek: self.currentWeek)
            }, label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(model.grayscaleEnabled ? .primary : .red)
            })
            .accessibilityHidden(true)
            
            Spacer()
            
            // Display week range
            Text(displayText)
                .accessibilityLabel(self.getAccessibilityWeekText(weekRange: model.getWeekRange(date: self.currentWeek[0])))
            
            Spacer()
            
            Button(action: {
                let calendar = Calendar.current
                // Set next week
                let nextWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: self.currentWeek[0]) ?? Date()
                
                // If next week hasn't occured...
                if !self.isNextWeek {
                    // Update current week
                    self.currentWeek = model.getDaysInWeek(date: nextWeek)
                    // Check if any day in the next week has occured
                    self.isNextWeek = self.isNextWeek(currentWeek: self.currentWeek)
                }
            }, label: {
                Image(systemName: "chevron.right")
                    .foregroundColor(self.isNextWeek ? .gray : (model.grayscaleEnabled ? .primary : .red))
            })
            .disabled(isNextWeek)
            .accessibilityHidden(true)
        }
        .padding(.horizontal)
        .padding(.bottom, 6)
        .onAppear {
            self.isNextWeek = self.isNextWeek(currentWeek: self.currentWeek)
        }
        .accessibilityElement(children: .combine)
        .accessibilityHint("Go forward or back a week")
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment:
                if let newWeek = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: self.currentWeek[0]) {
                    if !self.isNextWeek {
                        self.currentWeek = model.getDaysInWeek(date: newWeek)
                        self.isNextWeek = self.isNextWeek(currentWeek: self.currentWeek)
                    } else {
                        break
                    }
                } else {
                    break
                }
                
            case .decrement:
                if let newDate = Calendar.current.date(byAdding: .day, value: -1, to: self.currentWeek[0]) {
                    let newWeek = model.getWeekRange(date: newDate)
                    self.currentWeek = newWeek
                    self.isNextWeek = self.isNextWeek(currentWeek: newWeek)
                } else {
                    break
                }
            
            @unknown default:
                break
            }
        }
    }
    
    func isNextWeek(currentWeek: [Date]) -> Bool {
        let calendar = Calendar.current
        
        // Get the next week per currentWeek and the next week per today
        let nextWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: currentWeek[0]) ?? Date()
        let upcomingWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: Date()) ?? Date()
        
        // If both dates fall in the same week...
        if model.doesDateFallInWeek(date1: nextWeek, date2: upcomingWeek) {
            return true
        } else {
            return false
        }
        
    }
    
    func getWeekText(weekRange: [Date]) -> String {
        // Create a date formatter
        let formatter = DateFormatter()
        
        // Format for year only
        formatter.dateFormat = "yyyy"
        
        // If the year is the same...
        if formatter.string(from: weekRange[0]) == formatter.string(from: weekRange[1]) {
            
            let year = formatter.string(from: weekRange[0])
            
            // Format for month
            formatter.dateFormat = "MMM."
            
            // If the month is the same...
            if formatter.string(from: weekRange[0]) == formatter.string(from: weekRange[1]) {
                
                // Get date1
                formatter.dateFormat = "MMM. d"
                
                let date1 = formatter.string(from: weekRange[0])
                
                // Get date2
                formatter.dateFormat = "d"
                
                let date2 = formatter.string(from: weekRange[1])
                
                return "\(date1)-\(date2), \(year)"
                
                // If not...
            } else {
                
                // Formatt for month and day
                formatter.dateFormat = "MMM. d"
                
                // Get dates
                let date1 = formatter.string(from: weekRange[0])
                let date2 = formatter.string(from: weekRange[1])
                
                return "\(date1) - \(date2), \(year)"
                
            }
        } else {
            // Format for month and day
            formatter.dateFormat = "MMM. d, yyyy"
            
            // Get dates
            let date1 = formatter.string(from: weekRange[0])
            let date2 = formatter.string(from: weekRange[1])
            
            return "\(date1) - \(date2)"
        }
    }
    
    func getAccessibilityWeekText(weekRange: [Date]) -> String {
        // Create a date formatter
        let formatter = DateFormatter()
        
        // Format for year only
        formatter.dateFormat = "yyyy"
        
        // If the year is the same...
        if formatter.string(from: weekRange[0]) == formatter.string(from: weekRange[1]) {
            
            let year = formatter.string(from: weekRange[0])
            
            // Format for month
            formatter.dateFormat = "MMM."
            
            // If the month is the same...
            if formatter.string(from: weekRange[0]) == formatter.string(from: weekRange[1]) {
                
                // Get date1
                formatter.dateFormat = "MMM. d"
                
                let date1 = formatter.string(from: weekRange[0])
                
                // Get date2
                formatter.dateFormat = "d"
                
                let date2 = formatter.string(from: weekRange[1])
                
                let suffix1 = getDateSuffix(date: formatter.string(from: weekRange[0]))
                let suffix2 = getDateSuffix(date: formatter.string(from: weekRange[1]))
                
                return "\(date1)\(suffix1) to \(date2)\(suffix2), \(year)"
                
                // If not...
            } else {
                
                // Formatt for month and day
                formatter.dateFormat = "MMM. d"
                
                // Get dates
                let date1 = formatter.string(from: weekRange[0])
                let date2 = formatter.string(from: weekRange[1])
                
                formatter.dateFormat = "d"
                
                let suffix1 = self.getDateSuffix(date: formatter.string(from: weekRange[0]))
                let suffix2 = self.getDateSuffix(date: formatter.string(from: weekRange[1]))
                
                return "\(date1)\(suffix1) to \(date2)\(suffix2), \(year)"
                
            }
        } else {
            // Format for month and day
            formatter.dateFormat = "MMM. d"
            
            // Get dates
            let monthDay1 = formatter.string(from: weekRange[0])
            let monthDay2 = formatter.string(from: weekRange[1])
            
            formatter.dateFormat = "d"
            
            let suffix1 = self.getDateSuffix(date: formatter.string(from: weekRange[0]))
            let suffix2 = self.getDateSuffix(date: formatter.string(from: weekRange[1]))
            
            formatter.dateFormat = "yyyy"
            
            let year1 = formatter.string(from: weekRange[0])
            let year2 = formatter.string(from: weekRange[1])
            
            return "\(monthDay1)\(suffix1), \(year1) to \(monthDay2)\(suffix2), \(year2)"
        }
    }
    
    func getDateSuffix(date: String) -> String {
        let count = date.count
        
        var num = date
        if count == 2 {
            num = String(date.dropFirst(1))
        }
        
        switch num {
        case "1":
            return "st"
        case "2":
            return "nd"
        case "3":
            return "rd"
        default:
            return "th"
        }
    }
}

struct WeekDataPicker_Previews: PreviewProvider {
    static var previews: some View {
        IntakeWeekDataPicker(currentWeek: .constant(DrinkModel().getWeekRange(date: Date())))
            .environmentObject(DrinkModel())
    }
}
