//
//  WeekLogView.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/21/21.
//

import SwiftUI

struct WeekLogView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var model: DrinkModel
    
    var date: Date
    
    var body: some View {
        
        VStack(alignment: .leading) {
        
            // Date
            Text(formatter().string(from: date))
                .textCase(.uppercase)
                .foregroundColor(.gray)
            
            // Get data for date
            let data = model.filterDataByDay(day: date)
            
            // If there is data...
            if data.count > 0 {
                // Show data for each drink
                ForEach(data) { drink in
                    DayLogView(drink: drink)
                    
                }
            // If not...
            } else {
                
                ZStack {
                    
                    RectangleCard(color: colorScheme == .light ? .white : Color(.systemGray6))
                        .frame(height: 70)
                        .shadow(radius: 5)
                    
                    Text("There is no data for this day.")
                }
            }
        }
        .frame(width: 250)
        
    }
    
    // Date Formatter
    func formatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }
}

struct LogView_Previews: PreviewProvider {
    static var previews: some View {
        WeekLogView(date: Date())
            .environmentObject(DrinkModel())
    }
}
