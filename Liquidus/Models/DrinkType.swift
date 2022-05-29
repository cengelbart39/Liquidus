//
//  DrinkType.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 4/13/22.
//

import Foundation

/**
 A `class` representing what type of `Drink` consumed.
 */
class DrinkType: CustomStringConvertible, Decodable, Encodable, Equatable, Hashable, Identifiable {
    
    /// The unique id of the `DrinkType`
    var id = UUID()
    
    /// The name of the `DrinkType`
    var name: String
    
    /// The associated color with the `DrinkType`
    var color: CodableColor
    
    /// Whether or not the `DrinkType` is included by default; `true` if so; `false` if a custom `DrinkType`
    var isDefault: Bool
    
    /**
     Whether or not the `DrinkType` is enabled.
     - Every `DrinkType` defaults to `true`.
     - Only Default `DrinkType`s can be set to `false`.
     */
    var enabled: Bool
    
    /**
     Whether or not the color of a `DrinkType` has been changed by the user.
     - Custom `DrinkType`s are always set to false.
     - Default `DrinkType`s default to `true`, so System Colors can be used.
    */
    var colorChanged: Bool
    
    /**
     A description of a `DrinkType` taking in account all properties except `id`.
     */
    public var description: String {
        return "DrinkType(name: \(name), enabled: \(enabled), isDefault: \(isDefault), colorChanged: \(colorChanged))"
    }
    
    /**
     Create a Default DrinkType
     */
    init() {
        self.name = "temp"
        self.color = CodableColor(color: .systemRed)
        self.enabled = true
        self.isDefault = true
        self.colorChanged = true
    }
    
    /**
     Create a Custom DrinkType
     - Parameters:
        - name: The name of the `DrinkType`
        - color: The associated `Color` of the `DrinkType`
        - isDefault: Whether or not the `DrinkType` is included by default
        - enabled: Whether or not a `Drink` is enabled; applies to only default `DrinkType`s
        - colorChanged: Whether or not the use changed the associated `Color`
     */
    init(name: String, color: CodableColor, isDefault: Bool, enabled: Bool, colorChanged: Bool) {
        self.name = name
        self.color = color
        self.enabled = enabled
        self.isDefault = isDefault
        self.colorChanged = colorChanged
    }
    
    /**
     Determines if two `DrinkType`s are the same.
     - Parameters:
        - lhs: The `DrinkType` on the left side of `==`
        - rhs: The `DrinkType` on the right side of `==`
     - Returns: `true` if they're the same; `false` if not
     */
    static func == (lhs: DrinkType, rhs: DrinkType) -> Bool {
        return lhs.name == rhs.name && lhs.color.getColor() == rhs.color.getColor() && lhs.isDefault == rhs.isDefault && lhs.enabled == rhs.enabled && lhs.colorChanged == rhs.colorChanged
    }
    
    /**
     Get the Default `DrinkTypes`
     - Returns: The Default `DrinkTypes`
     */
    static func getDefault() -> [DrinkType] {
        let water = DrinkType(name: Constants.waterKey, color: CodableColor(color: .systemCyan), isDefault: true, enabled: true, colorChanged: false)
        
        let coffee = DrinkType(name: Constants.coffeeKey, color: CodableColor(color: .systemBrown), isDefault: true, enabled: true, colorChanged: false)
        
        let soda = DrinkType(name: Constants.sodaKey, color: CodableColor(color: .systemGreen), isDefault: true, enabled: true, colorChanged: false)
        
        let juice = DrinkType(name: Constants.juiceKey, color: CodableColor(color: .systemOrange), isDefault: true, enabled: true, colorChanged: false)
        
        return [water, coffee, soda, juice]
    }
    
    /**
     Creates a hash for a `DrinkType`
     */
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
        hasher.combine(self.color)
        hasher.combine(self.enabled)
        hasher.combine(self.isDefault)
        hasher.combine(self.colorChanged)
    }
    
    /**
     Gets the Water `DrinkType`
     - Returns: Water `DrinkType`
     */
    static func getWater() -> DrinkType {
        return DrinkType(name: Constants.waterKey, color: CodableColor(color: .systemTeal), isDefault: true, enabled: true, colorChanged: false)
    }
}
