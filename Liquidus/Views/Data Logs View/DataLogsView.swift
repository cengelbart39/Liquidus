//
//  DataLogsView.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/7/21.
//

import SwiftUI

struct DataLogsView: View {
    
    @State var selectedDate = Date()
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
                    ButtonDatePicker(selectedDate: $selectedDate)
                    
                    Image(systemName: "calendar.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .foregroundColor(.blue)
                        .userInteractionDisabled()
                }
                .frame(width: 18, height: 18)
                .onChange(of: selectedDate, perform: { value in
                    model.selectedWeek = model.getDaysInWeek(date: selectedDate)
                })
                .padding(.trailing, 10)

                
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
            
            // MARK: - Logs
            
            ScrollView {
                
                ForEach(model.selectedWeek.reversed(), id: \.self) { day in
                    
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
    }
    
    func hasHappened(currentDate: Date) -> Bool {
        if self.formatter().string(from: currentDate) == self.formatter().string(from: Date()) || currentDate < Date() {
            return false
        } else {
            return true
        }
    }

    
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
