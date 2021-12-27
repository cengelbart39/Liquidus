//
//  DataLogsView.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/7/21.
//

import SwiftUI

struct DataLogsView: View {
    
    @State var selectedDate = Date()
    @State var selectedWeek = [Date]()
    
    @State var sortingMenu = Constants.allKey
    
    @State var isAddDrinkViewShowing = false
    @State var isCalendarViewShowing = false
    
    @State var addDrinkButtonID = UUID()
    @State var calendarButtonID = UUID()
    @State var currentDayWeekButtonID = UUID()
    @State var sortPickerID = UUID()
    
    @EnvironmentObject var model: DrinkModel
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        NavigationView {
            VStack(alignment: .leading) {
                
                // MARK: - Logs
                
                ScrollView {
                    // Loop through selectedWeek in reverse
                    ForEach(selectedWeek.reversed(), id: \.self) { day in
                        
                        // If the date has happened
                        if !hasHappened(currentDate: day) {
                            HStack {
                                
                                Spacer()
                                
                                WeekLogView(date: day, sortTag: sortingMenu)
                                
                                Spacer()
                            }
                            .padding(.bottom)
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
            .sheet(isPresented: $isAddDrinkViewShowing, content: {
                LogDrinkView(isPresented: $isAddDrinkViewShowing)
                    .environmentObject(model)
                    .onDisappear {
                        addDrinkButtonID = UUID()
                        calendarButtonID = UUID()
                        currentDayWeekButtonID = UUID()
                        sortPickerID = UUID()
                    }
            })
            .sheet(isPresented: $isCalendarViewShowing, content: {
                CalendarView(isPresented: $isCalendarViewShowing, selectedDay: $selectedDate, selectedPeriod: Constants.selectWeek)
                    .environmentObject(model)
                    .onDisappear {
                        addDrinkButtonID = UUID()
                        calendarButtonID = UUID()
                        currentDayWeekButtonID = UUID()
                        sortPickerID = UUID()
                    }
            })
            .navigationTitle("Logs")
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
                        selectedDate = Date()
                    } label: {
                        Text("This Week")
                    }
                    .id(self.currentDayWeekButtonID)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Picker("Sort", selection: $sortingMenu) {
                        Text("All")
                            .tag("All")
                        ForEach(model.drinkData.defaultDrinkTypes, id: \.self) { type in
                            Text(type)
                                .tag(type)
                        }
                        ForEach(model.drinkData.customDrinkTypes, id: \.self) { type in
                            Text(type)
                                .tag(type)
                        }
                    }
                    .id(sortPickerID)
                    .pickerStyle(.menu)
                }
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
        formatter.dateStyle = .long
        formatter.timeStyle = .none
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
