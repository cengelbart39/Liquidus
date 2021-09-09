//
//  TimeDataPicker.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/7/21.
//

import SwiftUI

struct TimeDataPicker: View {
    
    @Binding var currentDate: Date
    
    let dateFormatter: DateFormatter = { () -> DateFormatter in
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .long
        return formatter
    }()
    
    var body: some View {
        
        var isTomorrow = isTomorrow(currentDate: currentDate)
        
        HStack {
            Button(action: {
                let calendar = Calendar.current
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? Date()
                isTomorrow = self.isTomorrow(currentDate: currentDate)
            }, label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(.red)
            })

            Spacer()
            
            Text(dateFormatter.string(from: currentDate))
            
            Spacer()
            
            Button(action: {
                let calendar = Calendar.current
                let nextDay = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? Date()
                if !isTomorrow {
                    currentDate = nextDay
                    isTomorrow = self.isTomorrow(currentDate: currentDate)
                }
            }, label: {
                Image(systemName: "chevron.right")
                    .foregroundColor(isTomorrow ? .gray : .red)
            })
        }
        .padding(.horizontal)
        .padding(.bottom, 6)
    }
    
    func isTomorrow(currentDate: Date) -> Bool {
        let calendar = Calendar.current
        let nextDay = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? Date()
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        
        if dateFormatter.string(from: nextDay) == dateFormatter.string(from: tomorrow) {
            return true
        } else {
            return false
        }
    }
}
