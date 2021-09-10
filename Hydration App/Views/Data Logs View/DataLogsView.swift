//
//  DataLogsView.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/7/21.
//

import SwiftUI

struct DataLogsView: View {
    
    @State var selectedTimePeriod = Constants.selectDay
    
    @EnvironmentObject var model: DrinkModel
    
    @Environment(\.colorScheme) var colorScheme
    
    let dateFormatter: DateFormatter = { () -> DateFormatter in
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter
    }()
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            // MARK: - Title
            Text("Data Logs")
                .bold()
                .font(.largeTitle)
                .padding(.leading)
                .padding(.bottom, 16)
                .padding(.top, 40)
            
            // MARK: - Day/Week Picker
            TimePicker(picker: $selectedTimePeriod)
            
            // MARK: - Day/Week Selector
            // If day display day picker
            if selectedTimePeriod == Constants.selectDay {
                DayDataPicker(currentDate: $model.drinkData.selectedDay)
            // If week display week picker
            } else {
                WeekDataPicker(currentWeek: $model.drinkData.selectedWeek)
            }
            
            // MARK: - Stats
            HStack {
                
                Spacer()
                
                VStack {
                    
                    // Display daily/weekly percentage
                    Text("\(selectedTimePeriod == Constants.selectDay ? model.getTotalPercent(date: model.drinkData.selectedDay) : model.getTotalPercent(week: model.drinkData.selectedWeek)*100, specifier: "%.2f")%")
                        .bold()
                        .font(.largeTitle)
                        .padding(.bottom, 6)
                    
                    // Display amount consumed and goal
                    Text("\(selectedTimePeriod == Constants.selectDay ? model.getTotalAmount(date: model.drinkData.selectedDay) : model.getTotalAmount(week: model.drinkData.selectedWeek), specifier: "%.0f") / \(selectedTimePeriod == Constants.selectDay ? model.drinkData.dailyGoal : model.drinkData.dailyGoal*7, specifier: "%.0f") \(model.drinkData.units)")
                        .font(.title3)
                    
                    // MARK: Stats by Drink Type
                    VStack(alignment: .leading) {
                        
                        HStack {
                            
                            DataLogsDrinkBreakup(color: Constants.colors[Constants.waterKey]!, drinkType: Constants.waterKey, selectedTimePeriod: selectedTimePeriod)
                            
                            Spacer()
                            
                            DataLogsDrinkBreakup(color: Constants.colors[Constants.coffeeKey]!, drinkType: Constants.coffeeKey, selectedTimePeriod: selectedTimePeriod)
                        }
                        
                        HStack {
                            
                            DataLogsDrinkBreakup(color: Constants.colors[Constants.sodaKey]!, drinkType: Constants.sodaKey, selectedTimePeriod: selectedTimePeriod)
                            
                            Spacer()
                            
                            DataLogsDrinkBreakup(color: Constants.colors[Constants.juiceKey]!, drinkType: Constants.juiceKey, selectedTimePeriod: selectedTimePeriod)
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            
            // MARK: - Logs
            
            ScrollView {
                
                HStack {
                    
                    Spacer()
                    
                    // Get the drink data for a day or week
                    let data = selectedTimePeriod == Constants.selectDay ? model.filterDataByDay(day: model.drinkData.selectedDay) : model.filterDataByWeek(week: model.drinkData.selectedWeek)
                    
                    // Check that there is data
                    if data.count > 0 {
                    
                        VStack(alignment: .leading) {
                            ForEach(data) { drink in
                                ZStack {
                                    
                                    // Create card
                                    RectangleCard(color: colorScheme == .light ? .white : Color(.systemGray6))
                                        .frame(width: 250, height: 70)
                                        .shadow(radius: 5)
                                    
                                    HStack {
                                        
                                        Spacer()
                                        
                                        // Colored Drop
                                        Image(systemName: "drop.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 15)
                                            .foregroundColor(Constants.colors[drink.type])
                                            .padding(.trailing)
                                        
                                        // Amount consumed
                                        Text("\(Int(drink.amount.rounded(.up))) \(model.drinkData.units)")
                                            .padding(.trailing, 10)
                                        
                                        // Time drink was logged
                                        Text(dateFormatter.string(from: drink.date))
                                        
                                        Spacer()
                                    }
                                    
                                }
                                .padding(.top, 10)
                            }
                        }
                        
                        
                    } else {
                        Text("No data is logged for this \(selectedTimePeriod == Constants.selectDay ? "day" : "week").")
                            .font(.subheadline)
                            .bold()
                            .padding(.top)
                    }
                    
                    Spacer()
                    
                }
                
            }
        }
    }
}

struct DataLogsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DataLogsView()
            DataLogsView()
                .preferredColorScheme(.dark)
        }
    }
}
