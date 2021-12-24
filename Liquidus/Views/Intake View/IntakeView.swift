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
    
    @State var selectedDay = Date()
    @State var selectedWeek = [Date]()
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            HStack {
                
                // MARK: - Title
                Text("Intake")
                    .bold()
                    .font(.largeTitle)
                    .padding(.leading)
                
                Spacer()
                
                // MARK: - Select Day/Week
                ZStack {
                    // DatePicker
                    ButtonDatePicker(selectedDate: $selectedDay)
                    
                    // Image
                    Image(systemName: "calendar.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .foregroundColor(.blue)
                        .userInteractionDisabled()
                }
                .frame(width: 18, height: 18)
                .onChange(of: selectedDay, perform: { value in
                    // Update selectedWeek when selectedDate updates
                    selectedWeek = model.getDaysInWeek(date: selectedDay)
                })
                .padding(.trailing, 10)

                
                // MARK: - Add Drink Button
                Button(action: {
                    // Update isAddDrinkViewShowing
                    isAddDrinkViewShowing = true
                }, label: {
                    // Image
                    Image(systemName: "plus.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .padding(.trailing)
                })
                // Show sheet to add drink
                .sheet(isPresented: $isAddDrinkViewShowing, content: {
                    LogDrinkView(isPresented: $isAddDrinkViewShowing)
                        .environmentObject(model)
                })
            }
            .padding(.top, 40)
            
            // MARK: - Day/Week Picker
            TimePicker(picker: $selectedTimePeriod)
            
            // MARK: - Choose Day or Week Data
            if selectedTimePeriod == Constants.selectDay {
                DayDataPicker(selectedDate: $selectedDay)
                    .frame(height: 25)
            } else {
                WeekDataPicker(currentWeek: $selectedWeek)
                    .frame(height: 25)
            }
            
            ScrollView {
            // MARK: - Progress Bar
                HStack {
                    
                    Spacer()
                    
                    // Create Progress Circle
                    IntakeCircularProgressBar(selectedTimePeriod: selectedTimePeriod, selectedDay: selectedDay, selectedWeek: selectedWeek)
                        .padding(.horizontal)
                        .frame(width: 270, height: 270)
                    
                    Spacer()
                }
                
                // MARK: - Drink Type Breakup
                IntakeMultiDrinkBreakup(selectedTimePeriod: selectedTimePeriod, selectedDay: selectedDay, selectedWeek: selectedWeek)
            }
            
            Spacer()
            
        }
        .onAppear {
            // Update selectedWeek as soon as view appears
            selectedWeek = model.getDaysInWeek(date: selectedDay)
        }
        .onChange(of: selectedDay) { newValue in
            // Update selectedWeek when selectedDay updates
            selectedWeek = model.getDaysInWeek(date: selectedDay)
        }
        .navigationTitle("Intake")
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        IntakeView()
            .environmentObject(DrinkModel())
    }
}
