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
            Text("Hydration")
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
            } else {
                WeekDataPicker(currentWeek: $model.drinkData.selectedWeek)
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
            HStack {
                // Water
                StatsDrinkBreakup(color: Constants.colors[Constants.waterKey]!, drinkName: Constants.waterKey, selectedTimePeriod: selectedTimePeriod)
                
                Spacer()
                
                // Coffee
                StatsDrinkBreakup(color: Constants.colors[Constants.coffeeKey]!, drinkName: Constants.coffeeKey, selectedTimePeriod: selectedTimePeriod)
                
                Spacer()
                
                // Soda
                StatsDrinkBreakup(color: Constants.colors[Constants.sodaKey]!, drinkName: Constants.sodaKey, selectedTimePeriod: selectedTimePeriod)
                
                Spacer()
                
                // Juice
                StatsDrinkBreakup(color: Constants.colors[Constants.juiceKey]!, drinkName: Constants.juiceKey, selectedTimePeriod: selectedTimePeriod)
            }
            .shadow(radius: 5)
            .frame(height: 94)
            .padding(.horizontal)
            .padding(.bottom, 10)
            
            // MARK: - Goal Information
            HStack {
                
                // Display the Daily or Weekly Goal
                StatsGoalInformation(headline: "\(selectedTimePeriod == Constants.selectDay ? "Daily" : "Weekly") Goal", amount: selectedTimePeriod == Constants.selectDay ? model.drinkData.dailyGoal : model.drinkData.dailyGoal*7)
                
                Spacer()
                
                // Display the remaining amount until the goal is met
                StatsGoalInformation(headline: "Amount Left", amount: selectedTimePeriod == Constants.selectDay ? (model.drinkData.dailyGoal - model.getTotalAmount(date: model.drinkData.selectedDay)) : (model.drinkData.dailyGoal*7 - model.getTotalAmount(week: model.drinkData.selectedWeek)))
            }
            .padding(.horizontal)
            .padding(.bottom)
            
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
