//
//  IntakeLogDrinkView.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 9/6/21.
//
//  Keyboard Dismiss Code by pawello2222 on StackOverflow
//  https://stackoverflow.com/a/63942065
//

import SwiftUI
import WidgetKit

struct IntakeLogDrinkView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @Environment(\.managedObjectContext) var context
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "order", ascending: true)]) var drinkTypes: FetchedResults<DrinkType>
    
    @EnvironmentObject var model: DrinkModel
    
    @Binding var isPresented: Bool
    @Binding var trigger: Bool
    
    @State var orderNumber = 0
    @State var amount = ""
    @State var timeSelection = Date()
        
    @FocusState private var isAmountFocused: Bool
    
    @AccessibilityFocusState private var isAmountFocusedAccessibility: Bool
    
    var body: some View {
        
        let allTypes = drinkTypes.sorted { d1, d2 in
            d1.order < d2.order
        }
        
        NavigationView {
            ZStack {
                
                Rectangle()
                    .foregroundColor(Color(.systemGray6))
                    .ignoresSafeArea()
                
                VStack(alignment: .leading) {
                    Form {
                        // Drink Type Picker
                        Section(header: Text("Drink Type")) {
                            Picker(allTypes[orderNumber].name, selection: $orderNumber) {
                                ForEach(drinkTypes, id: \.self) { type in
                                    if type.enabled {
                                        Text(type.name)
                                            .tag(type.order)
                                    }
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
                            if let double = Double(amount) {
                                // Add a drink to the model
                                let drink = Drink(context: context)
                                drink.id = UUID()
                                drink.type = allTypes[orderNumber]
                                drink.amount = double
                                drink.date = timeSelection
                                
                                drink.type.addToDrinks(drink)
                                
                                PersistenceController.shared.saveContext()
                                    
                                model.userInfo.dailyTotalToGoal += double
                                
                                model.saveUserInfo(test: false)
                                
                                WidgetCenter.shared.reloadAllTimelines()
                                
                                trigger.toggle()
                                
                                // Dismiss the sheet
                                isPresented = false
                            }
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
                    if let double = Double(amount) {
                        // Add a drink to the model
                        let drink = Drink(context: context)
                        drink.id = UUID()
                        drink.type = allTypes[orderNumber]
                        drink.amount = double
                        drink.date = timeSelection
                        
                        drink.type.addToDrinks(drink)
                        
                        PersistenceController.shared.saveContext()
                        
                        trigger.toggle()
                        
                        // Dismiss the sheet
                        isPresented = false
                    }
                }
            }
            .accessibilityAction(named: "Cancel") {
                isPresented = false
            }
        }
        .onAppear {
            if let first = drinkTypes.first {
                self.orderNumber = first.order
            }
        }
    }
}
