//
//  SettingsDrinkTypeView.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 10/3/21.
//

import SwiftUI

struct SettingsDrinkTypeView: View {
    
    @EnvironmentObject var model: DrinkModel
    
    @State var waterToggle = true
    
    var body: some View {
        Form {
            Section(header: Text("Default")) {
                ForEach(model.drinkData.drinkTypes, id: \.self) { type in
                    SettingsDrinkColorPicker(drinkType: type)
                }
            }
            
            Section(header: Text("Custom")) {
                
            }
        }
        .navigationBarTitle("Drink Types")
        .toolbar {
            EditButton()
        }
    }
}

struct SettingsDrinkTypeView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsDrinkTypeView()
            .environmentObject(DrinkModel())
    }
}
