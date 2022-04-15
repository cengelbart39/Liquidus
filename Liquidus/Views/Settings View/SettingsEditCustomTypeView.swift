//
//  SettingsEditCustomTypeView.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 10/8/21.
//
//  Keyboard Dismiss Code by pawello2222 on StackOverflow
//  https://stackoverflow.com/a/63942065
//

import SwiftUI
import WidgetKit

struct SettingsEditCustomTypeView: View {
    
    @EnvironmentObject var model: DrinkModel
    @Environment(\.presentationMode) var presentationMode
    
    @GestureState private var dragOffSet = CGSize.zero
    
    var type: DrinkType
    var color: Color
    
    @State var newColor = Color.black
    @State var name = ""
    
    @FocusState private var isFieldFocused: Bool
    
    var body: some View {
        
        Form {
            // Update type name
            Section(header: Text("Name")) {
                TextField(name, text: $name)
                    .multilineTextAlignment(.leading)
                    .accessibilityHint("Edit text to change name")
                    .focused($isFieldFocused)
            }
            
            if !model.grayscaleEnabled {
                // Update color
                Section(header: Text("Color")) {
                    ColorPicker("Choose a new color", selection: $newColor, supportsOpacity: false)
                        .accessibilityElement()
                        .accessibilityLabel("Change color")
                        .accessibilityAddTraits(.isButton)
                }
            }
        }
        .onAppear {
            // Update variables
            name = type.name
            newColor = model.getDrinkTypeColor(type: type)
        }
        .navigationTitle("Edit \"\(type.name)\"")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    // Edit existing drinks of type
                    model.editDrinkType(old: type, new: name)
                    // Tell views to update
                    model.objectWillChange.send()
                    // Update Widget
                    WidgetCenter.shared.reloadAllTimelines()
                    // Dismiss view
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Save")
                }
            }
            
            ToolbarItem(placement: .keyboard) {
                HStack {
                    Spacer()
                    
                    Button {
                        isFieldFocused = false
                    } label: {
                        Text("Done")
                    }
                }
            }
        }
        .accessibilityAction(named: "Save") {
            // Edit existing drinks of type
            model.editDrinkType(old: type, new: name)
            // Tell views to update
            model.objectWillChange.send()
            // Update Widget
            WidgetCenter.shared.reloadAllTimelines()
            // Dismiss view
            presentationMode.wrappedValue.dismiss()
        }
    }
    
}
