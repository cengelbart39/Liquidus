//
//  DrinkModel.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 9/7/21.
//
//  UserDefaults Implementation Based Off Of:
//  https://youtu.be/vsL1UemuB3U by Paul Hudson
//
//  HealthKit Implementation Based Off Of:
//  - https://developer.apple.com/videos/play/wwdc2020/10664/
//  - https://youtu.be/ohgrzM9gfvM by azamsharp
//

import Foundation
import SwiftUI
import HealthKit
import WidgetKit
import CoreData

/**
 A ViewModel containing inter-view data and methods
 */
class DrinkModel: ObservableObject {
    
    /// The CoreData view context
    let managedObjectContext = PersistenceController.shared.container.viewContext
        
    @Published var userInfo = UserInfo()
    
    /// The HealthKit data access point, if granted access to HealthKit Data
    @Published var healthStore: HealthStore?
    
    /// Whether or not the Grayscale setting is enabled by the user
    @Published var grayscaleEnabled = UIAccessibility.isGrayscaleEnabled
    
    /**
     Create a new DrinkModel
     - Parameter test: Whether or not it was created bu LiquidusTests; True if so
     - Parameter suiteName: Only not `nil` if running UserDefaults Test
     */
    init(test: Bool, suiteName: String?) {
        // Create HealthStore
        healthStore = HealthStore()
        
        if test {
            self.userInfo = UserInfo()
            return
        }
        
        // Check if we need to preload the defaults
        let status = UserDefaults.standard.bool(forKey: Constants.loadDefault)
        
        // If false, load the defaults
        if status {
            self.retrieveUserInfo(test: test)
            
        } else {
            self.userInfo = UserInfo()
            
            if !test {
                loadDefaultDrinkTypes()
                self.managedObjectContext.refreshAllObjects()
            }
        }
    }
    
    // MARK: - Creation & UserDefaults
    /**
     Generate and save the default `DrinkType`s upon a fresh load of the app
     */
    func loadDefaultDrinkTypes() {
        // Create and set Water
        let water = DrinkType(context: managedObjectContext)
        water.id = UUID()
        water.order = 0
        water.name = Constants.waterKey
        water.isDefault = true
        water.enabled = true
        water.colorChanged = false
        water.color = UIColor.systemTeal.encode() ?? Data()
        
        // Create and set Coffee
        let coffee = DrinkType(context: managedObjectContext)
        coffee.id = UUID()
        coffee.order = 1
        coffee.name = Constants.coffeeKey
        coffee.isDefault = true
        coffee.enabled = true
        coffee.colorChanged = false
        coffee.color = UIColor.systemBrown.encode() ?? Data()
        
        // Create and set Soda
        let soda = DrinkType(context: managedObjectContext)
        soda.id = UUID()
        soda.order = 2
        soda.name = Constants.sodaKey
        soda.isDefault = true
        soda.enabled = true
        soda.colorChanged = false
        soda.color = UIColor.systemGreen.encode() ?? Data()
        
        // Create and set Juice
        let juice = DrinkType(context: managedObjectContext)
        juice.id = UUID()
        juice.order = 3
        juice.name = Constants.juiceKey
        juice.isDefault = true
        juice.enabled = true
        juice.colorChanged = false
        juice.color = UIColor.systemOrange.encode() ?? Data()
        
        // Save to CoreData
        PersistenceController.shared.saveContext()
                
        // Update key value
        UserDefaults.standard.setValue(true, forKey: Constants.loadDefault)
    }
    
    /**
     Retrieve data from UserDefaults
     - Parameter test: Whether or not it was created bu LiquidusTests; If True retrieves from `unitTestingKey`; If not retrieves from `sharedKey`
     */
    func retrieveUserInfo(test: Bool) {
        if let userDefaults = UserDefaults(suiteName: test ? Constants.unitTestingKey : Constants.sharedKey) {
            if let data = userDefaults.data(forKey: Constants.savedKey) {
                if let decoded = try? JSONDecoder().decode(UserInfo.self, from: data) {
                    self.userInfo = decoded
                }
            }
        }
    }
    
    /**
     Save any changes made to Drink Data
     - Parameter test: Whether or not it was created bu LiquidusTests; If True saves from `unitTestingKey`; If not saves to `sharedKey`
     */
    func saveUserInfo(test: Bool) {
        // Save data to user defaults
        if let userDefaults = UserDefaults(suiteName: test ? Constants.unitTestingKey : Constants.sharedKey) {
            if let encoded = try? JSONEncoder().encode(userInfo) {
                userDefaults.set(encoded, forKey: Constants.savedKey)
            }
        }
    }
    
    
    // MARK: - Misc
    /**
     Get the total amount of `Drink`s consumed for a given object conformant to `DatesProtocol` across all `DrinkType`s
     - Parameters:
        - types: All enabled `DrinkType`s in Core Data
        - dates: Any object conformant to `DatesProtocol`
     - Note: The function call doesn't specifically mandate that `dates` conforms to `DatesProtocol`, but if any unconforming type is passed in, 0 will always be returned
     - Returns: The total amount of `Drink`s consumed during `dates` across all `types`
     */
    func getTotalAmount(types: [DrinkType], dates: Any?) -> Double {
        
        var amount = 0.0
        
        if let day = dates as? Day {
            for type in types {
                amount += type.getTypeAmountByDay(day: day)
                
            }
            
        } else if let week = dates as? Week {
            for type in types {
                amount += type.getTypeAmountByWeek(week: week)
                
            }
            
        } else if let month = dates as? Month {
            for type in types {
                amount += type.getTypeAmountByMonth(month: month)
                
            }
            
        } else if let halfYear = dates as? HalfYear {
            for type in types {
                amount += type.getTypeAmountByHalfYear(halfYear: halfYear)
                
            }
            
        } else if let year = dates as? Year {
            for type in types {
                amount += type.getTypeAmountByYear(year: year)
                
            }
        }
        
        return amount
        
    }
    
    /**
     Generates random drinks for a year using the current date and saves to data store
     */
    func addYearDrinks() {
        // Get current year
        let year = Year(date: .now)
        
        let context = PersistenceController.shared.container.viewContext
        
        // Get water
        if let water = FetchRequest<DrinkType>(sortDescriptors: [], predicate: NSPredicate(format: "order == 0")).wrappedValue.first {
            
            // Loop through months in year
            for month in year.data {
                
                // Loop through days in month
                for day in month.data {
                    // Get a random double btwn 0 and 1,600
                    let rand = Double.random(in: 0...1600)
                    
                    let drink = Drink(context: context)
                    drink.id = UUID()
                    drink.amount = rand
                    drink.type = water
                    drink.date = day
                    
                    water.addToDrinks(drink)
                }
            }
        }
    }
    
    // MARK: - Drink Types
    /**
     For a `DrinkType` get the associated `Color`. If the `Color` for a default `DrinkType` hasn't been changed, return a System `Color`. Otherwise and for Custom `DrinkTypes`, return the stored `Color`.
     - Parameter type: `DrinkType` to retrieve a `Color` from
     - Returns: The saved color with the `DrinkType`, unless returning a System `Color`
     */
    func getDrinkTypeColor(type: DrinkType) -> Color {
        // Check if the color isn't changed for the given type...
        if (!type.colorChanged) {
            
            // If Water, return .systemCyan
            if type.name == Constants.waterKey {
                return Color(.systemCyan)
                
                // If Coffee, return .systemBrown
            } else if type.name == Constants.coffeeKey {
                return Color(.systemBrown)
                
                // If Soda, return .systemGreen
            } else if type.name == Constants.sodaKey {
                return Color(.systemGreen)
                
                // If Juice, return .systemOrange
            } else if type.name == Constants.juiceKey {
                return Color(.systemOrange)
                
            }
        }
        
        // If not, return the stored color (if it exists)
        if let data = type.color {
            if let uiColor = UIColor.color(data: data) {
                return Color(uiColor)
            }
        }
        
        return Color.primary
    }
    
    /**
     Get a Gradient dependent on `self.grayscaleEnabled`
     - Precondition: The Total `DrinkType` is selected
     - Returns: A solid `LinearGradient` of `Color.primary`, if `self.grayscaleEnabled` is `true`, or a rainbow `LinearGradient` if not
     */
    func getDrinkTypeGradient() -> LinearGradient {
        if self.grayscaleEnabled {
            // Return solid white gradient
            return LinearGradient(colors: [.primary], startPoint: .top, endPoint: .bottom)
            
        } else {
            // Return rainbow gradient
            return LinearGradient(colors: [.red, .orange, .yellow, .green, .blue, .purple], startPoint: .top, endPoint: .bottom)
        }
    }
    
    /**
     Return the total amount consumed for all `Drink`s
     - Parameter drinks: `Drink`s retrieved from Core Data
     - Precondition: `drinks` are all `Drink` of an enabled `DrinkType`
     - Returns: The total amount consumed across all `Drink`s
     */
    func getTotalAmount(drinks: [Drink]) -> Double {
        // Loop through drinks to get total amount
        var amount = 0.0
        
        for drink in drinks {
            amount += drink.amount
        }
        
        return amount
    }
    
    /**
     Return the average for all `Drink`s of a specific `DrinkType`
     - Parameters:
        - drinks: `Drink`s retrieved from Core Data
        - startDate: The first date in the range considered
     - Precondition: `drinks` contains all `Drink`s of an enabled `DrinkType`
     - Returns: An average if 3 months have passed since the first `Drink` has been logged; `nil` if 3 months haven't passed
     */
    func getTotalAverage(drinks: [Drink], startDate: Date) -> Double? {
        var total = 0.0
        for drink in drinks {
            total += drink.amount
        }
        
        // Find the minumum date from drinks
        var minDate = Date()
        for drink in drinks {
            if drink.date < minDate {
                minDate = drink.date
            }
        }
        
        // Get the difference in months between minDate and startDate
        let monthDifference = Calendar.current.dateComponents([.month], from: minDate, to: startDate)
        
        // Get the date that is three months earlier than startDate
        if let threeMonthsAgo = Calendar.current.date(byAdding: .month, value: -3, to: startDate) {
            
            // Get the components in days for threeMonthsAgo
            let threeMonths = Calendar.current.dateComponents([.day], from: threeMonthsAgo, to: .now)
            
            // Get the day count and mounth count
            if let threeDiff = threeMonths.day, let monthDiff = monthDifference.month {
                
                // If three or more months have data return the average
                if monthDiff >= 3 {
                    return floor(total/Double(threeDiff))
                    
                    // If not return nil
                } else if monthDiff < 3 {
                    return nil
                }
            }
        }
        
        return 0.0
    }
    
    /**
     Process the user-inputed name of a new `DrinkType`
     - Parameter name: The user-inputed name (i.e. "aPpLe CiDer")
     - Returns: The processed name (i.e. "Apple Cider")
     */
    func processDrinkTypeName(name: String) -> String {
        // Seperate type by spaces
        let words = name.split(separator: " ")
        
        var saveType = ""
        
        // Loop through words
        for word in words {
            
            // Get first char of word and uppercase it
            let first = word.first!.uppercased()
            
            // Lowercase word
            var rest = word.lowercased()
            // Remove first char
            rest.remove(at: rest.startIndex)
            
            // Update saveType
            saveType += (first + rest)
            
            // If word isn't the end of type...
            if words.firstIndex(of: word) != words.count-1 {
                // Add space
                saveType += " "
            }
        }
        
        return saveType
    }
    
    // MARK: - Units
    /**
     Gets the appropriate specifier so a double will have 0 or 2 decimal points displayed
     - Parameter amount: The amount to get the specifier for
     - Returns: The specifier; `"%.0f"` for a whole number; `"%.2f"` for any decimal number
     */
    func getSpecifier(amount: Double) -> String {
        // Rounds amount up or down
        let rounded = amount.rounded()
        
        // When round and amount are the same return so no decimals are used
        if rounded == amount {
            return "%.0f"
            
            // If not, use 2 decimal places
        } else {
            return "%.2f"
        }
    }
    
    /**
     Get the unit abbreviation for the stored unit
     - Returns: The unit abbreviation; `"cups"`, `"floz"`, `"mL"`, `"L"`; Empty `String` for unrecognized units
     */
    func getUnits() -> String {
        
        // Check for Cups
        if self.userInfo.units == Constants.cupsUS {
            return Constants.cups
            
            // Check for Milliliters
        } else if self.userInfo.units == Constants.milliliters {
            return Constants.mL
            
            // Check for Liters
        } else if self.userInfo.units == Constants.liters {
            return Constants.L
            
            // Check for Fluid Ounces
        } else if self.userInfo.units == Constants.fluidOuncesUS {
            return Constants.flOzUS
        }
        
        // Return an empty String if none of the if/if-else conditions trigger
        return ""
    }
    
    /**
     For the stored unit return the full name of a unit to be used in Accessibility Support
     - Returns: `"milliliters"`, `"liters"`,  `"fluid ounces"`, `"cups"`
     */
    func getAccessibilityUnitLabel() -> String {
        // Get the stored units
        let units = self.userInfo.units
        
        // Check for Millliters
        if units == Constants.milliliters {
            return "milliliters"
            
            // Check for Liters
        } else if units == Constants.liters {
            return "liters"
            
            // Check for Fluid Ounces
        } else if units == Constants.fluidOuncesUS {
            return "fluid ounces"
            
            // Check for Cups
        } else {
            return "cups"
        }
    }
    
    /**
     Convert all measurements in the old unit to the new unit
     - Parameters:
        - pastUnit: The name of the previously used unit
        - newUnit: The name of the new unit the user selected
        - drinks: All `Drink`s stored in Core Data, regardless of whether its type is enabled or disabled
     */
    func convertMeasurements(pastUnit: String, newUnit: String, drinks: [Drink]) {
        
        // Get measurement of daily goal from pastUnit
        let dailyGoalMeasurement = Measurement(value: self.userInfo.dailyGoal, unit: Constants.unitDictionary[pastUnit]!)
        
        // Convert daily goal to newUnit
        self.userInfo.dailyGoal = dailyGoalMeasurement.converted(to: Constants.unitDictionary[newUnit]!).value
        
        for drink in drinks {
            
            // Get measurement of drink amount from pastUnit
            let drinkMeasurement = Measurement(value: drink.amount, unit: Constants.unitDictionary[pastUnit]!)
            
            // Convert drink amount to newUnit
            drink.amount = drinkMeasurement.converted(to: Constants.unitDictionary[newUnit]!).value
            
        }
        
        do {
            try managedObjectContext.save()
        } catch {
            fatalError("DrinkModel: convertMeasurements: Unable to save to CoreData")
        }
        
    }
    
    // MARK: - Data by Hour Functions
    /**
     Gets `Drink`s consumed during the given `Hour`
     - Parameters:
        - drinks: All `Drink`s stored in Core Data
        - hour: The `Hour` to filter by
     - Returns: A `Drink` array for all `Drink`s in `hour`
     */
    private func filterDataByHour(drinks: [Drink], hour: Hour) -> [Drink] {
        
        // Filter for drinks in the same hour, day, month, and year as date and drinks
        // that have an enabled type
        return drinks.filter {
            Calendar.current.compare($0.date, to: hour.data, toGranularity: .hour) == .orderedSame && Calendar.current.compare($0.date, to: hour.data, toGranularity: .day) == .orderedSame && Calendar.current.compare($0.date, to: hour.data, toGranularity: .month) == .orderedSame && Calendar.current.compare($0.date, to: hour.data, toGranularity: .year) == .orderedSame && $0.type.enabled
        }
    }
    
    // MARK: - Data Filtering
    /**
     Filter all `Drink`s consumed during the given `Day`
     - Parameters:
        - drinks: All `Drink`s stored in Core Data
        - day: The `Day` to filter by
     - Returns: The `Drink`s consumed during `day`
     */
    private func filterDataByDay(drinks: [Drink], day: Day) -> [Drink] {
        
        // Filter for drinks in the same day, month, and year as date and
        // drinks that have an enabled type
        return drinks.filter {
            Calendar.current.compare($0.date, to: day.data, toGranularity: .day) == .orderedSame && Calendar.current.compare($0.date, to: day.data, toGranularity: .month) == .orderedSame && Calendar.current.compare($0.date, to: day.data, toGranularity: .year) == .orderedSame && $0.type.enabled
        }
    }
    
    /**
     Get the percentage of `Drink`s consumed for all `DrinkType`s over the user's daily goal across the given `Day`
     - Parameters:
        - types: All the enabled `DrinkType`s
        - day: The `Day` to get the percentage for
     - Precondition: All `DrinkType`s in `types` are enabled
     - Returns: The percentage of `Drink`s consumed for all `types` over the user's daily goal across `day`
     */
    func getTotalPercentByDay(types: [DrinkType], day: Day) -> Double {
        
        var total = 0.0
        
        for type in types {
            total += type.getTypeAmountByDay(day: day)
        }
        
        return total/self.userInfo.dailyGoal
    }
    
    /**
     Get the `Drink`s consumed during the given `Week`
     - Parameter week: The `Week` to filter by
     - Returns: The `Drink`s consumed during `week`
     */
    private func filterDataByWeek(drinks: [Drink], week: Week) -> [Drink] {
        
        var output = [Drink]()
        
        for day in week.data {
            output += self.filterDataByDay(drinks: drinks, day: Day(date: day))
        }
        
        return output
    }
    
    /**
     Get the `Drink`s that were consumed during a given `Month`
     - Parameter month: The `Month` to filter by
     - Returns: The `Drink`s that were consumed during `month`
     */
    private func filterDataByMonth(drinks: [Drink], month: Month) -> [Drink] {
        // Filter drinks in the same month and year as the first day of month
        return drinks.filter {
            Calendar.current.compare(month.firstDay(), to: $0.date, toGranularity: .month) == .orderedSame && Calendar.current.compare(month.firstDay(), to: $0.date, toGranularity: .year) == .orderedSame && $0.type.enabled
        }
    }
    
    // MARK: - Progress Bar Methods
    /**
     Compute the user's progress to reaching their daily goal for Progress Bar Display
     - Parameters:
        - types: The `DrinkType`s to get the user's progress for
        - day: A `Day` to get the user's progress for
     - Returns: The progress percent towards the user's daily goal
     */
    func getProgressPercent(types: [DrinkType], day: Day) -> Double {
        // Create progress to 0.0
        var progress = 0.0
        
        // Loop through type index...
        for type in types {
            
            progress += type.getTypePercentByDay(day: day, goal: self.userInfo.dailyGoal)
        }
        
        return progress
        
    }
    
    /**
     For a given `[DrinkType]` and `Day` get the highlight color for use in the Progress Bar
     - Parameters:
     - types: An array of `DrinkType`s
     - date: A `Day`
     - Returns: `"GoalGreen"` if Goal is met; `Color.primary` if grayscale is enabled; result of `getDrinkTypeColor()` otherwise
     */
    func getHighlightColor(types: [DrinkType], day: Day) -> Color {
        // Get the total percent using type and dates
        let totalPercent = self.getProgressPercent(types: types, day: day)
        
        // Return "GoalGreen" if the user's goal is met or exceeded
        if totalPercent >= 1.0 {
            return Color("GoalGreen")
            
        } else {
            // If grayscale is enabled, always return Color.primary
            if self.grayscaleEnabled {
                return .primary
                
                // Otherwise return the result of getDrinkTypeColor()
            } else {
                return self.getDrinkTypeColor(type: types.last!)
                
            }
        }
    }
    
    // MARK: - Data Items
    /**
     A public function that will get an array of `DataItem`s for the specificed time period conformant to `DatesProtocol`
     - Parameters:
        - types: All the enabled `DrinkType`s
        - dates: An object conformant to `DatesProtocol`
     - Returns: The appropriate array of `DataItem`s for `dates`
     */
    func getAllDataItems<T: DatesProtocol>(types: [DrinkType], dates: T) -> [DataItem] {
        
        if let day = dates as? Day {
            return self.getAllDataItemsForDay(types: types, day: day)
            
        } else if let week = dates as? Week {
            return self.getAllDataItemsForWeek(types: types, week: week)
            
        } else if let month = dates as? Month {
            return self.getAllDataItemsForMonth(types: types, month: month)
            
        } else if let halfYear = dates as? HalfYear {
            return self.getAllDataItemsForHalfYear(types: types, halfYear: halfYear)
            
        } else if let year = dates as? Year {
            return self.getAllDataItemsforYear(types: types, year: year)
            
        }
        
        return [DataItem]()
        
    }
    
    /**
     Get `DataItem`s for all `Drink`s with enabled `DrinkType`s during a given `Day`
     - Parameters:
        - types: All the `DrinkType`s
        - day: The `Day` to get `DataItem`s for
     - Returns: `DataItem`s for each `Hour` in `day`
     */
    private func getAllDataItemsForDay(types: [DrinkType], day: Day) -> [DataItem] {
        // Create an empty data items array
        var items = [DataItem]()
        
        var allDrinks = [Drink]()
        
        for type in types {
            allDrinks += type.filterDataByDay(day: day)
        }
        
        for hour in day.getHours() {
            let drinks = self.filterDataByHour(drinks: allDrinks, hour: hour)
            
            items.append(DataItem(drinks: drinks, type: nil, total: true, date: hour.data))
        }
        
        return items
    }
    
    /**
     Get `DataItem`s for all `Drink`s with enabled `DrinkType`s during a given `Week`
     - Parameters:
        - types: All the `DrinkType`s
        - week: The `Week` to get `DataItem`s for
     - Returns: `DataItem`s for each `Date` in `week`
     */
    private func getAllDataItemsForWeek(types: [DrinkType], week: Week) -> [DataItem] {
        
        var items = [DataItem]()
        
        var allDrinks = [Drink]()
        
        for type in types {
            allDrinks += type.filterDataByWeek(week: week)
        }
        
        for day in week.data {
            let drinks = self.filterDataByDay(drinks: allDrinks, day: Day(date: day))
            
            items.append(DataItem(drinks: drinks, type: nil, total: true, date: day))
        }
        
        return items
        
    }
    
    /**
     Get `DataItem`s for all `Drink`s with enabled `DrinkType`s during a given `Month`
     - Parameters:
        - types: All the `DrinkType`s
        - month: The `Month` to get `DataItem`s for
     - Returns: `DataItem`s for each `Date` in `month`
     */
    private func getAllDataItemsForMonth(types: [DrinkType], month: Month) -> [DataItem] {
        
        var items = [DataItem]()
        
        var allDrinks = [Drink]()
        
        for type in types {
            allDrinks += type.filterDataByMonth(month: month)
        }
        
        for day in month.data {
            let drinks = self.filterDataByDay(drinks: allDrinks, day: Day(date: day))
            
            items.append(DataItem(drinks: drinks, type: nil, total: true, date: day))
        }
        
        return items
    }
    
    /**
     Get `DataItem`s for all `Drink`s with enabled `DrinkType`s during a given `HalfYear`
     - Parameters:
        - types: All the `DrinkType`s
        - halfYear: The `HalfYear` to get `DataItem`s for
     - Returns: `DataItem`s for each `Week` in `halfYear`
     */
    private func getAllDataItemsForHalfYear(types: [DrinkType], halfYear: HalfYear) -> [DataItem] {
        
        var items = [DataItem]()
        
        var allDrinks = [Drink]()
        
        for type in types {
            allDrinks += type.filterDataByHalfYear(halfYear: halfYear)
        }
        
        for week in halfYear.data {
            let drinks = self.filterDataByWeek(drinks: allDrinks, week: week)
            
            items.append(DataItem(drinks: drinks, type: nil, total: true, date: week.firstDay()))
        }
        
        return items
    }
    
    /**
     Get `DataItem`s for all `Drink`s with enabled `DrinkType`s during a given `Year`
     - Parameters:
        - types: All the `DrinkType`s
        - hyear: The `Year` to get `DataItem`s for
     - Returns: `DataItem`s for each `Month` in `year`
     */
    private func getAllDataItemsforYear(types: [DrinkType], year: Year) -> [DataItem] {
        
        var items = [DataItem]()
        
        var allDrinks = [Drink]()
        
        for type in types {
            allDrinks += type.filterDataByYear(year: year)
        }
        
        for month in year.data {
            var drinks = self.filterDataByMonth(drinks: allDrinks, month: month)
            
            drinks = drinks.sorted { d1, d2 in
                d1.date < d2.date
            }
            
            items.append(DataItem(drinks: drinks, type: nil, total: true, date: month.firstDay()))
        }
        
        return items
        
    }
    
    // MARK: - Trends Chart Method
    /**
     Assuming a bar is not selected, return the amount of a `DrinkType` consumed over some `TimePeriod`.
     - Parameters:
        - type: A `DrinkType`
        - dates: `Day`, `Week`, `Month`, `HalfYear`, or `Year`
     - Requires: `dates` to conform to `DatesProtocol` for a non-zero return
     - Precondition: In the Trends Chart, a bar is not selected
     - Returns: The amount of a `type` consumed over some time period.
     */
    func getOverallAmount(type: DrinkType, dates: Any?) -> Double {
        
        // If a Day return getTypeAmountByDay()
        if let day = dates as? Day {
            return type.getTypeAmountByDay(day: day)
            
            // If a Week return getTypeAmountByWeek()
        } else if let week = dates as? Week {
            return type.getTypeAmountByWeek(week: week)
            
            // If a Month return getTypeAmountByMonth()
        } else if let month = dates as? Month {
            return type.getTypeAmountByMonth(month: month)
            
            // If HalfYear return getTypeAmountByHalfYear()
        } else if let halfYear = dates as? HalfYear {
            return type.getTypeAmountByHalfYear(halfYear: halfYear)
            
            // If Year return getTypeAmountByYear()
        } else if let year = dates as? Year {
            return type.getTypeAmountByYear(year: year)
            
        }
        
        // If none of the if/if-else statements trigger return 0.0
        return 0.0
    }
    
    /**
     Get the width of spacers for the Trends Chart based on the given `TimePeriod`
     - Parameters:
        - timePeriod: The current `TimePeriod`
        - isWidget: Whether or not function is called by a Widget
     - Returns: The Maximum Spacer Width; if `isWidget` is true, it always returns 1
     */
    func chartSpacerMaxWidth(timePeriod: TimePeriod, isWidget: Bool) -> CGFloat {
        
        // If not called from a widget
        if !isWidget {
            
            // If daily or weekly return 10
            if timePeriod == .daily || timePeriod == .weekly {
                return 10
                
                // If monthly or yearly return 5
            } else if timePeriod == .monthly || timePeriod == .yearly {
                return 5
                
                // Otherwise return 2
            } else {
                return 2
            }
            
            // If it is, return 1
        } else {
            return 1
        }
    }
    
    /**
     Get the Max Value for an array of `DataItem`s.
     If half-yearly or yearly data is selected, get the total of each individual week and then get the max value.
     - Parameters:
        - dataItems: A `DataItem`s array
        - timePeriod: The current `TimePeriod`
     - Returns: The maximum value for the given `DataItem`s
     */
    func getMaxValue(dataItems: [DataItem], timePeriod: TimePeriod) -> Double {
        // If the time period is not half year  or year, map data items to get max
        if timePeriod != .halfYearly && timePeriod != .yearly {
            return dataItems.map { $0.getMaxValue() }.max() ?? 0.0
            
            // If the time period is half year or year...
        } else {
            var dailyIntake = [Double]()
            
            // Loop through data items
            for item in dataItems {
                
                var amount = 0.0
                
                // Get drinks if they exist
                if let drinks = item.drinks {
                    
                    // Loop through drinks and add to amount
                    for drink in drinks {
                        amount += drink.amount
                    }
                    
                    // Append amount to array
                    dailyIntake.append(amount)
                }
            }
            
            // Get the max of daily intake
            return dailyIntake.map { $0 }.max() ?? 0.0
        }
    }
    
    /**
     Get the average of `Drink`s consumed over a given `TimePeriod` for a given `DrinkType`.
     - Parameters:
        - dataItems: A `DataItem` array
        - timePeriod: The current `TimePeriod`
     - Precondition: `.weekly` or `.monthly` `TimePeriod` for a possible non-zero value
     - Precondition: In the Trends Chart, a bar is selected
     - Returns: The average of
     */
    func getAverage(dataItems: [DataItem], timePeriod: TimePeriod) -> Double {
        // Create sum tracker
        var sum = 0.0
        
        // Loop through data items
        for item in dataItems {
            
            // Get drinks, if they exist
            if let drinks = item.drinks {
                
                // Loop through drinks and add to sum
                for drink in drinks {
                    sum += drink.amount
                }
            }
        }
        
        // If weekly or monthly divide by dataItems count for average
        if timePeriod == .weekly || timePeriod == .monthly {
            return sum/Double(dataItems.count)
        }
        
        // Return 0.0 if a different time period is passed in
        return 0.0
    }
    
    /**
     Return the vertical axis scale in a `String` array depending on the selected `TimePeriod`
     - Parameters:
        - dataItems: Used exclusively for `HalfYear` and `Year`
        - timePeriod: Determines what to return
     - Returns: An array with the appropriate text
     */
    func verticalAxisText(dataItems: [DataItem], timePeriod: TimePeriod) -> [String] {
        
        // Daily Condition
        if timePeriod == .daily {
            return ["12A", "6A", "12P", "6P"]
            
        // Weekly Condition
        } else if timePeriod == .weekly {
            return ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
            
        // Monthly Condition
        } else if timePeriod == .monthly {
            
            // For 28 days
            if dataItems.count == 28 {
                return ["0", "7", "14", "21"]
                
            // For 29 days
            } else if dataItems.count == 29 {
                return ["0", "7", "14", "21", "28"]
                
            // For 30 days
            } else if dataItems.count == 30 {
                return ["0", "6", "12", "18", "24"]
                
            // For 31 days
            } else if dataItems.count == 31 {
                return ["0", "6", "12", "18", "24", "30"]
            }
            
        // Half-Yearly & Yearly Condition
        } else {
            // Create & Setup DateFormatter
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM"
            
            // Create empty String array
            var text = [String]()
            
            // Loop through data items
            for item in dataItems {
                
                // Get formatter string (i.e. April 2022)
                let month = formatter.string(from: item.date)
                
                // Add month to text if already doesn't exist
                if !text.contains(month) {
                    text.append(month)
                }
            }
            
            return text
        }
        
        // Return empty array if none of the if-statements trigger
        return [String]()
    }
    
    /**
     Return the horizontal axis text as a String array.
     If the total amount for a `DataItem`s array is not evenly divisble by 3, increment by 100 until it is.
     - Parameter amount: The max amount from the `DataItem`s
     - Returns: A `String` array with 4 values; format relative to Overall Amount: [1, 2/3, 1/3, 0]
     */
    func horizontalAxisText(amount: Double) -> [String] {
        
        // Get the overall amount for the type, time period, and date(s)
        var newAmount = amount
        
        // Increment by 100 until the ceiling is divisible by 3
        while Int(ceil(newAmount)) % 3 != 0 {
            newAmount += 100
        }
        
        // Set 1/3 amount
        let one3 = Int(newAmount/3)
        
        // Set 2/3 amount
        let two3 = Int(2*newAmount/3)
        
        // Create and setup NumberFormatter
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = true
        formatter.maximumSignificantDigits = 2
        
        // Get 1/3, 2/3, 3/3 formatted strings
        if let one = formatter.string(from: NSNumber(value: Int(ceil(newAmount)))), let twoThirds = formatter.string(from: NSNumber(value: Int(two3))), let oneThird = formatter.string(from: NSNumber(value: Int(one3))) {
            
            // Return 3/3, 2/3, 1/3, 0/3 array
            return [one, twoThirds, oneThird, "0"]
        }
        
        // Return empty array if above if-let fails
        return [String]()
    }
    
    /**
     For an array of DataItem, get an array of AXDataPoint using timePeriod
     - Parameters:
        - dataItems: Pull data from `DataItem`s to `AXDataPoint`s
        - timePeriod: Determines how to generate `AXDataPoint`s
        - halfYearOffset: Exclusively used for `dataPointWeekRange()` in `HalfYear`
        - test: Only `true` if called from LiquidusTests; passed into `dataPointWeekRange()`
     - Returns: An array of `AXDataPoint`s
     */
    func seriesDataPoints(dataItems: [DataItem], timePeriod: TimePeriod, halfYearOffset: Int, test: Bool) -> [AXDataPoint] {
        
        // Empty AXDataPoint array
        var output = [AXDataPoint]()
        
        // Daily Condition
        if timePeriod == .daily {
            // Create formatter
            let formatter = DateFormatter()
            formatter.dateFormat = "H"
            
            // Loop through dataItems
            for item in dataItems {
                
                // Create and append AXDataPoints
                output.append(AXDataPoint(x: self.dataPointHourRangeText(item: item), y: item.getIndividualAmount()))
            }
            
        // Weekly/Monthly Condition
        } else if timePeriod == .weekly || timePeriod == .monthly {
            // Create formatter
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            
            // Loop through items
            for item in dataItems {
                
                // Create and append AXDataPoints
                output.append(AXDataPoint(x: formatter.string(from: item.date), y: item.getIndividualAmount()))
            }
            
        // Half-Yearly Condition
        } else if timePeriod == .halfYearly {
            // Loop through data items
            for item in dataItems {
                
                // Append AXDataPoints
                output.append(AXDataPoint(x: self.dataPointWeekRange(item: item, halfYearOffset: halfYearOffset, test: test), y: item.getIndividualAmount()))
            }
            
        // Yearly Condition
        } else if timePeriod == .yearly {
            
            // Date Formatter
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM y"
            
            // Loop through data items
            for item in dataItems {
                
                // Create and append AXDataPoint
                output.append(AXDataPoint(x: formatter.string(from: item.date), y: item.getIndividualAmount()))
            }
        }
        
        return output
    }
    
    /**
     For a `DataItem`, get the range of the displayed data
     - Parameter item: A `DataItem`
     - Returns: An hour range for the `DataItem`; i.e.` "12 to 1 AM"`, `"11 AM to 12 PM"`, `"11 PM to 12 AM"`
     */
    func dataPointHourRangeText(item: DataItem) -> String {
        // Create Formatter
        let formatter = DateFormatter()
        formatter.dateFormat = "H"
        
        // Create date from item
        let date1 = item.date
        
        // Create date from item advanced by 1 hour
        if let date2 = Calendar.current.date(byAdding: .hour, value: 1, to: item.date) {
            
            // If the dates can be converted to doubles
            if let d1 = Int(formatter.string(from: date1)), let d2 = Int(formatter.string(from: date2)) {
                
                // Condition for 12 to 1 AM
                if d1 == 0 && d2 == 1 {
                    return "12 to 1 AM"
                    
                // Condition for 11 AM to 12 PM
                } else if d1 == 11 && d2 == 12 {
                    return "11 AM to 12 PM"
                    
                // Condition for 12 to 1 PM
                } else if d1 == 12 && d2 == 13 {
                    return "12 to 1 PM"
                    
                // Condition for 11 PM to 12 AM
                } else if d1 == 23 && d2 == 0 {
                    return "11 PM to 12 AM"
                    
                // Condition for all other AM hours
                } else if d1 < 11 && d2 < 12 {
                    return "\(d1) to \(d2) AM"
                    
                // Condition for all other PM hours
                }  else if d1 > 12 && d2 > 13 {
                    return "\(d1-12) to \(d2-12) PM"
                }
            }
            
        }
        
        return ""
    }
    
    /**
     For a DataItem get the week range it represents
     - Parameters:
        - item: A `DataItem`
        - halfYearOffset: Helps determine which `Month` is the first month of the `halfYear`
        - test: Only `true` when called from LiquidusTests; If so uses a specific date to determine return.
     - Returns: The week range of `item` (i.e. April 3rd to 9th, 2022)
     */
    func dataPointWeekRange(item: DataItem, halfYearOffset: Int, test: Bool) -> String {
        
        // Get days in week for item
        let week = Week(date: item.date)
        
        // Create a test date; for use if test = true
        let testDate = Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!
        
        // Get startDate
        // Uses testDate if test = true; if not uses today
        let startDate = Calendar.current.date(byAdding: .month, value: halfYearOffset-6, to: test ? testDate : .now) ?? Date()
        
        // Get endDate
        let endDate = Calendar.current.date(byAdding: .month, value: 1, to: test ? testDate : .now) ?? Date()
        
        // Get the first and last day of the half year
        if let start = Month(date: startDate).data.first, let end = Month(date: endDate).data.last {
            
            // Check if the week contains start or end
            if week.data.contains(start) || week.data.contains(end) {
                
                // Filter out days earlier than start
                let firstWeek = week.data.filter {
                    Calendar.current.compare(start, to: $0, toGranularity: .month) == .orderedSame && Calendar.current.compare(start, to: $0, toGranularity: .year) == .orderedSame
                }
                
                // Filter out days later than end
                let secondWeek = week.data.filter {
                    Calendar.current.compare(end, to: $0, toGranularity: .month) == .orderedSame && Calendar.current.compare(end, to: $0, toGranularity: .year) == .orderedSame
                }
                
                // If firstWeek is empty and secondWeek isn't use secondWeek
                // Means that no dates matched start and some dates matched end
                if firstWeek.isEmpty && !secondWeek.isEmpty {
                    return Week(days: secondWeek).accessibilityDescription
                    
                // If firstWeek isn't empty and secondWeek is use firstWeek
                // Means that some dates matched start and no dates matched end
                } else if !firstWeek.isEmpty && secondWeek.isEmpty {
                    return Week(days: firstWeek).accessibilityDescription
                    
                }
            }
            
            // If not or the inner if/if-else statements both return false
            return week.accessibilityDescription
        }
        
        return ""
    }
    
    /**
     For the chart return a `String` detailing the data being displayed
     - Parameters:
        - type: The `DrinkType` being represented; `nil` if display Total data
        - dates: The `Day`, `Week`, `Month`, `HalfYear` or `Year` being represented
     - Note: The function call doesn't explicitly require `dates` to conform to `DatesProtocol`, but an empty `String` will be returned if it doesn't.
     - Returns: The accessibility label for the Chart
     */
    func getChartAccessibilityLabel(type: DrinkType?, dates: Any?) -> String {
        
        // Create blank output string
        var output = ""
        
        // If all data is selected
        if let type = type {
            output = "Data representing your \(type.name) intake "
            
            // If a specific drink type is selected
        } else {
            output = "Data representing your intake "
        }
        
        if let day = dates as? Day {
            
            if day.accessibilityDescription == "Today" || day.accessibilityDescription == "Yesterday" {
                
                output += "\(day.accessibilityDescription)."
                
            } else {
                
                output += "on \(day.accessibilityDescription)."
            }
            
        } else if let week = dates as? Week {
            output += "from \(week.accessibilityDescription)."
            
        } else if let month = dates as? Month {
            output += "on \(month.accessibilityDescription)."
            
        } else if let halfYear = dates as? HalfYear {
            output += "from \(halfYear.accessibilityDescription)."
            
        } else if let year = dates as? Year {
            output += "from \(year.accessibilityDescription)."
            
        } else {
            // Returns an empty string if can't cast
            return ""
        }
        
        // Return output string
        return output
    }
    
    // MARK: - HealthKit Methods
    /**
     Convert stored unit to `HKUnit`
     - Returns: The associated `HKUnit` with the stored unit
     */
    func getHKUnit() -> HKUnit {
        if self.userInfo.units == Constants.cupsUS {
            return HKUnit.cupUS()
            
        } else if self.userInfo.units == Constants.fluidOuncesUS {
            return HKUnit.fluidOunceUS()
            
        } else if self.userInfo.units == Constants.liters {
            return HKUnit.liter()
            
        } else if self.userInfo.units == Constants.milliliters {
            return HKUnit.literUnit(with: .milli)
            
        }
        
        return HKUnit.literUnit(with: .milli)
        
    }
    
    /**
     Save a drink to HealthKit
     */
    func saveToHealthKit(allDrinks: [Drink]) {
        
        // Create HKType
        let waterType = HKSampleType.quantityType(forIdentifier: .dietaryWater)!
        
        // Check that healthStore exists
        if self.healthStore != nil && self.healthStore?.healthStore != nil {
            
            // Loop through drink store
            for drink in allDrinks {
                
                // Check if lastHKSave exists, compare it (if exists) against the drink's
                // date, and check the type is Water
                if self.userInfo.lastHKSave == nil || self.userInfo.lastHKSave ?? Date() < drink.date {
                    
                    // Assign startDate and endDate
                    let startDate = drink.date
                    let endDate = startDate
                    
                    // Get the quanity as HKQuantity
                    let quantity = HKQuantity(unit: self.getHKUnit(), doubleValue: drink.amount)
                    
                    // Create a HKQuantitySample
                    let sample = HKQuantitySample(type: waterType, quantity: quantity, start: startDate, end: endDate)
                    
                    // Save to HealthKit
                    self.healthStore!.healthStore!.save(sample) { success, error in
                        
                        // Update lastHKSave
                        DispatchQueue.main.async {
                            self.userInfo.lastHKSave = Date()
                        }
                    }
                }
            }
        }
    }
}
