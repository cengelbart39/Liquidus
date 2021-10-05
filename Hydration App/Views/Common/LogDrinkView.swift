//
//  LogDrinkView.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/6/21.
//

import SwiftUI

struct LogDrinkView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var model: DrinkModel
    
    @Binding var isPresented: Bool
    
    @State var drinkType = Constants.waterKey
    @State var amount = ""
    @State var timeSelection = Date()
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            // Title
            Text("Log A Drink")
                .font(.largeTitle)
                .bold()
                .padding(.bottom)
                .padding(.top, 50)
            
            // Drink Type Picker
            HStack {
                
                Picker("Drink Type:", selection: $drinkType) {
                    ForEach(model.drinkData.drinkTypes, id: \.self) { type in
                        Text(type)
                            .tag(type)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                
                Text(drinkType)
            }
            .padding(.bottom)
            
            // Drink Amount TextField
            HStack {
                
                Text("Drink Amount:")
                    .bold()
                
                TextField("500", text: $amount)
                    .keyboardType(.decimalPad)
                    .frame(width: 60)
                
                Text(model.getUnits())
                
            }
            .padding(.bottom)
            
            // Date Picker
            DatePicker("", selection: $timeSelection, in: ...Date())
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding(.bottom)

            
            HStack {
                
                Spacer()
                
                Button(action: {
                    // Add a drink to the model
                    let drink = Drink(type: drinkType, amount: Double(amount)!, date: timeSelection)
                    model.addDrink(drink: drink)
                    
                    // Dismiss the sheet
                    isPresented = false
                }, label: {
                    ZStack {
                        RectangleCard(color: colorScheme == .light ? .white : Color(.systemGray5))
                            .frame(width: 90, height: 55)
                            .shadow(radius: colorScheme == .light ? 5 : 0)
                        
                        Text("Save")
                            .foregroundColor(.blue)
                            .font(.title2)
                    }
                })
                
                Spacer()
                
            }
            
            Spacer()
            
        }
        .padding(.horizontal)
    }
}
