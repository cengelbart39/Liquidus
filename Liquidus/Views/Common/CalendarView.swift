//
//  CalendarView.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 12/26/21.
//

import SwiftUI

struct CalendarView: View {
    
    @Binding var isPresented: Bool
    
    @Binding var selectedDay: Date
    var selectedPeriod: String
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                Form {
                    Section(footer: selectedPeriod == Constants.selectWeek ? Text("Choose a date within the week you want to view") : Text("")) {
                        DatePicker("Choose a new \(selectedPeriod == Constants.selectDay ? "day" : "week")", selection: $selectedDay, in: ...Date(), displayedComponents: .date)
                    }
                }
            }
            .navigationTitle("Choose a \(selectedPeriod == Constants.selectDay ? "day" : "week")")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        isPresented = false
                    } label: {
                        Text("Save")
                    }
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        isPresented = false
                    } label: {
                        Text("Cancel")
                    }
                }
            }
            .onDisappear {
                isPresented = false
            }
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(isPresented: .constant(true), selectedDay: .constant(Date()), selectedPeriod: Constants.selectWeek)
    }
}
