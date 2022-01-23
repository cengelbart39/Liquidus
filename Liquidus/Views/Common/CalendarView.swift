//
//  CalendarView.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 12/26/21.
//

import SwiftUI

struct CalendarView: View {
    
    @EnvironmentObject var model: DrinkModel
    
    @Binding var isPresented: Bool
    
    @Binding var selectedDay: Date
    var selectedPeriod: Constants.TimePeriod
    
    var body: some View {
        NavigationView {
                Form {
                    Section(footer: selectedPeriod == .weekly ? Text("Choose a date within the week you want to view") : Text("")) {
                        
                        VStack {
                            // DatePicker
                            DatePicker("", selection: $selectedDay, in: ...Date(), displayedComponents: .date)
                                .datePickerStyle(.graphical)
                        }
                    }
                }

                .navigationTitle("Choose a \(selectedPeriod == .daily ? "day" : "week")")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // "Save" new date/week
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        isPresented = false
                    } label: {
                        Text("Save")
                            .foregroundColor(.blue)
                    }
                }
                
                // Cancel selection
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        isPresented = false
                    } label: {
                        Text("Cancel")
                            .foregroundColor(.blue)
                    }
                }
            }
            .onDisappear {
                isPresented = false
            }
            .accessibilityAction(named: "Cancel") {
                isPresented = false
            }
            .accessibilityAction(named: "Save") {
                isPresented = false
            }
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(isPresented: .constant(true), selectedDay: .constant(Date()), selectedPeriod: .weekly)
            .environmentObject(DrinkModel())
    }
}
