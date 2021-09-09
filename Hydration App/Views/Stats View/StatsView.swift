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
                
                //let waterPercent = selectedTimePeriod == Constants.selectDay ? model.getDrinkTypePercent(type: Constants.waterKey, date: model.drinkData.selectedDay) : model.getDrinkTypePercent(type: Constants.waterKey, week: <#T##[Date]#>)
                
                CircularProgressBar(progressWater: model.getDrinkTypePercent(type: Constants.waterKey, date: model.drinkData.selectedDay), progressCoffee: model.getDrinkTypePercent(type: Constants.coffeeKey, date: model.drinkData.selectedDay), progressSoda: model.getDrinkTypePercent(type: Constants.sodaKey, date: model.drinkData.selectedDay), progressJuice: model.getDrinkTypePercent(type: Constants.juiceKey, date: model.drinkData.selectedDay), date: model.drinkData.selectedDay)
                    .padding(.horizontal)
                    .frame(width: 280, height: 280)
                
                Spacer()
            }
            
            // MARK: - Drink Type Breakup
            HStack {
                DrinkBreakup(color: Constants.colors[Constants.waterKey]!, drinkName: Constants.waterKey, drinkAmount: model.getDrinkTypeAmount(type: Constants.waterKey, date: model.drinkData.selectedDay))
                
                Spacer()
                
                DrinkBreakup(color: Constants.colors[Constants.coffeeKey]!, drinkName: Constants.coffeeKey, drinkAmount: model.getDrinkTypeAmount(type: Constants.coffeeKey, date: model.drinkData.selectedDay))
                
                Spacer()
                
                DrinkBreakup(color: Constants.colors[Constants.sodaKey]!, drinkName: Constants.sodaKey, drinkAmount: model.getDrinkTypeAmount(type: Constants.sodaKey, date: model.drinkData.selectedDay))
                
                Spacer()
                
                DrinkBreakup(color: Constants.colors[Constants.juiceKey]!, drinkName: Constants.juiceKey, drinkAmount: model.getDrinkTypeAmount(type: Constants.juiceKey, date: model.drinkData.selectedDay))
            }
            .shadow(radius: 5)
            .frame(height: 94)
            .padding(.horizontal)
            .padding(.bottom, 10)
            
            // MARK: - Goal Information
            HStack {
                
                GoalInformation(headline: "Daily Goal", amount: model.drinkData.dailyGoal)
                
                Spacer()
                
                GoalInformation(headline: "Amount Left", amount: (model.drinkData.dailyGoal - model.getTotalAmount(date: model.drinkData.selectedDay)))
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
                LogDrinkView(isPresented: $isAddDrinkViewShowing)
            })
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            
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
