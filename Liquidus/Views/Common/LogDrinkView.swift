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
        
        ZStack {
            
            Rectangle()
                .foregroundColor(Color(.systemGray6))
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                
                // Title
                Text("Log A Drink")
                    .font(.largeTitle)
                    .bold()
                    .padding(.horizontal)
                    .padding(.top, 40)
                    .padding(.bottom, -10)
                
                
                let drinkTypes = model.drinkData.defaultDrinkTypes + model.drinkData.customDrinkTypes
                
                Form {
                    // Drink Type Picker
                    Section(header: Text("Drink Type")) {
                        Picker(drinkType, selection: $drinkType) {
                            ForEach(drinkTypes, id: \.self) { type in
                                Text(type)
                                    .tag(type)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    
                    // Drink Amount
                    Section(header: Text("Drink Amount")) {
                        HStack {
                            TextField("500", text: $amount)
                                .keyboardType(.decimalPad)
                            
                            Spacer()
                            
                            Text(model.getUnits())
                        }
                    }
                    
                    // Date Picker
                    Section(header: Text("Date")) {
                        DatePicker("Date", selection: $timeSelection, in: ...Date())
                    }
                    
                    Section {
                        HStack {
                            Spacer ()
                            
                            Button(action: {
                                // Add a drink to the model
                                let drink = Drink(type: drinkType, amount: Double(amount)!, date: timeSelection)
                                model.addDrink(drink: drink)
                                
                                // Dismiss the sheet
                                isPresented = false
                            }, label: {
                                Text("Save")
                                    .foregroundColor(.blue)
                            })
                            
                            Spacer()
                        }
                    }
                }
            }
        }
    }
}

struct LogDrinkView_Previews: PreviewProvider {
    static var previews: some View {
        LogDrinkView(isPresented: .constant(true))
            .environmentObject(DrinkModel())
    }
}
