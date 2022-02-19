//
//  LogDrinkView.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/6/21.
//
//  Keyboard Dismiss Code by pawello2222 on StackOverflow
//  https://stackoverflow.com/a/63942065
//

import SwiftUI

struct LogDrinkView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var model: DrinkModel
    
    @Binding var isPresented: Bool
    
    @State var drinkType = Constants.waterKey
    @State var amount = ""
    @State var timeSelection = Date()
        
    @FocusState private var isAmountFocused: Bool
    
    @AccessibilityFocusState private var isAmountFocusedAccessibility: Bool
    
    var body: some View {
        
        NavigationView {
            ZStack {
                
                Rectangle()
                    .foregroundColor(Color(.systemGray6))
                    .ignoresSafeArea()
                
                VStack(alignment: .leading) {
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
                            .accessibilityLabel("Choose Drink Type")
                        }
                        
                        // Drink Amount
                        Section(header: Text("Drink Amount")) {
                            HStack {
                                TextField("500", text: $amount)
                                    .keyboardType(.decimalPad)
                                    .focused($isAmountFocused)
                                
                                Spacer()
                                
                                Text(model.getUnits())
                            }
                            .accessibilityElement(children: .combine)
                            .accessibilityValue("\(amount) \(model.getAccessibilityUnitLabel())")
                            .accessibilityFocused($isAmountFocusedAccessibility)
                        }
                        
                        // Date Picker
                        Section(header: Text("Date")) {
                            VStack {
                                DatePicker("Date", selection: $timeSelection, in: ...Date())
                                    .datePickerStyle(.graphical)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Log a Drink")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Add drink, when there is an amount
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        if amount.isEmpty {
                            isAmountFocusedAccessibility = true
                        } else {
                            // Add a drink to the model
                            let drink = Drink(type: drinkType, amount: Double(amount)!, date: timeSelection)
                            model.addDrink(drink: drink)
                            
                            // Dismiss the sheet
                            isPresented = false
                        }
                    } label: {
                        Text("Add")
                            .foregroundColor(amount.isEmpty ? .gray : .blue)
                    }
                }
                
                // Cancel and dismiss sheet
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        isPresented = false
                    } label: {
                        Text("Cancel")
                            .foregroundColor(.blue)
                    }
                }
                
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Spacer()
                        
                        Button {
                            isAmountFocused = false
                        } label: {
                            Text("Done")
                        }
                    }
                }
            }
            .accessibilityAction(named: "Add") {
                if amount != "" {
                    // Add a drink to the model
                    let drink = Drink(type: drinkType, amount: Double(amount)!, date: timeSelection)
                    model.addDrink(drink: drink)
                    
                    // Dismiss the sheet
                    isPresented = false
                }
            }
            .accessibilityAction(named: "Cancel") {
                isPresented = false
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
