//
//  IntakeDayDataPicker.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/7/21.
//

import SwiftUI

struct IntakeDayDataPicker: View {
    
    @EnvironmentObject var model: DrinkModel
    
    @Environment(\.dynamicTypeSize) var dynamicType
    
    @Binding var selectedDate: Date
    
    @State var isTomorrow = false
    
    var body: some View {
        HStack {
            Button(action: {
                // Set new date
                let calendar = Calendar.current
                selectedDate = calendar.date(byAdding: .day, value: -1, to: selectedDate) ?? Date()
                // Check if the next day is today or passed
                isTomorrow = Calendar.current.isDateInTomorrow(selectedDate)
            }, label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(model.grayscaleEnabled ? .primary : .red)
            })
            .accessibilityHidden(true)

            Spacer()
            
            // Display Month Day, Year
            Text(dateFormatter().string(from: selectedDate))
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
                    isTomorrow = Calendar.current.isDateInTomorrow(selectedDate)
                }
            }, label: {
                Image(systemName: "chevron.right")
                    .foregroundColor(isTomorrow ? .gray : (model.grayscaleEnabled ? .primary : .red))
            })
            .disabled(isTomorrow)
            .accessibilityHidden(true)
        }
        .padding(.horizontal)
        .padding(.bottom, 6)
        .onAppear {
            self.isTomorrow = Calendar.current.isDateInTomorrow(selectedDate)
        }
        .accessibilityElement(children: .combine)
        .accessibilityHint("Go forward or back a day")
        .accessibilityAdjustableAction({ direction in
            switch direction {
            case .increment:
                if let newDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate) {
                    if !isTomorrow {
                        selectedDate = newDate
                        isTomorrow = Calendar.current.isDateInTomorrow(selectedDate)
                    } else {
                        break
                    }
                } else {
                    break
                }
            case .decrement:
                if let newDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate) {
                    selectedDate = newDate
                    isTomorrow = Calendar.current.isDateInTomorrow(selectedDate)
                } else {
                    break
                }
            @unknown default:
                break
            }
        })
    }
    
    func dateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        
        if !dynamicType.isAccessibilitySize {
            formatter.timeStyle = .none
            formatter.dateStyle = .long
        } else {
            formatter.dateFormat = "MMM. d, yyyy"
        }
        
        return formatter
    }
}
