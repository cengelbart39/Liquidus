//
//  IntakeView.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/6/21.
//

import SwiftUI

struct IntakeView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var model: DrinkModel
    
    @State var selectedTimePeriod = Constants.selectDay
    @State var isAddDrinkViewShowing = false
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            HStack {
                
                // MARK: - Title
                Text("Intake")
                    .bold()
                    .font(.largeTitle)
                    .padding(.leading)
                
                Spacer()
                
                // MARK: - Add Drink Button
                Button(action: {
                    isAddDrinkViewShowing = true
                }, label: {
                    
                    Image(systemName: "plus.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .padding(.trailing)
                })
                .sheet(isPresented: $isAddDrinkViewShowing, content: {
                    IntakeLogDrinkView(isPresented: $isAddDrinkViewShowing)
                        .environmentObject(model)
                })
            }
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
                IntakeCircularProgressBar(progressWater: waterPercent, progressCoffee: coffeePercent, progressSoda: sodaPercent, progressJuice: juicePercent, selectedTimePeriod: selectedTimePeriod)
                    .padding(.horizontal)
                    .frame(width: 280, height: 280)
                
                Spacer()
            }
            
            // MARK: - Drink Type Breakup
            MultiDrinkBreakup(selectedTimePeriod: selectedTimePeriod)
            
            Spacer()
            
        }
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            IntakeView()
            IntakeView()
                .preferredColorScheme(.dark)
        }
    }
}