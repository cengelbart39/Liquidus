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
    @State var isCalendarViewShowing = false
    
    @State var selectedDay = Date()
    @State var selectedWeek = [Date]()
    
    @State var addDrinkButtonID = UUID()
    @State var calendarButtonID = UUID()
    @State var currentDayWeekButtonID = UUID()
    
    var body: some View {
        
        NavigationView {
            VStack(alignment: .leading) {
                
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
            .sheet(isPresented: $isAddDrinkViewShowing, content: {
                LogDrinkView(isPresented: $isAddDrinkViewShowing)
                    .environmentObject(model)
                    .onDisappear {
                        addDrinkButtonID = UUID()
                        calendarButtonID = UUID()
                        currentDayWeekButtonID = UUID()
                    }
            })
            .sheet(isPresented: $isCalendarViewShowing, content: {
                CalendarView(isPresented: $isCalendarViewShowing, selectedDay: $selectedDay, selectedPeriod: selectedTimePeriod)
                    .environmentObject(model)
                    .onDisappear {
                        addDrinkButtonID = UUID()
                        calendarButtonID = UUID()
                        currentDayWeekButtonID = UUID()
                    }
            })
            .navigationTitle("Intake")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        isAddDrinkViewShowing = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .id(self.addDrinkButtonID)
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isCalendarViewShowing = true
                    } label: {
                        Image(systemName: "calendar")
                    }
                    .id(self.calendarButtonID)
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        selectedDay = Date()
                    } label: {
                        Text(selectedTimePeriod == Constants.selectDay ? "Today" : "This Week")
                    }
                    .id(self.currentDayWeekButtonID)
                }
            }
        }
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        IntakeView()
            .environmentObject(DrinkModel())
    }
}
