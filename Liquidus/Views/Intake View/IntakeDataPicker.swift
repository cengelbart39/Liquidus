//
//  IntakeDataPicker.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 9/7/21.
//

import SwiftUI

struct IntakeDataPicker: View {
    
    @EnvironmentObject var model: DrinkModel
    
    @Environment(\.dynamicTypeSize) var dynamicType
    
    @Binding var day: Day

    @State var isTomorrow = false
    @Binding var trigger: Bool
    
    var body: some View {
        
        HStack {
            Button(action: {
                // Set new date
                day.prevDay()
                // Check if the next day is today or passed
                isTomorrow = day.isTomorrow()
                // Update view
                trigger.toggle()
            }, label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(model.grayscaleEnabled ? .primary : .red)
            })
            .accessibilityHidden(true)

            Spacer()
            
            // Display Month Day, Year
            Text(day.description)
                .foregroundColor(.primary)
                .accessibilityLabel(day.accessibilityDescription)
            
            Spacer()
            
            Button(action: {
                // If this day is/has occured...
                if !isTomorrow {
                    // Update currentDate
                    day.nextDay()
                    // Check if this new day has occured
                    isTomorrow = day.isTomorrow()
                    // Update view
                    trigger.toggle()
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
            self.isTomorrow = day.isTomorrow()
        }
        .onChange(of: trigger, perform: { _ in
            // Updates view based on Today trigger
            isTomorrow = day.isTomorrow()
        })
        .accessibilityElement(children: .combine)
        .accessibilityHint("Go forward or back a day")
        .accessibilityAdjustableAction({ direction in
            switch direction {
            case .increment:
                if !isTomorrow {
                    day.nextDay()
                    self.isTomorrow = Calendar.current.isDateInTomorrow(day.data)
                    trigger.toggle()
                
                } else {
                    break
                }
 
            case .decrement:
                
                day.prevDay()
                self.isTomorrow = Calendar.current.isDateInTomorrow(day.data)
                trigger.toggle()

                
            @unknown default:
                break
            }
        })
    }
}
