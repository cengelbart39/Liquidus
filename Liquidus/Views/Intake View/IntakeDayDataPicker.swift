//
//  IntakeDayDataPicker.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 9/7/21.
//

import SwiftUI

struct IntakeDayDataPicker: View {
    
    @EnvironmentObject var model: DrinkModel
    
    @Environment(\.dynamicTypeSize) var dynamicType
    
    @Binding var selectedDate: Day

    @State var isTomorrow = false
    @Binding var trigger: Bool
    
    var body: some View {
        
        HStack {
            Button(action: {
                // Set new date
                selectedDate.prevDay()
                // Check if the next day is today or passed
                isTomorrow = selectedDate.isTomorrow()
                // Update view
                trigger.toggle()
            }, label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(model.grayscaleEnabled ? .primary : .red)
            })
            .accessibilityHidden(true)

            Spacer()
            
            // Display Month Day, Year
            Text(selectedDate.description)
                .foregroundColor(.primary)
                .accessibilityLabel(selectedDate.accessibilityDescription)
            
            Spacer()
            
            Button(action: {
                // If this day is/has occured...
                if !isTomorrow {
                    // Update currentDate
                    selectedDate.nextDay()
                    // Check if this new day has occured
                    isTomorrow = selectedDate.isTomorrow()
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
            self.isTomorrow = selectedDate.isTomorrow()
        }
        .onChange(of: trigger, perform: { _ in
            // Updates view based on Today trigger
            isTomorrow = selectedDate.isTomorrow()
        })
        .accessibilityElement(children: .combine)
        .accessibilityHint("Go forward or back a day")
        .accessibilityAdjustableAction({ direction in
            switch direction {
            case .increment:
                if !isTomorrow {
                    selectedDate.nextDay()
                    self.isTomorrow = Calendar.current.isDateInTomorrow(selectedDate.data)
                    trigger.toggle()
                
                } else {
                    break
                }
 
            case .decrement:
                
                selectedDate.prevDay()
                self.isTomorrow = Calendar.current.isDateInTomorrow(selectedDate.data)
                trigger.toggle()

                
            @unknown default:
                break
            }
        })
    }
}
