//
//  DataLogsView.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/7/21.
//

import SwiftUI

struct DataLogsView: View {
    
    // Current day/week selected
    @State var selectedDate = Date()
    @State var selectedWeek = [Date]()
    
    // Sorting option selected
    @State var sortingMenu = Constants.allKey
    
    // Are sheet views open?
    @State var isAddDrinkViewShowing = false
    @State var isCalendarViewShowing = false
    
    // Toolbar Items IDs
    @State var addDrinkButtonID = UUID()
    @State var calendarButtonID = UUID()
    @State var currentWeekButtonID = UUID()
    @State var sortPickerID = UUID()
    
    @EnvironmentObject var model: DrinkModel
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dynamicTypeSize) var dynamicType
    
    var body: some View {
        
        NavigationView {
            Form {
                
                // MARK: - Logs
                // Loop through selectedWeek in reverse
                
                let formatter = formatter()
                
                ForEach(selectedWeek.reversed(), id: \.self) { day in
                    
                    if !hasHappened(currentDate: day) {
                        Section(header: Text(formatter.string(from: day))) {
                            WeekLogView(date: day, sortTag: sortingMenu)
                        }
                    }
                }
            }
            // Update selectedWeek based on selectedDate
            .onAppear {
                selectedWeek = model.getDaysInWeek(date: selectedDate)
            }
            .onChange(of: selectedDate, perform: { value in
                // Update selectedWeek when selectedDate updates
                selectedWeek = model.getDaysInWeek(date: selectedDate)
            })
            // LogDrinkView Sheet
            .sheet(isPresented: $isAddDrinkViewShowing, content: {
                LogDrinkView(isPresented: $isAddDrinkViewShowing)
                    .environmentObject(model)
                    .onDisappear {
                        // Update ids show items are tapable
                        addDrinkButtonID = UUID()
                        calendarButtonID = UUID()
                        currentWeekButtonID = UUID()
                        sortPickerID = UUID()
                    }
            })
            // CalendarView Sheet
            .sheet(isPresented: $isCalendarViewShowing, content: {
                CalendarView(isPresented: $isCalendarViewShowing, selectedDay: $selectedDate, selectedPeriod: Constants.selectWeek)
                    .environmentObject(model)
                    .onDisappear {
                        // Update ids show items are tapable
                        addDrinkButtonID = UUID()
                        calendarButtonID = UUID()
                        currentWeekButtonID = UUID()
                        sortPickerID = UUID()
                    }
            })
            .navigationTitle("Logs")
            .toolbar {
                // Show Sorting Menu
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Picker(selection: $sortingMenu, label: Text("Sort")) {
                            Text("All")
                                .tag("All")
                            ForEach(model.drinkData.defaultDrinkTypes, id: \.self) { type in
                                if model.drinkData.enabled[type]! {
                                    Text(type)
                                        .tag(type)
                                }
                            }
                            ForEach(model.drinkData.customDrinkTypes, id: \.self) { type in
                                Text(type)
                                    .tag(type)
                            }
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                    .id(sortPickerID)
                    .accessibilityLabel("Filter Data")
                }
                
                // Show CalendarView
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isCalendarViewShowing = true
                    } label: {
                        Image(systemName: "calendar")
                    }
                    .id(self.calendarButtonID)
                    .accessibilityLabel("Change selected week")
                }
                
                // Show LogDrinkView
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isAddDrinkViewShowing = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .id(self.addDrinkButtonID)
                    .accessibilityLabel("Log a Drink")
                }
                
                // Show the current week
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        selectedDate = Date()
                    } label: {
                        Text("This Week")
                    }
                    .id(self.currentWeekButtonID)
                    .accessibilityHint("Show data from the current week")
                }
            }
            .accessibilityAction(named: "This Week") {
                selectedDate = Date()
                addDrinkButtonID = UUID()
                calendarButtonID = UUID()
                sortPickerID = UUID()
                currentWeekButtonID = UUID()
            }
            .accessibilityAction(named: "Change Week") {
                isCalendarViewShowing = true
                addDrinkButtonID = UUID()
                calendarButtonID = UUID()
                sortPickerID = UUID()
                currentWeekButtonID = UUID()
            }
            .accessibilityAction(named: "Log a Drink") {
                isAddDrinkViewShowing = true
                addDrinkButtonID = UUID()
                calendarButtonID = UUID()
                sortPickerID = UUID()
                currentWeekButtonID = UUID()
            }
        }
    }
    
    func hasHappened(currentDate: Date) -> Bool {
        // If the currentDate and today are the same...
        if self.formatter().string(from: currentDate) == self.formatter().string(from: Date()) || currentDate < Date() {
            return false
        } else {
            return true
        }
    }
    
    // Create DateFormatter
    func formatter() -> DateFormatter {
        let formatter = DateFormatter()
        
        if dynamicType == .accessibility3 || dynamicType == .accessibility4 || dynamicType == .accessibility5 {
            formatter.dateFormat = "MMM. d, yyyy"
        } else {
            formatter.dateFormat = "MMMM d, yyyy"
        }
        
        return formatter
    }
}

struct DataLogsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DataLogsView()
                .environmentObject(DrinkModel())
        }
    }
}
