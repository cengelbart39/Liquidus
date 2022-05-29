//
//  IntakeView.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 9/6/21.
//

import SwiftUI
import Intents

struct IntakeView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dynamicTypeSize) var dynamicType
    
    @EnvironmentObject var model: DrinkModel
    
    // Are the sheet views up
    @State var isAddDrinkViewShowing = false
    @State var isCalendarViewShowing = false
    
    // Current day selected
    @State var selectedDay = Day()
        
    @State var hiddenTrigger = false
    
    // Button IDs
    @State var addDrinkButtonID = UUID()
    @State var calendarButtonID = UUID()
    @State var currentDayWeekButtonID = UUID()
    
    var updateButtons: Bool
    
    // Focus
    @AccessibilityFocusState private var isTimePeriodFocused: Bool
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {

                ScrollView {
                    // MARK: - Choose Day or Week Data
                    IntakeDataPicker(day: $selectedDay, trigger: $hiddenTrigger)
                        .multilineTextAlignment(.center)
                        .padding(.top, 5)
                        .padding(.bottom)
                        .accessibilityFocused($isTimePeriodFocused)
                    
                    // MARK: - Progress Bar
                    IntakeCircularProgressBar(day: selectedDay, trigger: $hiddenTrigger)
                        .padding(.horizontal, dynamicType.isAccessibilitySize ? 20 : 40)
                        .padding(.vertical)
                    
                    // MARK: - Drink Type Breakup
                    IntakeMultiDrinkBreakup(day: selectedDay, trigger: $hiddenTrigger)
                }
                
                Spacer()
                
            }
            .onAppear {
                // Update selectedWeek as soon as view appears
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
            .onChange(of: selectedDay) { newValue in
                hiddenTrigger.toggle()
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
                CalendarView(isPresented: $isCalendarViewShowing, selectedDay: $selectedDay,trigger: $hiddenTrigger)
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
                    .accessibilityLabel("Change selected date")
                }
                
                // Show Today / This Week Button
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        selectedDay = Day()
                        hiddenTrigger.toggle()
                    } label: {
                        Text("Today")
                            .accessibilityHint("Show data for today")
                    }
                    .id(self.currentDayWeekButtonID)
                    .accessibilityHint("Show data from today")
                }
            }
            .accessibilityAction(named: "Today") {
                selectedDay = Day()
                hiddenTrigger.toggle()
                addDrinkButtonID = UUID()
                calendarButtonID = UUID()
                currentDayWeekButtonID = UUID()
            }
            .accessibilityAction(named: "Change Date") {
                isCalendarViewShowing = true
                hiddenTrigger.toggle()
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
    }
    
    /**
     Donates a Shortcut to the Shortcuts App
     - Parameter timePeriod: The current TimePeriod; Determines intent configuration
     */
    private func makeDonation(timePeriod: TimePeriod) {
        let intent = ViewIntakeIntent()
        intent.suggestedInvocationPhrase = "View Daily Intake"
        
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
        IntakeView(updateButtons: false)
            .environmentObject(DrinkModel(test: false, suiteName: nil))
    }
}
