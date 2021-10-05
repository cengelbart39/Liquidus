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
                    LogDrinkView(isPresented: $isAddDrinkViewShowing)
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
                
                // Create Progress Circle
                IntakeCircularProgressBar(selectedTimePeriod: selectedTimePeriod)
                    .padding(.horizontal)
                    .frame(width: 280, height: 280)
                
                Spacer()
            }
            
            // MARK: - Drink Type Breakup
            IntakeMultiDrinkBreakup(selectedTimePeriod: selectedTimePeriod)
            
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
