//
//  TrendsBarChart.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 1/24/22.
//

import SwiftUI

struct TrendsBarChart: View {
    @EnvironmentObject var model: DrinkModel
    
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    
    @AccessibilityFocusState var isHeaderFocused: Bool
    
    var type: String
    
    // MARK: - State Variables
    @State var selectedTimePeriod = Constants.TimePeriod.daily
    
    @State var selectedDay = Date()
    @State var selectedWeek = [Date]()
    @State var selectedMonth = [Date]()
    @State var selectedHalfYear = [[Date]]()
    @State var selectedYear = [[Date]]()
        
    @State var touchLocation = -1

    // MARK: - Body
    var body: some View {
        
        // MARK: Time Period Picker
        GeometryReader { geo in
            ScrollView {
                VStack(alignment: .leading) {
                    TrendsTimePickerView(binding: $selectedTimePeriod, touchLocation: $touchLocation)
                    
                    let dataItems = self.getDataItems()

                    let amount = touchLocation == -1 ? self.getOverallAmount(dataItems: dataItems) : self.getIndividualAmount(dataItems: dataItems)
                    
                    VStack(alignment: .leading) {
                        // MARK: Amount Type Text
                        Text(self.getAmontTypeText())
                            .font(.body)
                            .foregroundColor(.gray)
                            .padding(.leading)
                            .dynamicTypeSize(.xSmall ... .xxxLarge)
                                            
                        // MARK: Amount Text
                        Group {
                            Text("\(self.getAmountText(amount: amount, dataItems: dataItems), specifier: model.getSpecifier(amount: amount)) ")
                                .font(.title)
                                + Text(model.getUnits())
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(.gray)
                        }
                        .dynamicTypeSize(.xSmall ... .xxxLarge)
                        .padding(.leading)
                        
                        // MARK: Time Range Text
                        Text(self.getTimeRangeText())
                            .font(.body)
                            .foregroundColor(.gray)
                            .padding(.leading)
                            .dynamicTypeSize(.xSmall ... .xxxLarge)
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityFocused($isHeaderFocused)
                    
                    let maxValue = self.getMaxValue(dataItems: dataItems)
                    
                    VStack() {
                        // MARK: - Chart
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color(.systemGray6))
                                .onTapGesture {
                                    touchLocation = -1
                                }
                            
                            HStack {
                                ZStack {
                                    // MARK: Vertical Axis
                                    HStack {
                                        ForEach(verticalAxisText(dataItems: dataItems), id: \.self) { text in
                                            TrendsBarVerticalAxisView(text: selectedTimePeriod != .yearly ? text : String(text[0]))
                                                .dynamicTypeSize(.large)
                                            
                                            Spacer ()
                                        }
                                        
                                        Rectangle()
                                            .foregroundColor(Color(.systemGray5))
                                            .frame(width: 1.5)
                                            .padding(.bottom, 20)
                                    }
                                    
                                    // MARK: Horizontal Axis Lines
                                    VStack {
                                        Rectangle()
                                            .foregroundColor(Color(.systemGray5))
                                            .frame(height: 1.5)
                                        
                                        Spacer()
                                        
                                        Rectangle()
                                            .foregroundColor(Color(.systemGray5))
                                            .frame(height: 1.5)
                                        
                                        Spacer()
                                        
                                        Rectangle()
                                            .foregroundColor(Color(.systemGray5))
                                            .frame(height: 1.5)
                                        
                                        Spacer()
                                        
                                        Rectangle()
                                            .foregroundColor(Color(.systemGray5))
                                            .frame(height: 1.5)
                                            .padding(.bottom, 20)
                                        
                                    }
                                    
                                    // MARK: Bars
                                    VStack(alignment: .leading) {
                                        HStack(spacing: 5) {
                                            ForEach(dataItems) { item in
                                                
                                                TrendsBarView(item: item, value: normalizedValue(item: item, maxValue: self.getAxisMaxValue(maxValue: maxValue)), type: type)
                                                    .accessibilityChartDescriptor(self)
                                                    .opacity(touchLocation == -1 ? 1 : (touchLocation == dataItems.firstIndex(of: item) ? 1 : 0.7))
                                                    .onTapGesture {
                                                        if let selectedItem = dataItems.firstIndex(of: item) {
                                                            if touchLocation == selectedItem {
                                                                touchLocation = -1
                                                            } else {
                                                                touchLocation = selectedItem
                                                            }
                                                        }
                                                    }
                                            }
                                        }
                                    }
                                    .padding(.bottom, 20)
                                }
                                
                                // MARK: Horizontal Axis Text
                                let label = self.horizontalAxisText(dataItems: dataItems)
                                
                                if amount != 0 {
                                    VStack(alignment: .leading) {
                                        Text(label[0])
                                        
                                        Spacer()
                                        
                                        Text(label[1])
                                        
                                        Spacer()
                                        
                                        Text(label[2])
                                        
                                        Spacer()
                                        
                                        Text(label[3])
                                    }
                                    .foregroundColor(Color(.systemGray))
                                    .dynamicTypeSize(.large)
                                    .font(.caption)
                                    .padding(.top, -4)
                                    .padding(.bottom, 20)
                                }
                            }
                            .padding([.horizontal, .top])
                            .padding(.bottom, 10)
                            
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel(self.getChartAccessibilityLabel())
                        .simultaneousGesture(self.drag)
                        .frame(height: geo.size.height/1.75)
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                        
                        // MARK: - Data
                        NavigationLink {
                            TrendsDataListView(type: type)
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(Color(.systemGray6))
                                
                                HStack {
                                    Text("View All Data")
                                        .foregroundColor(.primary)
                                        .multilineTextAlignment(.leading)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color(.systemGray2))
                                }
                                .padding()
                            }
                        }
                        .padding(.horizontal)
                    }
                    .onAppear {
                        touchLocation = -1
                    }
                }
            }
        }
        .navigationTitle(type)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            isHeaderFocused = false
            selectedWeek = model.getDaysInWeek(date: selectedDay)
            selectedMonth = model.getMonth(day: selectedDay)
            selectedHalfYear = model.getHalfYear(date: selectedDay)
            selectedYear = model.getYear(date: selectedDay)
        }
        .onChange(of: selectedTimePeriod) { _ in
            touchLocation = -1
            isHeaderFocused = true
        }
        .onChange(of: touchLocation) { _ in
            isHeaderFocused = true
        }
    }
    
    // MARK: - Header Text Methods
    /**
     Returns "TOTAL",  "AVERAGE", or "DAILY AVERAGE" depending on selectedTimePeriod and touchLocation
     */
    private func getAmontTypeText() -> String {
        // If data is day or (week and no selected bar) or (month and no selected bar) return "TOTAL"
        if selectedTimePeriod == .daily || (selectedTimePeriod == .weekly && touchLocation != -1) || (selectedTimePeriod == .monthly && touchLocation != -1) {
            return Constants.total
            
        // If time period is half yearly or yearly, return "DAILY AVERAGE"
        } else if selectedTimePeriod == .halfYearly || selectedTimePeriod == .yearly {
            return Constants.dailyAverage
            
        // In all other cases, return "AVERAGE"
        } else {
            return Constants.average
        }
    }
    /**
     Takes in an amount, Double, and dataItems, [DataItem], and returns an amount or average
     */
    private func getAmountText(amount: Double, dataItems: [DataItem]) -> Double {
        // Get the header text type
        let headerText = self.getAmontTypeText()
        
        // If "TOTAL" return the given amount
        if headerText == Constants.total {
            return amount
        
        // If "AVERAGE" get and return an average
        } else if headerText == Constants.average {
            let average = self.getAverage(dataItems: dataItems)
            
            return ceil(average)
            
        // IF "DAILY AVERAGE" get and return the daily average
        } else if headerText == Constants.dailyAverage {
            let average = self.getDailyAverage(dataItems: dataItems)
            
             return ceil(average)
        }
        
        return 0.0
    }
    
    /**
     Returns a range, in the form of a String, for the displayed or selected data
     */
    private func getTimeRangeText() -> String {
        // If no bar is selected return the time period range
        if touchLocation == -1 {
            return self.timePeriodText()

        } else {
            // If time period is day, return in format of "April 8, 2003, 5 PM"
            if selectedTimePeriod == .daily {
                return "\(self.timePeriodText()), \(hourRangeText())"
                
            // If week or month return in the format of "April 8, 2003"
            } else if selectedTimePeriod == .weekly || selectedTimePeriod == .monthly {
                return self.dayRangeText()
                
            // If half year return in the format of "April 6-12, 2003"
            } else if selectedTimePeriod == .halfYearly {
                return self.weekRangeText()
                
            // If year, return in the format of "April 2003"
            } else if selectedTimePeriod == .yearly {
                return self.monthRangeText()
            }
        }
        
        return ""

    }
    
    /**
     Returns a String of current/selected time period based on selectedTimePeriod
     */
    private func timePeriodText() -> String {
        if selectedTimePeriod == .daily {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.timeStyle = .none
            formatter.doesRelativeDateFormatting = true
            
            return formatter.string(from: selectedDay)
            
        } else if selectedTimePeriod == .weekly {
            return model.getWeekText(week: selectedWeek)
            
        } else if selectedTimePeriod == .monthly {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM y"
            
            return formatter.string(from: selectedMonth[0])
            
        } else if selectedTimePeriod == .halfYearly || selectedTimePeriod == .yearly {
            return model.getHalfYearText(halfYear: selectedTimePeriod == .halfYearly ? selectedHalfYear : selectedYear)
        }
        
        return ""
    }
    
    /**
     Assuming daily data is being shown and a bar is selected, return a hour range (i.e. 12-1 AM) based on touchLocation
     */
    private func hourRangeText() -> String {
        switch touchLocation {
        case 0:
            return "12-1 AM"
        case 1:
            return "1-2 AM"
        case 2:
            return "2-3 AM"
        case 3:
            return "3-4 AM"
        case 4:
            return "4-5 AM"
        case 5:
            return "5-6 AM"
        case 6:
            return "6-7 AM"
        case 7:
            return "7-8 AM"
        case 8:
            return "8-9 AM"
        case 9:
            return "9-10 AM"
        case 10:
            return "10-11 AM"
        case 11:
            return "11 AM - 12 PM"
        case 12:
            return "12-1 PM"
        case 13:
            return "1-2 PM"
        case 14:
            return "2-3 PM"
        case 15:
            return "3-4 PM"
        case 16:
            return "4-5 PM"
        case 17:
            return "5-6 PM"
        case 18:
            return "6-7 PM"
        case 19:
            return "7-8 PM"
        case 20:
            return "8-9 PM"
        case 21:
            return "9-10 PM"
        case 22:
            return "10-11 PM"
        case 23:
            return "11 PM -12 AM"
        default:
            return ""
        }
    }
    
    /**
     Assuming weekly or monthly data is being shown and a bar is selected,  return a day in the form of "April 8, 2003" as a String
     */
    private func dayRangeText() -> String {
        // Date Formatter
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeZone = .none
        formatter.doesRelativeDateFormatting = true
        
        // Return the selected day as a string
        if selectedTimePeriod == .weekly {
            return formatter.string(from: selectedWeek[touchLocation])
        } else if selectedTimePeriod == .monthly {
            return formatter.string(from: selectedMonth[touchLocation])
        }
        return ""
    }
    
    /**
     Assuming half-yearly data is being shown and bar is being selected, return a week range (i.e. "April 6-12, 2003") as a String. Format varies for a week spanning different months and years.
     */
    private func weekRangeText() -> String {
        return model.getWeekText(week: selectedHalfYear[touchLocation])
    }
    
    /**
     Assuming uearly data is being shown and a bar is selected, return a month range (i.e. "April 2003")
     */
    private func monthRangeText() -> String {
        if let day = selectedYear[touchLocation].first {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM y"
            
            return formatter.string(from: day)
        }
        
        return ""
    }
    
    // MARK: - Data Methods
    /**
     Depending on the selected time period, return the data items for the associated selected time range. For example, if daily data is chosen, it returns the Data Items, by hour, for a chosen day.
     */
    func getDataItems() -> [DataItem] {
        if selectedTimePeriod == .daily {
            return model.getDataItemsForDay(date: selectedDay, type: type)
            
        } else if selectedTimePeriod == .weekly {
            return model.getDataItemsForWeek(week: selectedWeek, type: type)
            
        } else if selectedTimePeriod == .monthly {
            return model.getDataItemsForMonth(month: selectedMonth, type: type)
            
        } else if selectedTimePeriod == .halfYearly {
            return model.getDataItemsForHalfYear(halfYear: selectedHalfYear, type: type)
            
        } else if selectedTimePeriod == .yearly {
            return model.getDataItemsforYear(year: selectedYear, type: type)
        }
        
        return [DataItem]()
    }
    
    /**
     Assuming a bar is not selected, return the amount of a drink type consumed over some time period for a given drink type.
     */
    private func getOverallAmount(dataItems: [DataItem]) -> Double {
        if selectedTimePeriod == .daily {
            return model.getTypeAmountByDay(type: type, date: selectedDay)
            
        } else if selectedTimePeriod == .weekly {
            return model.getTypeAmountByWeek(type: type, week: selectedWeek)
            
        } else if selectedTimePeriod == .monthly {
            return model.getTypeAmountByMonth(type: type, month: selectedMonth)
            
        } else if selectedTimePeriod == .halfYearly {
            return model.getTypeAmountByHalfYear(type: type, halfYear: selectedHalfYear)
            
        } else if selectedTimePeriod == .yearly {
            return model.getTypeAmountByYear(type: type, year: selectedYear)
        }
        return 0.0
    }
    
    /**
     Assuming a bar is selected, return the amount of a drink type consumed over some time period for a given drink type.
     */
    private func getIndividualAmount(dataItems: [DataItem]) -> Double {
        if selectedTimePeriod == .daily {
            return model.getTypeAmountByTime(type: type, time: dataItems[touchLocation].date)
            
        } else if selectedTimePeriod == .weekly {
            return model.getTypeAmountByDay(type: type, date: selectedWeek[touchLocation])

        } else if selectedTimePeriod == .monthly {
            return model.getTypeAmountByDay(type: type, date: selectedMonth[touchLocation])

        } else if selectedTimePeriod == .halfYearly {
            return model.getTypeAmountByWeek(type: type, week: selectedHalfYear[touchLocation])

        } else if selectedTimePeriod == .yearly {
            return model.getTypeAmountByMonth(type: type, month: selectedYear[touchLocation])
        }
        
        return 0.0
    }
    
    /**
     Assuming weekly or monthly data is chosen and a bar is selected get the average of drinks consumed over the time period for a given drink type.
     */
    private func getAverage(dataItems: [DataItem]) -> Double {
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
        
        // Get the average
        if selectedTimePeriod == .weekly {
            return sum/7
        } else if selectedTimePeriod == .monthly {
            return sum/Double(dataItems.count)
        }
        
        return 0.0
    }
    
    /**
     Assuming half-yearly data is chosen, get the daily average depending on if a bar is selected
     */
    private func getDailyAverage(dataItems: [DataItem]) -> Double {
        var sum = 0.0
        
        // If selected time period is half year or yearly
        if selectedTimePeriod == .halfYearly || selectedTimePeriod == .yearly {
            
            // If a bar isn't selected
            if touchLocation == -1 {
                // Loop through data items
                for item in dataItems {
                    
                    // Get drinks if they exist
                    if let drinks = item.drinks {
                        
                        // Loop through drinks and add to sum
                        for drink in drinks {
                            sum += drink.amount
                        }
                    }
                }
                
                // Get the dividend of the half year
                var dividend = 0.0
                
                // Get the count of each week in the half year
                if selectedTimePeriod == .halfYearly {
                    for week in selectedHalfYear {
                        dividend += Double(week.count)
                    }
                    
                // Get the count of each month in the year
                } else if selectedTimePeriod == .yearly {
                    for month in selectedYear {
                        dividend += Double(month.count)
                    }
                }
            
                return sum/dividend
                
            // If a bar is selected
            } else {
                
                // Get the drinks at the touch location if theye exist
                if let drinks = dataItems[touchLocation].drinks {
                    
                    // Loop through all drinks and add to sum
                    for drink in drinks {
                        sum += drink.amount
                    }
                }
                
                var dividend = 0.0
                
                // Set dividend to the count of days at the selected bar
                if selectedTimePeriod == .halfYearly {
                    dividend = Double(selectedHalfYear[touchLocation].count)
                } else if selectedTimePeriod == .yearly {
                    dividend = Double(selectedYear[touchLocation].count)
                }
                
                return sum/dividend
            }
        }
        
        return 0.0
    }
    
    /**
     Get the Max Value for an array of Data Items.
     If half-yearly data is selected, get the total of each individual week and then get the max value.
     */
    func getMaxValue(dataItems: [DataItem]) -> Double {
        // If the time period is not half year  or year, map data items to get max
        if selectedTimePeriod != .halfYearly && selectedTimePeriod != .yearly {
            return dataItems.map { $0.getMaxValue() }.max() ?? 0.0
            
        // If the time period is half year
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
    
    // MARK: - Bar Chart Methods
    /**
     For a data item and max value, divide the data item's total amount by the max value and return this value. When a data item has no amount, return 0.
     */
    func normalizedValue(item: DataItem, maxValue: Double) -> Double {
        // If max zero isn't zero divide
        if maxValue > 0 {
            return item.getIndividualAmount()/maxValue
        
        // If max is 0 return 0
        } else {
            return 0
        }
    }
    
    /**
     Return the vertical axis text in a String array depending on the selected time period
     */
    func verticalAxisText(dataItems: [DataItem]) -> [String] {
        if selectedTimePeriod == .daily {
            return ["12A", "6A", "12P", "6P"]
            
        } else if selectedTimePeriod == .weekly {
            return ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
            
        } else if selectedTimePeriod == .monthly {
            if dataItems.count == 28 {
                return ["0", "7", "14", "21"]
                
            } else if dataItems.count == 29 {
                return ["0", "7", "14", "21", "28"]
                
            } else if dataItems.count == 30 {
                return ["0", "6", "12", "18", "24"]
                
            } else if dataItems.count == 31 {
                return ["0", "6", "12", "18", "24", "30"]
            }
            
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM"
            
            var text = [String]()
            for item in dataItems {
                let month = formatter.string(from: item.date)
                if !text.contains(month) {
                    text.append(month)
                }
            }
            
            return text
        }
        
        return [String]()
    }
    
    /**
     Return the horizontal axis text as a String array.
     If the total amount for a Data Items array is not evenly divisble by 3, increment by 100 until it is.
     */
     func horizontalAxisText(dataItems: [DataItem]) -> [String] {
        var newAmount = self.getOverallAmount(dataItems: dataItems)
        
         while Int(ceil(newAmount)) % 3 != 0 {
             newAmount += 100
         }
        
        let oneThird = Int(newAmount/3)
        let twoThirds = Int(2*newAmount/3)
        
        return [String(Int(ceil(newAmount))), String(twoThirds), String(oneThird), "0"]
    }
    
    private func getAxisMaxValue(maxValue: Double) -> Double {
        var newAmount = maxValue
        while Int(ceil(newAmount)) % 3 != 0 {
            newAmount += 100
        }
        
        return newAmount
    }
    
    /**
     For the chart return a String detailing the data being displayed
     */
    func getChartAccessibilityLabel() -> String {
        var output = ""
        
        // If all data is selected
        if type == Constants.allKey {
            output = "Data representing your intake "
            
        // If a specific drink type is selected
        } else {
            output = "Data representing your \(type) intake "
        }
        
        if selectedTimePeriod == .daily {
            let text = self.timePeriodText()
            if text == "Today" || text == "Yesterday" {
                output += text
            } else {
                output += "on \(text)."
            }
        } else if selectedTimePeriod == .weekly {
            output += "from \(model.getAccessibilityWeekText(week: selectedWeek))."
            
        } else if selectedTimePeriod == .monthly {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM y"
            
            if let first = selectedMonth.first {
                output += "on \(formatter.string(from: first))."
            }
        
        } else if selectedTimePeriod == .halfYearly {
            output += "from \(model.getAccessibilityHalfYearText(halfYear: selectedHalfYear))."
            
        } else if selectedTimePeriod == .yearly {
            output += "from \(model.getAccessibilityHalfYearText(halfYear: selectedYear))."
        }
        
        return output
    }
}
