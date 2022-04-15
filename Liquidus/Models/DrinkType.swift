//
//  DrinkType.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 4/13/22.
//

import Foundation

class DrinkType: Decodable, Encodable, Equatable, Hashable, Identifiable {
    var id = UUID()
    var name: String
    var color: CodableColor
    var isDefault: Bool
    var enabled: Bool
    var colorChanged: Bool
    
    init() {
        self.name = "temp"
        self.color = CodableColor(color: .systemRed)
        self.enabled = true
        self.isDefault = true
        self.colorChanged = true
    }
    
    init(name: String, color: CodableColor, isDefault: Bool, enabled: Bool, colorChanged: Bool) {
        self.name = name
        self.color = color
        self.enabled = enabled
        self.isDefault = isDefault
        self.colorChanged = colorChanged
    }
    
    static func == (lhs: DrinkType, rhs: DrinkType) -> Bool {
        if lhs.name == rhs.name && lhs.color.getColor() == rhs.color.getColor() && lhs.isDefault == rhs.isDefault && lhs.enabled == rhs.enabled && lhs.colorChanged == rhs.colorChanged {
            return true
            
        } else {
            return false
        }
    }
    
    static func getDefault() -> [DrinkType] {
        let water = DrinkType(name: Constants.waterKey, color: CodableColor(color: .systemCyan), isDefault: true, enabled: true, colorChanged: false)
        
        let coffee = DrinkType(name: Constants.coffeeKey, color: CodableColor(color: .systemBrown), isDefault: true, enabled: true, colorChanged: false)
        
        let soda = DrinkType(name: Constants.sodaKey, color: CodableColor(color: .systemGreen), isDefault: true, enabled: true, colorChanged: false)
        
        let juice = DrinkType(name: Constants.juiceKey, color: CodableColor(color: .systemOrange), isDefault: true, enabled: true, colorChanged: false)
        
        return [water, coffee, soda, juice]
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
        hasher.combine(self.color)
        hasher.combine(self.enabled)
        hasher.combine(self.isDefault)
        hasher.combine(self.colorChanged)
    }
}
