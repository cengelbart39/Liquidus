//
//  IntakeWeekDataPicker.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 9/7/21.
//

import SwiftUI

struct IntakeWeekDataPicker: View {
    
    @EnvironmentObject var model: DrinkModel
    
    @Binding var currentWeek: Week
    @Binding var trigger: Bool
    
    @State var isNextWeek = false
    
    var body: some View {
        HStack {
            Button(action: {
                // Get each day of the week
                self.currentWeek.prevWeek()
                // Check if any day in the next week has occured
                self.isNextWeek = currentWeek.isNextWeek()
                // Update view
                trigger.toggle()
            }, label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(model.grayscaleEnabled ? .primary : .red)
            })
            .accessibilityHidden(true)
            
            Spacer()
            
            // Display week range
            Text(currentWeek.description)
                .accessibilityLabel(currentWeek.accessibilityDescription)
            
            Spacer()
            
            Button(action: {
                // If next week hasn't occured...
                if !self.isNextWeek {
                    // Update current week
                    self.currentWeek.nextWeek()
                    // Check if any day in the next week has occured
                    self.isNextWeek = currentWeek.isNextWeek()
                    // Update view
                    trigger.toggle()
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
            self.isNextWeek = currentWeek.isNextWeek()
        }
        .onChange(of: trigger, perform: { _ in
            isNextWeek = currentWeek.isNextWeek()
        })
        .accessibilityElement(children: .combine)
        .accessibilityHint("Go forward or back a week")
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment:
                if !isNextWeek {
                    currentWeek.nextWeek()
                    isNextWeek = currentWeek.isNextWeek()
                    trigger.toggle()
                
                } else {
                    break
                }
                
            case .decrement:
                
                currentWeek.prevWeek()
                isNextWeek = currentWeek.isNextWeek()
                trigger.toggle()
            
            @unknown default:
                break
            }
        }
    }
}
