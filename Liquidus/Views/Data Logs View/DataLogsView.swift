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
    @State var isAddDrinkViewShowing = false
    
    @EnvironmentObject var model: DrinkModel
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            HStack {
                
                // MARK: - Title
                Text("Logs")
                    .bold()
                    .font(.largeTitle)
                    .padding(.leading)
                
                Spacer()
                
                // MARK: - Select Week
                ZStack {
                    // DatePicker
                    ButtonDatePicker(selectedDate: $selectedDate)
                    
                    // Image
                    Image(systemName: "calendar.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .foregroundColor(.blue)
                        .userInteractionDisabled()
                }
                .frame(width: 18, height: 18)
                .onChange(of: selectedDate, perform: { value in
                    // Update selectedWeek when selectedDate updates
                    selectedWeek = model.getDaysInWeek(date: selectedDate)
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
            .padding(.bottom, 16)
            .padding(.top, 40)
            
            // MARK: - Logs
            
            ScrollView {
                // Loop through selectedWeek in reverse
                ForEach(selectedWeek.reversed(), id: \.self) { day in
                    
                    // If the date has happened
                    if !hasHappened(currentDate: day) {
                        HStack {
                            
                            Spacer()
                            
                            WeekLogView(date: day)
                            
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
