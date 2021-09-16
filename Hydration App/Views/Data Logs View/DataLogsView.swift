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
    
    var body: some View {
        
        let dateFormatter = self.formatter(period: selectedTimePeriod)
        
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
                    .frame(height: 25)
            // If week display week picker
            } else {
                WeekDataPicker(currentWeek: $model.drinkData.selectedWeek)
                    .frame(height: 25)
            }
            
            // MARK: - Stats
            HStack {
                
                Spacer()
                
                VStack {
                    
                    // Display daily/weekly percentage
                    Text("\(selectedTimePeriod == Constants.selectDay ? model.getTotalPercent(date: model.drinkData.selectedDay)*100 : model.getTotalPercent(week: model.drinkData.selectedWeek)*100, specifier: "%.2f")%")
                        .bold()
                        .font(.largeTitle)
                        .padding(.bottom, 6)
                    
                    // Display amount consumed and goal
                    let dailyAmount = model.getTotalAmount(date: model.drinkData.selectedDay)
                    let weeklyAmount = model.getTotalAmount(week: model.drinkData.selectedWeek)
                    
                    
                    Text("\(selectedTimePeriod == Constants.selectDay ? dailyAmount : weeklyAmount, specifier: model.getSpecifier(amount: selectedTimePeriod == Constants.selectDay ? dailyAmount : weeklyAmount)) / \(selectedTimePeriod == Constants.selectDay ? model.drinkData.dailyGoal : model.drinkData.dailyGoal*7, specifier: model.getSpecifier(amount: selectedTimePeriod == Constants.selectDay ? model.drinkData.dailyGoal : model.drinkData.dailyGoal*7)) \(model.getUnits())")
                        .font(.title3)
                    
                    // MARK: Stats by Drink Type
                    MultiDrinkBreakup(selectedTimePeriod: selectedTimePeriod)
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
                                        .frame(width: selectedTimePeriod == Constants.selectDay ? 250 : 300, height: 70)
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
                                        Text("\(drink.amount, specifier: model.getSpecifier(amount: drink.amount)) \(model.getUnits())")
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
    
    func formatter(period: String) -> DateFormatter {
        let dateFormatter = DateFormatter()
        
        if selectedTimePeriod == Constants.selectDay {
            dateFormatter.dateStyle = .none
            dateFormatter.timeStyle = .short
        } else {
            dateFormatter.dateFormat = "MM/dd/yy, h:mm a"
        }
        
        return dateFormatter
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
