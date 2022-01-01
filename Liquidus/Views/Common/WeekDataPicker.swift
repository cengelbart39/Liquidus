//
//  WeekDataPicker.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/7/21.
//

import SwiftUI

struct WeekDataPicker: View {
    
    @EnvironmentObject var model: DrinkModel
    
    @Binding var currentWeek: [Date]
    @State var selectedDay = Date()
    
    let dateFormatter: DateFormatter = { () -> DateFormatter in
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .long
        return formatter
    }()
    
    var body: some View {
        
        var isNextWeek = isNextWeek(currentWeek: currentWeek)
        
        let displayText = getWeekText(weekRange: model.getWeekRange(date: currentWeek[0]))
        
        HStack {
            Button(action: {
                let calendar = Calendar.current
                // Get each day of the week
                currentWeek = model.getDaysInWeek(date: calendar.date(byAdding: .day, value: -1, to: currentWeek[0]) ?? Date())
                // Check if any day in the next week has occured
                isNextWeek = self.isNextWeek(currentWeek: currentWeek)
            }, label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(.red)
            })
            
            Spacer()
            
            // Display week range
            Text(displayText)
            
            Spacer()
            
            Button(action: {
                let calendar = Calendar.current
                // Set next week
                let nextWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: currentWeek[0]) ?? Date()
                
                // If next week hasn't occured...
                if !isNextWeek {
                    // Update current week
                    currentWeek = model.getDaysInWeek(date: nextWeek)
                    // Check if any day in the next week has occured
                    isNextWeek = self.isNextWeek(currentWeek: currentWeek)
                }
            }, label: {
                Image(systemName: "chevron.right")
                    .foregroundColor(isNextWeek ? .gray : .red)
            })
            .disabled(isNextWeek)
        }
        .padding(.horizontal)
        .padding(.bottom, 6)
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
}

struct WeekDataPicker_Previews: PreviewProvider {
    static var previews: some View {
        WeekDataPicker(currentWeek: .constant(DrinkModel().getWeekRange(date: Date())))
            .environmentObject(DrinkModel())
    }
}
