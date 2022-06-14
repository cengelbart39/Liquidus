//
//  SettingsEditDefaultTypeView.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 10/8/21.
//

import SwiftUI
import WidgetKit

struct SettingsEditDefaultTypeView: View {
    
    @Environment(\.managedObjectContext) var context
    
    @EnvironmentObject var model: DrinkModel
    
    @Environment(\.presentationMode) var presentationMode
    
    var type: DrinkType
    
    @State var enabled = true
    @State var newColor = Color.black
    
    var body: some View {
        
        Form {
            // Enable / Disable
            Section(header: Text("\(type.enabled ? "Disable" : "Enable")")) {
                Toggle("\(enabled ? "Disable" : "Enable") Type", isOn: $enabled)
            }
            
            // If type is enabled...
            if enabled && !model.grayscaleEnabled {
                // Update color
                Section(header: Text("Color")) {
                    // ColorPicker
                    ColorPicker("Choose a new color", selection: $newColor, supportsOpacity: false)
                        .accessibilityElement()
                        .accessibilityLabel("Change color")
                        .accessibilityAddTraits(.isButton)
                }
            }
        }
        .onAppear {
            // On appear update variables based on model
            enabled = type.enabled
            
            if let data = type.color {
                if let uiColor = UIColor.color(data: data) {
                    newColor = Color(uiColor: uiColor)
                }
            }
        }
        .navigationTitle("Edit \(type.name)")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    // Update enabled status
                    type.enabled = self.enabled
                    
                    if let same = self.areColorsSame() {
                        if !same {
                            type.color = UIColor(newColor).encode()
                            type.colorChanged = true
                        }
                    }
                    
                    PersistenceController.shared.saveContext()
                    
                    // Update widget
                    WidgetCenter.shared.reloadAllTimelines()
                    
                    // Dismiss view
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Save")
                }
            }
        }
        .accessibilityAction(named: "Save") {
            // Update enabled status
            // Update enabled status
            type.enabled = self.enabled
            
            if let same = self.areColorsSame() {
                if !same {
                    type.color = UIColor(newColor).encode()
                    type.colorChanged = true
                }
            }
            
            do {
                try context.save()
            } catch {
                fatalError("SettingsEditDefaultTypeView: Unable to save to CoreData")
            }
            
            // Update widget
            WidgetCenter.shared.reloadAllTimelines()
            
            // Dismiss view
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    
    func areColorsSame() -> Bool? {
        if let data = type.color {
            if let uiColor = UIColor.color(data: data) {
                let color = Color(uiColor: uiColor)
                
                return color == newColor
                
            }
        }
        
        return nil
    }
}
