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
    @Binding var selectedDay: Day
    @Binding var trigger: Bool
    
    @State var chosenDate = Date()
    
    var body: some View {
        NavigationView {
                Form {
                    VStack {
                        // DatePicker
                        DatePicker("", selection: $chosenDate, in: ...Date(), displayedComponents: .date)
                            .datePickerStyle(.graphical)
                    }
                }

                .navigationTitle("Choose a day")
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
                .onAppear {
                    chosenDate = selectedDay.data
                }
                .onChange(of: chosenDate, perform: { newDate in
                    selectedDay.update(date: newDate)
                    trigger.toggle()
                })
                .onDisappear {
                    isPresented = false
                }
                .accessibilityAction(named: "Cancel") {
                    isPresented = false
                }
                .accessibilityAction(named: "Save") {
                    isPresented = false
                    trigger.toggle()
                }
        }
    }
}
