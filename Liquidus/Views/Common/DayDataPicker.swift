//
//  DayDataPicker.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/7/21.
//

import SwiftUI

struct DayDataPicker: View {
    
    @EnvironmentObject var model: DrinkModel
    
    @Binding var selectedDate: Date
    
    let dateFormatter: DateFormatter = { () -> DateFormatter in
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .long
        return formatter
    }()
    
    var body: some View {
        
        var isTomorrow = isTomorrow(currentDate: selectedDate)
        
        HStack {
            Button(action: {
                // Set new date
                let calendar = Calendar.current
                selectedDate = calendar.date(byAdding: .day, value: -1, to: selectedDate) ?? Date()
                // Check if the next day is today or passed
                isTomorrow = self.isTomorrow(currentDate: selectedDate)
            }, label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(.red)
            })

            Spacer()
            
            // Display Month Day, Year
            Text(dateFormatter.string(from: selectedDate))
                .foregroundColor(.primary)
            
            Spacer()
            
            Button(action: {
                // Get next day
                let calendar = Calendar.current
                let nextDay = calendar.date(byAdding: .day, value: 1, to: selectedDate) ?? Date()
                
                // If this day is/has occured...
                if !isTomorrow {
                    // Update currentDate
                    selectedDate = nextDay
                    // Check if this new day has occured
                    isTomorrow = self.isTomorrow(currentDate: selectedDate)
                }
            }, label: {
                Image(systemName: "chevron.right")
                    .foregroundColor(isTomorrow ? .gray : .red)
            })
            .disabled(isTomorrow)
        }
        .padding(.horizontal)
        .padding(.bottom, 6)
    }
    
    func isTomorrow(currentDate: Date) -> Bool {
        let calendar = Calendar.current
        
        // Get the next day and tomorrow date
        let nextDay = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? Date()
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date()) ?? Date()
            
        // If they are the same...
        if dateFormatter.string(from: nextDay) == dateFormatter.string(from: tomorrow) {
            return true
        // If not
        } else {
            return false
        }
    }
}
