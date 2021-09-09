//
//  DrinkData.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/7/21.
//

import Foundation

struct DrinkData: Decodable, Encodable {
    var drinks = [Drink]()
    var dailyGoal = 2000.0
    var units = Constants.milliliters
}
