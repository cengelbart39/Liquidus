//
//  DMTrendsChartTests.swift
//  LiquidusTests
//
//  Created by Christopher Engelbart on 5/4/22.
//

import XCTest
import CoreData
@testable import Liquidus

class DMTrendsChartTests: XCTestCase {

    var context: NSManagedObjectContext!
    
    var model: DrinkModel!

    override func setUp() {
        self.context = PersistenceController.inMemory.container.viewContext
        self.model = DrinkModel(test: true, suiteName: nil)
    }
    
    override func tearDown() {
        self.context = nil
        self.model = nil
    }
    
    func testGetOverallAmountByDay() {
        // Get a date for April 8, 2022
        let testDay = Day(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)

        // Add sample drinks for the day
        let types = SampleDrinks.day(testDay, context: context)
                
        // Assert Water returns 1,950
        XCTAssertEqual(model.getOverallAmount(type: types[0], dates: testDay), 1950.0)
        
        // Assert Coffee returns 1,950
        XCTAssertEqual(model.getOverallAmount(type: types[1], dates: testDay), 1950.0)
        
        // Assert Soda returns 1,950
        XCTAssertEqual(model.getOverallAmount(type: types[2], dates: testDay), 1950.0)

        // Assert Juice returns 1,950
        XCTAssertEqual(model.getOverallAmount(type: types[3], dates: testDay), 1950.0)
    }
    
    func testGetOverallAmountByWeek() {
        // Get a date for April 8, 2022
        let testWeek = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)

        // Add sample drinks for the day
        let types = SampleDrinks.week(testWeek, context: context)
                
        // Assert Water returns 400
        XCTAssertEqual(model.getOverallAmount(type: types[0], dates: testWeek), 400)
        
        // Assert Coffee returns 1,950
        XCTAssertEqual(model.getOverallAmount(type: types[1], dates: testWeek), 400)
        
        // Assert Soda returns 400
        XCTAssertEqual(model.getOverallAmount(type: types[2], dates: testWeek), 400)

        // Assert Juice returns 400
        XCTAssertEqual(model.getOverallAmount(type: types[3], dates: testWeek), 400)
    }
    
    func testGetOverallAmountByMonth() {
        // Get a date for April 8, 2022
        let testMonth = Month(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)

        // Add sample drinks for the day
        let types = SampleDrinks.month(testMonth, context: context)
                
        // Assert Water returns 400
        XCTAssertEqual(model.getOverallAmount(type: types[0], dates: testMonth), 3200)
        
        // Assert Coffee returns 1,950
        XCTAssertEqual(model.getOverallAmount(type: types[1], dates: testMonth), 3200)
        
        // Assert Soda returns 400
        XCTAssertEqual(model.getOverallAmount(type: types[2], dates: testMonth), 3150)

        // Assert Juice returns 400
        XCTAssertEqual(model.getOverallAmount(type: types[3], dates: testMonth), 3200)
    }
    
    func testGetOverallAmountByHalfYear() {
        // Get a date for April 8, 2022
        let testHalfYear = HalfYear(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)

        // Add sample drinks for the day
        let types = SampleDrinks.halfYear(testHalfYear, context: context)
                
        // Assert Water returns 400
        XCTAssertEqual(model.getOverallAmount(type: types[0], dates: testHalfYear), 10400)
        
        // Assert Coffee returns 1,950
        XCTAssertEqual(model.getOverallAmount(type: types[1], dates: testHalfYear), 10300)
        
        // Assert Soda returns 400
        XCTAssertEqual(model.getOverallAmount(type: types[2], dates: testHalfYear), 10400)

        // Assert Juice returns 400
        XCTAssertEqual(model.getOverallAmount(type: types[3], dates: testHalfYear), 10400)
    }
    
    func testGetOverallAmountByYear() {
        // Get a date for April 8, 2022
        let testYear = Year(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)

        // Add sample drinks for the day
        let types = SampleDrinks.year(testYear, context: context)
                
        // Assert Water returns 38,250
        XCTAssertEqual(model.getOverallAmount(type: types[0], dates: testYear), 38250)
        
        // Assert Coffee returns 38,150
        XCTAssertEqual(model.getOverallAmount(type: types[1], dates: testYear), 38150)
        
        // Assert Soda returns 38,300
        XCTAssertEqual(model.getOverallAmount(type: types[2], dates: testYear), 38300)

        // Assert Juice returns 38,400
        XCTAssertEqual(model.getOverallAmount(type: types[3], dates: testYear), 38400)
    }
    
    func testChartSpacerMaxWidth() {
        // Assert, regardless of time period, when isWidget is true,
        // 1 is returned
        XCTAssertEqual(model.chartSpacerMaxWidth(timePeriod: .daily, isWidget: true), CGFloat(1))
        XCTAssertEqual(model.chartSpacerMaxWidth(timePeriod: .weekly, isWidget: true), CGFloat(1))
        XCTAssertEqual(model.chartSpacerMaxWidth(timePeriod: .monthly, isWidget: true), CGFloat(1))
        XCTAssertEqual(model.chartSpacerMaxWidth(timePeriod: .halfYearly, isWidget: true), CGFloat(1))
        XCTAssertEqual(model.chartSpacerMaxWidth(timePeriod: .yearly, isWidget: true), CGFloat(1))
        
        // Assert, when is Widget is false, daily and weekly
        // time periods return 10
        XCTAssertEqual(model.chartSpacerMaxWidth(timePeriod: .daily, isWidget: false), CGFloat(10))
        XCTAssertEqual(model.chartSpacerMaxWidth(timePeriod: .weekly, isWidget: false), CGFloat(10))
        
        // Assert, when is Widget is false, all other time periods
        // return 5
        XCTAssertEqual(model.chartSpacerMaxWidth(timePeriod: .monthly, isWidget: false), CGFloat(5))
        XCTAssertEqual(model.chartSpacerMaxWidth(timePeriod: .halfYearly, isWidget: false), CGFloat(2))
        XCTAssertEqual(model.chartSpacerMaxWidth(timePeriod: .yearly, isWidget: false), CGFloat(5))
    }
    
    func testGetMaxValueForDay() {
        // Create a date for April 8, 2022
        let testDay = Day(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
        
        // Get sample data items for this day
        let dayItems = SampleDataItems.day(testDay, context: context)
        
        // Get function return
        let dayMax = model.getMaxValue(dataItems: dayItems, timePeriod: .daily)
        
        // Assert function returns 600
        XCTAssertEqual(dayMax, 600.0)
    }
    
    func testGetMaxValueForWeek() {
        // Get the week of April 8, 2022 (April 3-9, 2022)
        let testWeek = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
        
        // Get sample data items for this week
        let weekItems = SampleDataItems.week(testWeek, context: context)
        
        // Get function return
        let weekMax = model.getMaxValue(dataItems: weekItems, timePeriod: .weekly)
        
        // Assert function returns 400
        XCTAssertEqual(weekMax, 400.0)
    }
    
    func testGetMaxValueForMonth() {
        // Get the month of April 2022
        let testMonth = Month(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
        
        // Get sample data items for the month
        let monthItems = SampleDataItems.month(testMonth, context: context)
        
        // Get the function return
        let monthMax = model.getMaxValue(dataItems: monthItems, timePeriod: .monthly)
        
        // Assert function returns 800
        XCTAssertEqual(monthMax, 800.0)
    }
    
    func testGetMaxValueforHalfYear() {
        // Get the half year from Nov 2021 to Apr 2022
        let testHalfYear = HalfYear(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
        
        // Get sample data items for the half year
        let halfYearItems = SampleDataItems.halfYear(testHalfYear, context: context)
        
        // Get function return
        let halfYearMax = model.getMaxValue(dataItems: halfYearItems, timePeriod: .halfYearly)
        
        // Assert function returns 1,600
        XCTAssertEqual(halfYearMax, 1600.0)
    }
    
    func testGetMaxValueForYear() {
        // Get the year for May 2021 to April 2022
        let testYear = Year(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
        
        // Get sample data items for the year
        let yearItems = SampleDataItems.year(testYear, context: context)
        
        // Get the function return
        let yearMax = model.getMaxValue(dataItems: yearItems, timePeriod: .yearly)
        
        // Assert the function returns 12,800
        XCTAssertEqual(yearMax, 12800.0)
    }
    
    func testGetAverageForWeek() {
        // Get the week for April 8, 2022 (April 3-9, 2022)
        let testWeek = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
        
        // Get sample data items for this week
        let weekItems = SampleDataItems.week(testWeek, context: context)
        
        // Get function return
        let weekResult = model.getAverage(dataItems: weekItems, timePeriod: .weekly)
        
        // Set expected result
        let weekExpected = 1600.0/7.0
        
        // Assert function returns expected
        XCTAssertEqual(weekResult, weekExpected)
    }
    
    func testGetAverageForMonth() {
        // Get the month of April 2022
        let testMonth = Month(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
        
        // Get sample data items for the month
        let monthItems = SampleDataItems.month(testMonth, context: context)
        
        // Get function return
        let monthResult = model.getAverage(dataItems: monthItems, timePeriod: .monthly)
        
        // Set expected result
        let monthExpected = 12750.0/30.0
        
        // Assert function returns expected
        XCTAssertEqual(monthResult, monthExpected)
    }
    
    func testVerticalAxisText() {
        // Day Test
        // Create a date for April 8, 2022
        let testDay = Day(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
        
        // Get sample data items for the day
        let dayItems = SampleDataItems.day(testDay, context: context)
        
        // Get function return
        let dayResult = model.verticalAxisText(dataItems: dayItems, timePeriod: .daily)
        
        // Assert the function returns the expected result
        XCTAssertEqual(dayResult, ["12A","6A","12P","6P"])
        
        // Week Test
        // Get the week of April 8, 2022 (April 3-9, 2022)
        let testWeek = Week(date: testDay.data)
        
        // Get sample data items for the week
        let weekItems = SampleDataItems.week(testWeek, context: context)
        
        // Get function return
        let weekResult = model.verticalAxisText(dataItems: weekItems, timePeriod: .weekly)
        
        // Assert the function returns the expected result
        XCTAssertEqual(weekResult, ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"])
        
        // Month Test
        // Get the month of April 2022
        let testMonth = Month(date: testDay.data)
        
        // Get sample data items for the month
        let monthItems = SampleDataItems.month(testMonth, context: context)
        
        // Get function return
        let monthResult = model.verticalAxisText(dataItems: monthItems, timePeriod: .monthly)
        
        // Assert the function returns the expected result
        XCTAssertEqual(monthResult, ["0", "6", "12", "18", "24"])
        
        // Half Year Test
        // Get the half year of Nov 2021 to Apr 2022
        let testHalfYear = HalfYear(date: testDay.data)
        
        // Get sample data items for the half year
        let halfYearItems = SampleDataItems.halfYear(testHalfYear, context: context)
        
        // Get function return
        let halfYearResult = model.verticalAxisText(dataItems: halfYearItems, timePeriod: .halfYearly)
        
        // Assert the function returns the expected result
        XCTAssertEqual(halfYearResult, ["Nov", "Dec", "Jan", "Feb", "Mar", "Apr"])
        
        // Year Test
        // Get the year of May 2021 to Apr 2022
        let testYear = Year(date: testDay.data)
        
        // Get sample data items for the year
        let yearItems = SampleDataItems.year(testYear, context: context)
        
        // Get function return
        let yearResult = model.verticalAxisText(dataItems: yearItems, timePeriod: .yearly)
        
        // Assert the function returns the expected result
        XCTAssertEqual(yearResult, ["May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec", "Jan", "Feb", "Mar", "Apr"])
    }
    
    func testHorizontalAxisText() {
        let expected1 = ["7,800", "5,200", "2,600", "0"]
        XCTAssertEqual(model.horizontalAxisText(amount: 7800), expected1)
        
        let expected2 = ["1,800", "1,200", "600", "0"]
        XCTAssertEqual(model.horizontalAxisText(amount: 1800), expected2)

        let expected3 = ["13,000", "8,800", "4,400", "0"]
        XCTAssertEqual(model.horizontalAxisText(amount: 13000), expected3)

        let expected4 = ["42,000", "28,000", "14,000", "0"]
        XCTAssertEqual(model.horizontalAxisText(amount: 42000), expected4)
        
        let expected5 = ["150,000", "100,000", "50,000", "0"]
        XCTAssertEqual(model.horizontalAxisText(amount: 150000), expected5)
    }
    
    func testSeriesDataPointsByDay() {
        // Create a date for April 8, 2022
        let testDay = Day(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
        
        // Get sample data items for the day
        let dayItems = SampleDataItems.day(testDay, context: context)
        
        // Get function return
        let dayResult = model.seriesDataPoints(dataItems: dayItems, timePeriod: .daily, halfYearOffset: 0, test: true)
        
        // Get expected AXDataPoints
        let dayExpected = SampleAXDataPoints.day(testDay)
                
        // Assert at the same index the result and expected arrays return the same value
        for index in 0..<dayExpected.count {
            XCTAssertTrue(dayResult[index] == dayExpected[index], "failed at index \(index)")
        }
    }
      
    func testSeriesDataPointsByWeek() {
        // Get the week of April 8, 2022 (April 3-9, 2022)
        let testWeek = Week(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
        
        // Get sample data items for the week
        let weekItems = SampleDataItems.week(testWeek, context: context)
        
        // Get function return
        let weekResult = model.seriesDataPoints(dataItems: weekItems, timePeriod: .weekly, halfYearOffset: 0, test: true)
        
        // Get expected AXDataPoints
        let weekExpected = SampleAXDataPoints.week(testWeek)
        
        // Assert at the same index the result and expected arrays return the same value
        for index in 0..<weekExpected.count {
            XCTAssertTrue(weekResult[index] == weekExpected[index], "failed at index \(index)")
        }
    }
    
    func testSeriesDataPointsByMonth() {
        // Get the month of April 2022
        let testMonth = Month(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
        
        // Get sample data items for the month
        let monthItems = SampleDataItems.month(testMonth, context: context)
        
        // Get function return
        let monthResult = model.seriesDataPoints(dataItems: monthItems, timePeriod: .monthly, halfYearOffset: 0, test: true)
        
        // Get expected AXDataPoints
        let monthExpected = SampleAXDataPoints.month(testMonth)
        
        // Assert at the same index the result and expected arrays return the same value
        for index in 0..<monthExpected.count {
            XCTAssertTrue(monthResult[index] == monthExpected[index], "failed at index \(index)")
        }
    }
    
    func testSeriesDataPointsByHalfYear() {
        let day = Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!
        
        // Get the half year of Nov 2021 to Apr 2022
        let testHalfYear = HalfYear(date: day)
        
        // Get sample data items for the half year
        let halfYearItems = SampleDataItems.halfYear(testHalfYear, context: context)
        
        // Get half year offset
        let offset = Calendar.current.dateComponents([.month], from: day, to: .now).month! - 1
        
        // Get function return
        let halfYearResult = model.seriesDataPoints(dataItems: halfYearItems, timePeriod: .halfYearly, halfYearOffset: offset, test: true)
        
        // Get expected AXDataPoints
        let halfYearExpected = SampleAXDataPoints.halfYear(testHalfYear)
        
        // Assert at the same index the result and expected arrays return the same value
        for index in 0..<halfYearExpected.count {
            XCTAssertTrue(halfYearResult[index] == halfYearExpected[index], "failed at index \(index)")
        }
    }
    
    func testSeriesDataPointsByYear() {
        // Get the year of May 2021 to Apr 2022
        let testYear = Year(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
        
        // Get sample data items for the year
        let yearItems = SampleDataItems.year(testYear, context: context)
        
        // Get function return
        let yearResult = model.seriesDataPoints(dataItems: yearItems, timePeriod: .yearly, halfYearOffset: 0, test: true)
        
        // Set expected result
        let yearExpected = SampleAXDataPoints.year(testYear)
        
        // Assert at the same index the result and expected arrays return the same value
        for index in 0..<yearExpected.count {
            XCTAssertTrue(yearResult[index] == yearExpected[index], "failed at index \(index)")
        }
    }
    
    func testDataPointHourRangeText() {
        // Create a date for April 8, 2022
        let testDate = Day(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
        
        // Get sample data items for the day
        let dayItems = SampleDataItems.day(testDate, context: context)
        
        // Assert each data item returns the expected text
        XCTAssertEqual(model.dataPointHourRangeText(item: dayItems[0]), "12 to 1 AM")
        XCTAssertEqual(model.dataPointHourRangeText(item: dayItems[1]), "1 to 2 AM")
        XCTAssertEqual(model.dataPointHourRangeText(item: dayItems[2]), "2 to 3 AM")
        XCTAssertEqual(model.dataPointHourRangeText(item: dayItems[3]), "3 to 4 AM")
        XCTAssertEqual(model.dataPointHourRangeText(item: dayItems[4]), "4 to 5 AM")
        XCTAssertEqual(model.dataPointHourRangeText(item: dayItems[5]), "5 to 6 AM")
        XCTAssertEqual(model.dataPointHourRangeText(item: dayItems[6]), "6 to 7 AM")
        XCTAssertEqual(model.dataPointHourRangeText(item: dayItems[7]), "7 to 8 AM")
        XCTAssertEqual(model.dataPointHourRangeText(item: dayItems[8]), "8 to 9 AM")
        XCTAssertEqual(model.dataPointHourRangeText(item: dayItems[9]), "9 to 10 AM")
        XCTAssertEqual(model.dataPointHourRangeText(item: dayItems[10]), "10 to 11 AM")
        XCTAssertEqual(model.dataPointHourRangeText(item: dayItems[11]), "11 AM to 12 PM")
        XCTAssertEqual(model.dataPointHourRangeText(item: dayItems[12]), "12 to 1 PM")
        XCTAssertEqual(model.dataPointHourRangeText(item: dayItems[13]), "1 to 2 PM")
        XCTAssertEqual(model.dataPointHourRangeText(item: dayItems[14]), "2 to 3 PM")
        XCTAssertEqual(model.dataPointHourRangeText(item: dayItems[15]), "3 to 4 PM")
        XCTAssertEqual(model.dataPointHourRangeText(item: dayItems[16]), "4 to 5 PM")
        XCTAssertEqual(model.dataPointHourRangeText(item: dayItems[17]), "5 to 6 PM")
        XCTAssertEqual(model.dataPointHourRangeText(item: dayItems[18]), "6 to 7 PM")
        XCTAssertEqual(model.dataPointHourRangeText(item: dayItems[19]), "7 to 8 PM")
        XCTAssertEqual(model.dataPointHourRangeText(item: dayItems[20]), "8 to 9 PM")
        XCTAssertEqual(model.dataPointHourRangeText(item: dayItems[21]), "9 to 10 PM")
        XCTAssertEqual(model.dataPointHourRangeText(item: dayItems[22]), "10 to 11 PM")
        XCTAssertEqual(model.dataPointHourRangeText(item: dayItems[23]), "11 PM to 12 AM")
    }
    
    func testDataPointWeekRange() {
        // Create a date for April 8, 2022
        let testDate = Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!

        // Get the half year from Nov 2021 to Apr 2022
        let testHalfYear = HalfYear(date: testDate)
        
        // Get data items for the half year
        let halfYearItems = SampleDataItems.halfYear(testHalfYear, context: context)
        
        // Assert the following items return the expected strings
        XCTAssertEqual(model.dataPointWeekRange(item: halfYearItems.first!, halfYearOffset: 1, test: true), "Nov 1st to 6th, 2021")
        
        XCTAssertEqual(model.dataPointWeekRange(item: halfYearItems[4], halfYearOffset: 1, test: true), "Nov 28th to Dec 4th, 2021")
        
        XCTAssertEqual(model.dataPointWeekRange(item: halfYearItems[8], halfYearOffset: 1, test: true), "Dec 26th, 2021 to Jan 1st, 2022")
        
        XCTAssertEqual(model.dataPointWeekRange(item: halfYearItems[13], halfYearOffset: 1, test: true), "Jan 30th to Feb 5th, 2022")
        
        XCTAssertEqual(model.dataPointWeekRange(item: halfYearItems[17], halfYearOffset: 1, test: true), "Feb 27th to Mar 5th, 2022")

        XCTAssertEqual(model.dataPointWeekRange(item: halfYearItems[21], halfYearOffset: 1, test: true), "Mar 27th to Apr 2nd, 2022")

        XCTAssertEqual(model.dataPointWeekRange(item: halfYearItems.last!, halfYearOffset: 1, test: true), "Apr 24th to 30th, 2022")
    }
    
    func testGetChartAccessibilityLabel() {
        // Test for Today for Total Type
        let r1 = model.getChartAccessibilityLabel(type: nil, dates: Day())
        XCTAssertEqual(r1, "Data representing your intake Today.")
        
        // Test for Today for Water Type
        let r2 = model.getChartAccessibilityLabel(type: SampleDrinkTypes.water(context), dates: Day())
        XCTAssertEqual(r2, "Data representing your Water intake Today.")
        
        // Test for Yesterday for Water Type
        let yesterday = Day(date: Calendar.current.date(byAdding: .day, value: -1, to: .now)!)
        let r3 = model.getChartAccessibilityLabel(type: SampleDrinkTypes.water(context), dates: yesterday)
        XCTAssertEqual(r3, "Data representing your Water intake Yesterday.")
        
        // Create day, week, month, half, and year from April 8, 2022
        let testDay = Day(date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!)
        let testWeek = Week(date: testDay.data)
        let testMonth = Month(date: testDay.data)
        let testHalfYear = HalfYear(date: testDay.data)
        let testYear = Year(date: testDay.data)
        
        // Test for April 8, 2022 for Water Type
        let r4 = model.getChartAccessibilityLabel(type: SampleDrinkTypes.water(context), dates: testDay)
        XCTAssertEqual(r4, "Data representing your Water intake on Apr 8, 2022.")
        
        // Test for April 3-9, 2022 Week for Water Type
        let r5 = model.getChartAccessibilityLabel(type: SampleDrinkTypes.water(context), dates: testWeek)
        XCTAssertEqual(r5, "Data representing your Water intake from Apr 3rd to 9th, 2022.")
        
        // Test for April 2022 Month for Water Type
        let r6 = model.getChartAccessibilityLabel(type: SampleDrinkTypes.water(context), dates: testMonth)
        XCTAssertEqual(r6, "Data representing your Water intake on April 2022.")
        
        // Test for Nov 2021 to Apr 2022 Half Year for Water Type
        let r7 = model.getChartAccessibilityLabel(type: SampleDrinkTypes.water(context), dates: testHalfYear)
        XCTAssertEqual(r7, "Data representing your Water intake from Nov 2021 to Apr 2022.")

        // Test for May 2021 to Apr 2022 Year for Water Type
        let r8 = model.getChartAccessibilityLabel(type: SampleDrinkTypes.water(context), dates: testYear)
        XCTAssertEqual(r8, "Data representing your Water intake from May 2021 to Apr 2022.")
    }
}
