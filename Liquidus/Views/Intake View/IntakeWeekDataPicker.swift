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
        
        let displayText = model.getWeekText(week: currentWeek)
        
        HStack {
            Button(action: {
                let calendar = Calendar.current
                // Get each day of the week
                self.currentWeek = model.getDaysInWeek(date: calendar.date(byAdding: .day, value: -1, to: self.currentWeek[0]) ?? Date())
                // Check if any day in the next week has occured
                self.isNextWeek = model.isNextWeek(currentWeek: self.currentWeek)
            }, label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(model.grayscaleEnabled ? .primary : .red)
            })
            .accessibilityHidden(true)
            
            Spacer()
            
            // Display week range
            Text(displayText)
                .accessibilityLabel(model.getAccessibilityWeekText(week: currentWeek))
            
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
                    self.isNextWeek = model.isNextWeek(currentWeek: self.currentWeek)
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
            self.isNextWeek = model.isNextWeek(currentWeek: self.currentWeek)
        }
        .accessibilityElement(children: .combine)
        .accessibilityHint("Go forward or back a week")
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment:
                if let newWeek = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: self.currentWeek[0]) {
                    if !self.isNextWeek {
                        self.currentWeek = model.getDaysInWeek(date: newWeek)
                        self.isNextWeek = model.isNextWeek(currentWeek: self.currentWeek)
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
                    self.isNextWeek = model.isNextWeek(currentWeek: newWeek)
                } else {
                    break
                }
            
            @unknown default:
                break
            }
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
