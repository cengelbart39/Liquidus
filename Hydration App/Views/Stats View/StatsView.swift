//
//  StatsView.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/6/21.
//

import SwiftUI

struct StatsView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var model: DrinkModel
    
    @State var selectedTimePeriod = Constants.selectDay
    @State var isAddDrinkViewShowing = false
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            // MARK: - Title
            Text("Stats")
                .bold()
                .font(.largeTitle)
                .padding(.leading)
                .padding(.bottom, 16)
                .padding(.top, 40)
            
            // MARK: - Day/Week Picker
            TimePicker(picker: $selectedTimePeriod)
            
            // MARK: - Choose Day or Week Data
            if selectedTimePeriod == Constants.selectDay {
                DayDataPicker(currentDate: $model.drinkData.selectedDay)
                    .frame(height: 25)
            } else {
                WeekDataPicker(currentWeek: $model.drinkData.selectedWeek)
                    .frame(height: 25)
            }
            
            // MARK: - Progress Bar
            HStack {
                
                Spacer()
                
                // Get decimal percentages for each drink type
                let waterPercent = selectedTimePeriod == Constants.selectDay ? model.getDrinkTypePercent(type: Constants.waterKey, date: model.drinkData.selectedDay) : model.getDrinkTypePercent(type: Constants.waterKey, week: model.drinkData.selectedWeek)
                
                let coffeePercent = selectedTimePeriod == Constants.selectDay ? model.getDrinkTypePercent(type: Constants.coffeeKey, date: model.drinkData.selectedDay) : model.getDrinkTypePercent(type: Constants.coffeeKey, week: model.drinkData.selectedWeek)
                
                let sodaPercent = selectedTimePeriod == Constants.selectDay ? model.getDrinkTypePercent(type: Constants.sodaKey, date: model.drinkData.selectedDay) : model.getDrinkTypePercent(type: Constants.sodaKey, week: model.drinkData.selectedWeek)
                
                let juicePercent = selectedTimePeriod == Constants.selectDay ? model.getDrinkTypePercent(type: Constants.juiceKey, date: model.drinkData.selectedDay) : model.getDrinkTypePercent(type: Constants.juiceKey, week: model.drinkData.selectedWeek)
                
                // Create Progress Circle
                StatsCircularProgressBar(progressWater: waterPercent, progressCoffee: coffeePercent, progressSoda: sodaPercent, progressJuice: juicePercent, selectedTimePeriod: selectedTimePeriod)
                    .padding(.horizontal)
                    .frame(width: 280, height: 280)
                
                Spacer()
            }
            
            // MARK: - Drink Type Breakup
            MultiDrinkBreakup(selectedTimePeriod: selectedTimePeriod)
            
            // MARK: - Add Drink Button
            
            Button(action: {
                isAddDrinkViewShowing = true
            }, label: {
                
                HStack {
                    
                    Spacer()
                    
                    ZStack {
                        
                        RectangleCard(color: colorScheme == .light ? .white : Color(.systemGray6))
                            .frame(width: 150, height: 50)
                            .shadow(radius: 5)
                        
                        Text("Log A Drink")
                            .font(.title2)
                        
                    }
                    
                    Spacer()
                }
                
            })
            .sheet(isPresented: $isAddDrinkViewShowing, content: {
                StatsLogDrinkView(isPresented: $isAddDrinkViewShowing)
                    .environmentObject(model)
            })
            
            Spacer()
            
        }
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StatsView()
            StatsView()
                .preferredColorScheme(.dark)
        }
    }
}
