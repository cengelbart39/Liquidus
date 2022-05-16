//
//  IntakeView.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/6/21.
//

import SwiftUI
import Intents

struct IntakeView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dynamicTypeSize) var dynamicType
    
    @EnvironmentObject var model: DrinkModel
    
    // Track if looking at by day or by week
    @State var selectedTimePeriod = Constants.TimePeriod.daily
    
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
    
    var updateButtons: Bool
    var updateTimePicker: Constants.TimePeriod?
    
    // Focus
    @AccessibilityFocusState private var isTimePeriodFocused: Bool
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                
                // MARK: - Day/Week Picker
                IntakeTimePickerView(picker: $selectedTimePeriod)
                
                ScrollView {
                    // MARK: - Choose Day or Week Data
                    if selectedTimePeriod == .daily {
                        IntakeDayDataPicker(selectedDate: $selectedDay)
                            .multilineTextAlignment(.center)
                            .padding(.bottom)
                            .accessibilityFocused($isTimePeriodFocused)
                    } else {
                        IntakeWeekDataPicker(currentWeek: $selectedWeek)
                            .multilineTextAlignment(.center)
                            .padding(.bottom)
                            .accessibilityFocused($isTimePeriodFocused)
                    }
                    
                    // MARK: - Progress Bar
                    IntakeCircularProgressBar(selectedTimePeriod: selectedTimePeriod, selectedDay: selectedDay, selectedWeek: selectedWeek)
                        .padding(.horizontal, dynamicType.isAccessibilitySize ? 20 : 40)
                        .padding(.vertical)
                    
                    // MARK: - Drink Type Breakup
                    IntakeMultiDrinkBreakup(selectedTimePeriod: selectedTimePeriod, selectedDay: selectedDay, selectedWeek: selectedWeek)
                }
                
                Spacer()
                
            }
            .onAppear {
                // Update selectedWeek as soon as view appears
                selectedWeek = model.getWeek(date: selectedDay)
                addDrinkButtonID = UUID()
                calendarButtonID = UUID()
                currentDayWeekButtonID = UUID()
            }
            .onAppear {
                if model.drinkData.drinks.count > 0 {
                    makeDonation(timePeriod: .daily)
                    makeDonation(timePeriod: .weekly)
                }
            }
            .onChange(of: updateButtons) { _ in
                addDrinkButtonID = UUID()
                calendarButtonID = UUID()
                currentDayWeekButtonID = UUID()
            }
            .onChange(of: updateTimePicker) { newVal in
                if newVal != nil {
                    selectedTimePeriod = newVal!
                }
            }
            .onChange(of: selectedDay) { newValue in
                // Update selectedWeek when selectedDay updates
                selectedWeek = model.getWeek(date: selectedDay)
            }
            .onChange(of: selectedTimePeriod) { _ in
                isTimePeriodFocused = true
            }
            .onChange(of: selectedDay) { _ in
                isTimePeriodFocused = true
            }
            .onChange(of: selectedWeek) { _ in
                isTimePeriodFocused = true
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
                    .accessibilityLabel("Log a Drink")
                }
                
                // Show CalendarView
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isCalendarViewShowing = true
                    } label: {
                        Image(systemName: "calendar")
                    }
                    .id(self.calendarButtonID)
                    .accessibilityLabel("Change selected \(selectedTimePeriod == .daily ? "date" : "week")")
                }
                
                // Show Today / This Week Button
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        selectedDay = Date()
                    } label: {
                        Text(selectedTimePeriod == .daily ? "Today" : "This Week")
                            .accessibilityHint("Show data from \(selectedTimePeriod == .daily ? "today" : "this week")")
                    }
                    .id(self.currentDayWeekButtonID)
                    .accessibilityHint("Show data from today or this week")
                }
            }
            .accessibilityAction(named: "Today / This Week") {
                selectedDay = Date()
                addDrinkButtonID = UUID()
                calendarButtonID = UUID()
                currentDayWeekButtonID = UUID()
            }
            .accessibilityAction(named: "Change Date / Week") {
                isCalendarViewShowing = true
                addDrinkButtonID = UUID()
                calendarButtonID = UUID()
                currentDayWeekButtonID = UUID()
            }
            .accessibilityAction(named: "Log a Drink") {
                isAddDrinkViewShowing = true
                addDrinkButtonID = UUID()
                calendarButtonID = UUID()
                currentDayWeekButtonID = UUID()
            }

        }
        .accessibilityAction(named: "View by Day") {
            selectedTimePeriod = .daily
        }
        .accessibilityAction(named: "View By Week") {
            selectedTimePeriod = .weekly
        }
    }
    
    private func makeDonation(timePeriod: Constants.TimePeriod) {
        let intent = ViewIntakeIntent()
        intent.timePeriod = timePeriod == .daily ? .day : .week
        intent.suggestedInvocationPhrase = "View \(timePeriod == .daily ? "Daily" : "Weekly") Intake"
        
        let interaction = INInteraction(intent: intent, response: nil)
        
        interaction.donate { error in
            if error != nil {
                if let error = error as NSError? {
                    print("Donation failed %@" + error.localizedDescription)
                }
            } else {
                print("Successfully donated interaction")
            }
        }
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        IntakeView(updateButtons: false, updateTimePicker: nil)
            .environmentObject(DrinkModel(test: false, suiteName: nil))
    }
}
