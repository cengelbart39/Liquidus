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
            TimeDataPicker(currentDate: $model.drinkData.selectedDate)
            
            // MARK: - Stats
            HStack {
                
                Spacer()
                
                VStack {
                    
                    Text("\(model.getTotalPercent(date: model.drinkData.selectedDate)*100, specifier: "%.2f")%")
                        .bold()
                        .font(.largeTitle)
                        .padding(.bottom, 6)
                    
                    Text("\(model.getTotalAmount(date: model.drinkData.selectedDate), specifier: "%.0f") / \(model.drinkData.dailyGoal, specifier: "%.0f") \(model.drinkData.units)")
                        .font(.title3)
                    
                    // MARK: Stats by Drink Type
                    VStack(alignment: .leading) {
                        
                        HStack {
                            
                            HStack {
                                
                                RectangleCard(color: Constants.colors[Constants.waterKey]!)
                                    .frame(width: 30, height: 30)
                                
                                VStack(alignment: .leading) {
                                    Text(Constants.waterKey)
                                    Text("\(model.getDrinkTypeAmount(type: Constants.waterKey, date: model.drinkData.selectedDate), specifier: "%.0f") \(model.drinkData.units) / \(model.getDrinkTypePercent(type: Constants.waterKey, date: model.drinkData.selectedDate)*100, specifier: "%.2f")%")
                                }
                                
                            }
                            
                            Spacer()
                            
                            HStack {
                                
                                RectangleCard(color: Constants.colors[Constants.coffeeKey]!)
                                    .frame(width: 30, height: 30)
                                
                                VStack(alignment: .leading) {
                                    Text(Constants.coffeeKey)
                                    Text("\(model.getDrinkTypeAmount(type: Constants.coffeeKey, date: model.drinkData.selectedDate), specifier: "%.0f") \(model.drinkData.units) / \(model.getDrinkTypePercent(type: Constants.coffeeKey, date: model.drinkData.selectedDate)*100, specifier: "%.2f")%")
                                }
                            }
                        }
                        
                        HStack {
                            
                            HStack {
                                
                                RectangleCard(color: Constants.colors[Constants.sodaKey]!)
                                    .frame(width: 30, height: 30)
                                
                                VStack(alignment: .leading) {
                                    Text(Constants.sodaKey)
                                    Text("\(model.getDrinkTypeAmount(type: Constants.sodaKey, date: model.drinkData.selectedDate), specifier: "%.0f") \(model.drinkData.units) / \(model.getDrinkTypePercent(type: Constants.sodaKey, date: model.drinkData.selectedDate)*100, specifier: "%.2f")%")
                                }
                            }
                            
                            Spacer()
                            
                            HStack {
                                
                                RectangleCard(color: Constants.colors[Constants.juiceKey]!)
                                    .frame(width: 30, height: 30)
                                
                                VStack(alignment: .leading) {
                                    Text(Constants.juiceKey)
                                    Text("\(model.getDrinkTypeAmount(type: Constants.juiceKey, date: model.drinkData.selectedDate), specifier: "%.0f") \(model.drinkData.units) / \(model.getDrinkTypePercent(type: Constants.juiceKey, date: model.drinkData.selectedDate)*100, specifier: "%.2f")%")
                                }
                            }
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
                    
                    let data = model.filterDataByDay(day: Date())
                    
                    if data.count > 0 {
                    
                        VStack {
                            ForEach(data) { drink in
                                ZStack {
                                    
                                    RectangleCard(color: colorScheme == .light ? .white : Color(.systemGray6))
                                        .frame(width: 250, height: 70)
                                        .shadow(radius: 5)
                                    
                                    HStack {
                                        
                                        Spacer()
                                        
                                        Image(systemName: "drop.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 15)
                                            .foregroundColor(Constants.colors[drink.type])
                                            .padding(.trailing)
                                        
                                        Text("\(Int(drink.amount.rounded(.up))) \(model.drinkData.units)")
                                            .padding(.trailing, 10)
                                        
                                        Text(dateFormatter.string(from: drink.date))
                                        
                                        Spacer()
                                    }
                                }
                                .padding(.top, 10)
                            }
                        }
                        
                        
                    } else {
                        Text("No data is logged for this day.")
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
