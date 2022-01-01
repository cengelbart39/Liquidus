//
//  IntakeView.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/6/21.
//

import SwiftUI

struct IntakeView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.sizeCategory) var sizeCategory
    
    @EnvironmentObject var model: DrinkModel
    
    // Track if looking at by day or by week
    @State var selectedTimePeriod = Constants.selectDay
    
    // Are the sheet views up
    @State var isAddDrinkViewShowing = false
    @State var isCalendarViewShowing = false
    
    // Current day/week selected
    @State var selectedDay = Date()
    @State var selectedWeek = [Date]()
    
    // Button IDs
    @State var addDrinkButtonID = UUID()
    @State var calendarButtonID = UUID()
    @State var currentDayWeekButtonID = UUID()
    
    var body: some View {
        
        NavigationView {
            VStack(alignment: .leading) {
                
                // MARK: - Day/Week Picker
                TimePicker(picker: $selectedTimePeriod)
                
                ScrollView {
                    // MARK: - Choose Day or Week Data
                    if selectedTimePeriod == Constants.selectDay {
                        DayDataPicker(selectedDate: $selectedDay)
                            .multilineTextAlignment(.center)
                            .padding(.bottom)
                    } else {
                        WeekDataPicker(currentWeek: $selectedWeek)
                            .multilineTextAlignment(.center)
                            .padding(.bottom)
                    }
                    
                    // MARK: - Progress Bar
                    IntakeCircularProgressBar(selectedTimePeriod: selectedTimePeriod, selectedDay: selectedDay, selectedWeek: selectedWeek)
                        .padding(.horizontal, sizeCategory.isAccessibilityCategory ? 20 : 40)
                        .padding(.vertical)
                    
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
                // Show LogDrinkView
                LogDrinkView(isPresented: $isAddDrinkViewShowing)
                    .environmentObject(model)
                    .onDisappear {
                        // Update ids so buttons are responsive
                        addDrinkButtonID = UUID()
                        calendarButtonID = UUID()
                        currentDayWeekButtonID = UUID()
                    }
            })
            .sheet(isPresented: $isCalendarViewShowing, content: {
                // Show CalendarView
                CalendarView(isPresented: $isCalendarViewShowing, selectedDay: $selectedDay, selectedPeriod: selectedTimePeriod)
                    .environmentObject(model)
                    .onDisappear {
                        // Updates ids so buttons are tapable
                        addDrinkButtonID = UUID()
                        calendarButtonID = UUID()
                        currentDayWeekButtonID = UUID()
                    }
            })
            .navigationTitle("Intake")
            .toolbar {
                // Show LogDrinkView
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        isAddDrinkViewShowing = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .id(self.addDrinkButtonID)
                }
                
                // Show CalendarView
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isCalendarViewShowing = true
                    } label: {
                        Image(systemName: "calendar")
                    }
                    .id(self.calendarButtonID)
                }
                
                // Show Today / This Week Button
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
