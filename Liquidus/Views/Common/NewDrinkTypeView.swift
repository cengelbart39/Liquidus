//
//  NewDrinkTypeView.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 10/5/21.
//
//  Keyboard Dismiss Code by pawello2222 on StackOverflow
//  https://stackoverflow.com/a/63942065
//

import SwiftUI

struct NewDrinkTypeView: View {
    
    @Environment(\.managedObjectContext) var context
    @FetchRequest(sortDescriptors: []) var drinkTypes: FetchedResults<DrinkType>
    
    @EnvironmentObject var model: DrinkModel
    
    @Binding var isPresented: Bool
    
    @State var name = ""
    @State var color = Color(red: 0, green: 0, blue: 0)
    
    @FocusState private var isNameFocused: Bool
    
    @AccessibilityFocusState private var isNameFocusedAccessibility: Bool
    
    var body: some View {
        
        NavigationView {
            VStack(alignment: .leading) {
                
                ZStack {
                    
                    Rectangle()
                        .foregroundColor(Color(.systemGray6))
                        .ignoresSafeArea()
                    
                    Form {
                        // Change drink type name
                        Section(header: Text("Name"), footer: model.grayscaleEnabled ? Text("In the event Grayscale Color Filters are disabled, created drink types are assigned a random color.") : nil) {
                            TextField("Water", text: $name)
                                .accessibilityHint("Edit text to choose name")
                                .accessibilityFocused($isNameFocusedAccessibility)
                                .focused($isNameFocused)
                        }
                        
                        if !model.grayscaleEnabled {
                            // Change drink type color
                            Section(header: Text("Color"), footer: Text("White and black may not show up well in Light or Dark Mode")) {
                                ColorPicker("Choose a color", selection: $color, supportsOpacity: false)
                                    .accessibilityElement()
                                    .accessibilityLabel("Choose a color")
                                    .accessibilityAddTraits(.isButton)
                            }
                        }
                    }
                    .multilineTextAlignment(.leading)
                }
            }
            .navigationTitle("New Drink Type")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Save new Drink Type
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        if name.isEmpty {
                            isNameFocusedAccessibility = true
                            
                        } else {
                            
                            var newColor = color
                            
                            if model.grayscaleEnabled {
                                let red = Double.random(in: 0...255)/255
                                let green = Double.random(in: 0...255)/255
                                let blue = Double.random(in: 0...255)/255
                                
                                color = Color(red: red, green: green, blue: blue)
                                
                            }

                            let drinkType = DrinkType(context: context)
                            drinkType.id = UUID()
                            drinkType.order = drinkTypes.count
                            drinkType.name = model.processDrinkTypeName(name: name)
                            drinkType.isDefault = false
                            drinkType.enabled = true
                            drinkType.colorChanged = true
                            drinkType.color = UIColor(newColor).encode()
                            drinkType.drinks = nil
                                                          
                            PersistenceController.shared.saveContext()
                            
                            isPresented = false
                        }
                    } label: {
                        Text("Save")
                            .foregroundColor(name.isEmpty ? .gray : Color(.systemBlue))
                    }
                }
                
                // Dismiss sheet
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        isPresented = false
                    } label: {
                        Text("Cancel")
                    }
                }
                
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Spacer()
                        
                        Button {
                            isNameFocused = false
                        } label: {
                            Text("Done")
                        }
                    }
                }

            }
        }
    }
}

struct SettingsNewDrinkTypeView_Previews: PreviewProvider {
    static var previews: some View {
        NewDrinkTypeView(isPresented: .constant(true))
    }
}
