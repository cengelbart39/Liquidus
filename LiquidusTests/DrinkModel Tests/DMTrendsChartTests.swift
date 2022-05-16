//
//  DMTrendsChartTests.swift
//  LiquidusTests
//
//  Created by Christopher Engelbart on 5/4/22.
//

import XCTest
@testable import Liquidus

class DMTrendsChartTests: XCTestCase {

    var model: DrinkModel!

    override func setUp() {
        self.model = DrinkModel(test: true, suiteName: nil)
    }
    
    override func tearDown() {
        self.model = nil
    }

    func testTimePeriodText() {
        // Day Test
        // Get a date for April 8, 2022
        let testDay = Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!
        
        // Get function return
        let testDayText = model.timePeriodText(timePeriod: .daily, dates: testDay)
        
        // Get expected result
        let expectedDayText = "April 8, 2022"
        
        // Assert they are equal
        XCTAssertEqual(testDayText, expectedDayText)
        
        // Week Test
        // Get the week of April 8, 2022 (April 3-9, 2022)
        let testWeek = model.getWeek(date: testDay)
        
        // Get function return
        let testWeekText = model.timePeriodText(timePeriod: .weekly, dates: testWeek)
        
        // Get expected result
        let expectedWeekText = "Apr 3-9, 2022"
        
        // Assert they are equal
        XCTAssertEqual(testWeekText, expectedWeekText)
        
        // Month Test
        // Get the month of April 2022
        let testMonth = model.getMonth(day: testDay)
        
        // Get function return
        let testMonthText = model.timePeriodText(timePeriod: .monthly, dates: testMonth)
        
        // Get expected result
        let expectedMonthText = "April 2022"
        
        // Assert they are equal
        XCTAssertEqual(testMonthText, expectedMonthText)
        
        // Half Year Test
        // Get the half year from Nov 2021 to April 2022
        let testHalfYear = model.getHalfYear(date: testDay)
        
        // Get function return
        let testHalfYearText = model.timePeriodText(timePeriod: .halfYearly, dates: testHalfYear)
        
        // Get expected result
        let expectedHalfYearText = "Nov 2021 - Apr 2022"
        
        // Assert they are equal
        XCTAssertEqual(testHalfYearText, expectedHalfYearText)
        
        // Year Test
        // Get the year from May 2021 to April 2022
        let testYear = model.getYear(date: testDay)
        
        // Get function return
        let testYearText = model.timePeriodText(timePeriod: .yearly, dates: testYear)
        
        // Get expected result
        let expectedYearText = "May 2021 - Apr 2022"
        
        // Assert they are equal
        XCTAssertEqual(testYearText, expectedYearText)
    }
    
    func testGetOverallAmount() {
        // Day Tests
        // Get a date for April 8, 2022
        let testDay = Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!

        // Add sample drinks for the day
        model.drinkData.drinks = SampleDrinks.day(testDay)
                
        // Assert Water returns 1,950
        XCTAssertEqual(model.getOverallAmount(type: model.drinkData.drinkTypes[0], timePeriod: .daily, dates: testDay), 1950.0)
        
        // Assert Coffee returns 1,950
        XCTAssertEqual(model.getOverallAmount(type: model.drinkData.drinkTypes[1], timePeriod: .daily, dates: testDay), 1950.0)
        
        // Assert Soda returns 1,950
        XCTAssertEqual(model.getOverallAmount(type: model.drinkData.drinkTypes[2], timePeriod: .daily, dates: testDay), 1950.0)

        // Assert Juice returns 1,950
        XCTAssertEqual(model.getOverallAmount(type: model.drinkData.drinkTypes[3], timePeriod: .daily, dates: testDay), 1950.0)

        // Week Tests
        // Get the week of April 8, 2022 (Apr 3-9, 2022)
        let testWeek = model.getWeek(date: testDay)
        
        // Add sample drinks for the week
        model.drinkData.drinks = SampleDrinks.week(testWeek)
        
        // Assert Water return 400.0
        XCTAssertEqual(model.getOverallAmount(type: model.drinkData.drinkTypes[0], timePeriod: .weekly, dates: testWeek), 400.0)
        
        // Assert Coffee return 400.0
        XCTAssertEqual(model.getOverallAmount(type: model.drinkData.drinkTypes[1], timePeriod: .weekly, dates: testWeek), 400.0)
        
        // Assert Soda return 400.0
        XCTAssertEqual(model.getOverallAmount(type: model.drinkData.drinkTypes[2], timePeriod: .weekly, dates: testWeek), 400.0)
        
        // Assert Juice return 400.0
        XCTAssertEqual(model.getOverallAmount(type: model.drinkData.drinkTypes[3], timePeriod: .weekly, dates: testWeek), 400.0)

        // Month Test
        // Get the month of April 2022
        let testMonth = model.getMonth(day: testDay)

        // Add sample drinks for the month
        model.drinkData.drinks = SampleDrinks.month(testMonth)

        // Assert Water return 3,200
        XCTAssertEqual(model.getOverallAmount(type: model.drinkData.drinkTypes[0], timePeriod: .monthly, dates: testMonth), 3200.0)
        
        // Assert Coffee return 3,200
        XCTAssertEqual(model.getOverallAmount(type: model.drinkData.drinkTypes[1], timePeriod: .monthly, dates: testMonth), 3200.0)
        
        // Assert Soda return 3,150
        XCTAssertEqual(model.getOverallAmount(type: model.drinkData.drinkTypes[2], timePeriod: .monthly, dates: testMonth), 3150.0)
        
        // Assert Juice return 3,200
        XCTAssertEqual(model.getOverallAmount(type: model.drinkData.drinkTypes[3], timePeriod: .monthly, dates: testMonth), 3200.0)

        // Half Year Tests
        // Get the half year for Nov 2021 to Apr 2022
        let testHalfYear = model.getHalfYear(date: testDay)

        // Add sample drinks for the half year
        model.drinkData.drinks = SampleDrinks.halfYear(testHalfYear)
        
        // Assert Water returns 10,400
        XCTAssertEqual(model.getOverallAmount(type: model.drinkData.drinkTypes[0], timePeriod: .halfYearly, dates: testHalfYear), 10400.0)

        // Assert Coffee returns 10,300
        XCTAssertEqual(model.getOverallAmount(type: model.drinkData.drinkTypes[1], timePeriod: .halfYearly, dates: testHalfYear), 10300.0)

        // Assert Soda returns 10,400
        XCTAssertEqual(model.getOverallAmount(type: model.drinkData.drinkTypes[2], timePeriod: .halfYearly, dates: testHalfYear), 10400.0)

        // Assert Juice returns 10,400
        XCTAssertEqual(model.getOverallAmount(type: model.drinkData.drinkTypes[3], timePeriod: .halfYearly, dates: testHalfYear), 10400.0)
        
        // Year Tests
        // Get the year for May 2021 to Apr 2022
        let testYear = model.getYear(date: testDay)

        // Add sample drinks for the year
        model.drinkData.drinks = SampleDrinks.year(testYear)

        // Assert Water returns 19,050
        XCTAssertEqual(model.getOverallAmount(type: model.drinkData.drinkTypes[0], timePeriod: .halfYearly, dates: testHalfYear), 19050.0)

        // Assert Coffee returns 19,050
        XCTAssertEqual(model.getOverallAmount(type: model.drinkData.drinkTypes[1], timePeriod: .halfYearly, dates: testHalfYear), 19050.0)

        // Assert Soda returns 19,100
        XCTAssertEqual(model.getOverallAmount(type: model.drinkData.drinkTypes[2], timePeriod: .halfYearly, dates: testHalfYear), 19100.0)

        // Assert Juice returns 19,250
        XCTAssertEqual(model.getOverallAmount(type: model.drinkData.drinkTypes[3], timePeriod: .halfYearly, dates: testHalfYear), 19250.0)
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
        XCTAssertEqual(model.chartSpacerMaxWidth(timePeriod: .halfYearly, isWidget: false), CGFloat(5))
        XCTAssertEqual(model.chartSpacerMaxWidth(timePeriod: .yearly, isWidget: false), CGFloat(5))
    }
    
    func testGetMaxValue() {
        // Day Test
        // Create a date for April 8, 2022
        let testDay = Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!
        
        // Get sample data items for this day
        let dayItems = SampleDataItems.day(testDay)
        
        // Get function return
        let dayMax = model.getMaxValue(dataItems: dayItems, timePeriod: .daily)
        
        // Assert function returns 600
        XCTAssertEqual(dayMax, 600.0)
        
        // Week Test
        // Get the week of April 8, 2022 (April 3-9, 2022)
        let testWeek = model.getWeek(date: testDay)
        
        // Get sample data items for this week
        let weekItems = SampleDataItems.week(testWeek)
        
        // Get function return
        let weekMax = model.getMaxValue(dataItems: weekItems, timePeriod: .weekly)
        
        // Assert function returns 400
        XCTAssertEqual(weekMax, 400.0)
        
        // Month Test
        // Get the month of April 2022
        let testMonth = model.getMonth(day: testDay)
        
        // Get sample data items for the month
        let monthItems = SampleDataItems.month(testMonth)
        
        // Get the function return
        let monthMax = model.getMaxValue(dataItems: monthItems, timePeriod: .monthly)
        
        // Assert function returns 800
        XCTAssertEqual(monthMax, 800.0)
        
        // Half Year Test
        // Get the half year from Nov 2021 to Apr 2022
        let testHalfYear = model.getHalfYear(date: testDay)
        
        // Get sample data items for the half year
        let halfYearItems = SampleDataItems.halfYear(testHalfYear)
        
        // Get function return
        let halfYearMax = model.getMaxValue(dataItems: halfYearItems, timePeriod: .halfYearly)
        
        // Assert function returns 1,600
        XCTAssertEqual(halfYearMax, 1600.0)
        
        // Year Test
        // Get the year for May 2021 to April 2022
        let testYear = model.getYear(date: testDay)
        
        // Get sample data items for the year
        let yearItems = SampleDataItems.year(testYear)
        
        // Get the function return
        let yearMax = model.getMaxValue(dataItems: yearItems, timePeriod: .yearly)
        
        // Assert the function returns 12,800
        XCTAssertEqual(yearMax, 12800.0)
    }
    
    func testGetAverage() {
        // Create a date for April 8, 2022
        let testDay = Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!
        
        // Week Test
        // Get the week for April 8, 2022 (April 3-9, 2022)
        let testWeek = model.getWeek(date: testDay)
        
        // Get sample data items for this week
        let weekItems = SampleDataItems.week(testWeek)
        
        // Get function return
        let weekResult = model.getAverage(dataItems: weekItems, timePeriod: .weekly)
        
        // Set expected result
        let weekExpected = 1600.0/7.0
        
        // Assert function returns expected
        XCTAssertEqual(weekResult, weekExpected)
        
        // Month Test
        // Get the month of April 2022
        let testMonth = model.getMonth(day: testDay)
        
        // Get sample data items for the month
        let monthItems = SampleDataItems.month(testMonth)
        
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
        let testDay = Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!
        
        // Get sample data items for the day
        let dayItems = SampleDataItems.day(testDay)
        
        // Get function return
        let dayResult = model.verticalAxisText(dataItems: dayItems, timePeriod: .daily)
        
        // Assert the function returns the expected result
        XCTAssertEqual(dayResult, ["12A","6A","12P","6P"])
        
        // Week Test
        // Get the week of April 8, 2022 (April 3-9, 2022)
        let testWeek = model.getWeek(date: testDay)
        
        // Get sample data items for the week
        let weekItems = SampleDataItems.week(testWeek)
        
        // Get function return
        let weekResult = model.verticalAxisText(dataItems: weekItems, timePeriod: .weekly)
        
        // Assert the function returns the expected result
        XCTAssertEqual(weekResult, ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"])
        
        // Month Test
        // Get the month of April 2022
        let testMonth = model.getMonth(day: testDay)
        
        // Get sample data items for the month
        let monthItems = SampleDataItems.month(testMonth)
        
        // Get function return
        let monthResult = model.verticalAxisText(dataItems: monthItems, timePeriod: .monthly)
        
        // Assert the function returns the expected result
        XCTAssertEqual(monthResult, ["0", "6", "12", "18", "24"])
        
        // Half Year Test
        // Get the half year of Nov 2021 to Apr 2022
        let testHalfYear = model.getHalfYear(date: testDay)
        
        // Get sample data items for the half year
        let halfYearItems = SampleDataItems.halfYear(testHalfYear)
        
        // Get function return
        let halfYearResult = model.verticalAxisText(dataItems: halfYearItems, timePeriod: .halfYearly)
        
        // Assert the function returns the expected result
        XCTAssertEqual(halfYearResult, ["Nov", "Dec", "Jan", "Feb", "Mar", "Apr"])
        
        // Year Test
        // Get the year of May 2021 to Apr 2022
        let testYear = model.getYear(date: testDay)
        
        // Get sample data items for the year
        let yearItems = SampleDataItems.year(testYear)
        
        // Get function return
        let yearResult = model.verticalAxisText(dataItems: yearItems, timePeriod: .yearly)
        
        // Assert the function returns the expected result
        XCTAssertEqual(yearResult, ["May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec", "Jan", "Feb", "Mar", "Apr"])
    }
    
    func testHorizontalAxisText() {
        // Day Test
        // Create a date for April 8, 2022
        let testDay = Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!
        
        // Get sample data items for the day
        let dayItems = SampleDataItems.day(testDay)
        
        // Add sample drinks for the day
        model.drinkData.drinks = SampleDrinks.day(testDay)
        
        // Get function return
        let dayResult = model.horizontalAxisText(dataItems: dayItems, type: Constants.totalType, timePeriod: .daily, dates: testDay)
        
        // Set expected result
        let dayExpected = ["7,800", "5,200", "2,600", "0"]
        
        // Assert the function returns the expected result
        XCTAssertEqual(dayResult, dayExpected)
        
        // Week Test
        // Get the week of April 8, 2022 (April 3-9, 2022)
        let testWeek = model.getWeek(date: testDay)
        
        // Get sample data items for the week
        let weekItems = SampleDataItems.week(testWeek)
        
        // Add sample drinks for the week
        model.drinkData.drinks = SampleDrinks.week(testWeek)
        
        // Get function return
        let weekResult = model.horizontalAxisText(dataItems: weekItems, type: Constants.totalType, timePeriod: .weekly, dates: testWeek)
        
        // Set expected result
        let weekExpected = ["1,800", "1,200", "600", "0"]
        
        // Assert the function returns the expected result
        XCTAssertEqual(weekResult, weekExpected)
        
        // Month Test
        // Get the month of April 2022
        let testMonth = model.getMonth(day: testDay)
        
        // Get sample data items for the month
        let monthItems = SampleDataItems.month(testMonth)
        
        // Add sample drinks for the month
        model.drinkData.drinks = SampleDrinks.month(testMonth)
        
        // Get function return
        let monthResult = model.horizontalAxisText(dataItems: monthItems, type: Constants.totalType, timePeriod: .monthly, dates: testMonth)
        
        // Set expected result
        let monthExpected = ["13,000", "8,500", "4,200", "0"]
        
        // Assert the function returns the expected result
        XCTAssertEqual(monthResult, monthExpected)
        
        // Half Year Test
        // Get the half year of Nov 2021 to Apr 2022
        let testHalfYear = model.getHalfYear(date: testDay)
        
        // Get sample data items for the half year
        let halfYearItems = SampleDataItems.halfYear(testHalfYear)
        
        // Add sample drinks for the half year
        model.drinkData.drinks = SampleDrinks.halfYear(testHalfYear)
        
        // Get function return
        let halfYearResult = model.horizontalAxisText(dataItems: halfYearItems, type: Constants.totalType, timePeriod: .halfYearly, dates: testHalfYear)
        
        // Set expected result
        let halfYearExpected = ["42,000", "28,000", "14,000", "0"]
        
        // Assert the function returns the expected result
        XCTAssertEqual(halfYearResult, halfYearExpected)
        
        // Year Test
        // Get the year of May 2021 to Apr 2022
        let testYear = model.getYear(date: testDay)
        
        // Get sample data items for the year
        let yearItems = SampleDataItems.year(testYear)
        
        // Add sample drinks for the year
        model.drinkData.drinks = SampleDrinks.year(testYear)
        
        // Get function return
        let yearResult = model.horizontalAxisText(dataItems: yearItems, type: Constants.totalType, timePeriod: .yearly, dates: testYear)
        
        // Set expected result
        let yearExpected = ["150,000", "100,000", "51,000", "0"]
        
        // Assert the function returns the expected result
        XCTAssertEqual(yearResult, yearExpected)
    }
    
    func testSeriesDataPoints() {
        // Day Test
        // Create a date for April 8, 2022
        let testDay = Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!
        
        // Get sample data items for the day
        let dayItems = SampleDataItems.day(testDay)
        
        // Get function return
        let dayResult = model.seriesDataPoints(dataItems: dayItems, timePeriod: .daily, halfYearOffset: 0, test: true)
        
        // Get expected AXDataPoints
        let dayExpected = SampleAXDataPoints.day(testDay)
                
        // Assert at the same index the result and expected arrays return the same value
        for index in 0..<dayExpected.count {
            XCTAssertTrue(dayResult[index] == dayExpected[index], "failed at index \(index)")
        }
        
        // Week Test
        // Get the week of April 8, 2022 (April 3-9, 2022)
        let testWeek = model.getWeek(date: testDay)
        
        // Get sample data items for the week
        let weekItems = SampleDataItems.week(testWeek)
        
        // Get function return
        let weekResult = model.seriesDataPoints(dataItems: weekItems, timePeriod: .weekly, halfYearOffset: 0, test: true)
        
        // Get expected AXDataPoints
        let weekExpected = SampleAXDataPoints.week(testWeek)
        
        // Assert at the same index the result and expected arrays return the same value
        for index in 0..<weekExpected.count {
            XCTAssertTrue(weekResult[index] == weekExpected[index], "failed at index \(index)")
        }
        
        // Month Test
        // Get the month of April 2022
        let testMonth = model.getMonth(day: testDay)
        
        // Get sample data items for the month
        let monthItems = SampleDataItems.month(testMonth)
        
        // Get function return
        let monthResult = model.seriesDataPoints(dataItems: monthItems, timePeriod: .monthly, halfYearOffset: 0, test: true)
        
        // Get expected AXDataPoints
        let monthExpected = SampleAXDataPoints.month(testMonth)
        
        // Assert at the same index the result and expected arrays return the same value
        for index in 0..<monthExpected.count {
            XCTAssertTrue(monthResult[index] == monthExpected[index], "failed at index \(index)")
        }
        
        // Half Year Test
        // Get the half year of Nov 2021 to Apr 2022
        let testHalfYear = model.getHalfYear(date: testDay)
        
        // Get sample data items for the half year
        let halfYearItems = SampleDataItems.halfYear(testHalfYear)
        
        // Get half year offset
        let offset = Calendar.current.dateComponents([.month], from: testDay, to: .now).month!
        
        // Get function return
        let halfYearResult = model.seriesDataPoints(dataItems: halfYearItems, timePeriod: .halfYearly, halfYearOffset: offset, test: true)
        
        // Get expected AXDataPoints
        let halfYearExpected = SampleAXDataPoints.halfYear(testHalfYear)
        
        // Assert at the same index the result and expected arrays return the same value
        for index in 0..<halfYearExpected.count {
            XCTAssertTrue(halfYearResult[index] == halfYearExpected[index], "failed at index \(index)")
        }
        
        // Year Test
        // Get the year of May 2021 to Apr 2022
        let testYear = model.getYear(date: testDay)
        
        // Get sample data items for the year
        let yearItems = SampleDataItems.year(testYear)
        
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
        let testDate = Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!
        
        // Get sample data items for the day
        let dayItems = SampleDataItems.day(testDate)
        
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
        let testHalfYear = model.getHalfYear(date: testDate)
        
        // Get data items for the half year
        let halfYearItems = SampleDataItems.halfYear(testHalfYear)
        
        // Get the offset
        let offset = Calendar.current.dateComponents([.month], from: testDate, to: .now).month!
        
        // Assert the following items return the expected strings
        XCTAssertEqual(model.dataPointWeekRange(item: halfYearItems.first!, halfYearOffset: offset, test: true), "Nov 1st to 6th, 2021")
        
        XCTAssertEqual(model.dataPointWeekRange(item: halfYearItems[4], halfYearOffset: offset, test: true), "Nov 28th to Dec 4th, 2021")
        
        XCTAssertEqual(model.dataPointWeekRange(item: halfYearItems[8], halfYearOffset: offset, test: true), "Dec 26th, 2021 to Jan 1st, 2022")
        
        XCTAssertEqual(model.dataPointWeekRange(item: halfYearItems[13], halfYearOffset: offset, test: true), "Jan 30th to Feb 5th, 2022")
        
        XCTAssertEqual(model.dataPointWeekRange(item: halfYearItems[17], halfYearOffset: offset, test: true), "Feb 27th to Mar 5th, 2022")

        XCTAssertEqual(model.dataPointWeekRange(item: halfYearItems[21], halfYearOffset: offset, test: true), "Mar 27th to Apr 2nd, 2022")

        XCTAssertEqual(model.dataPointWeekRange(item: halfYearItems.last!, halfYearOffset: offset, test: true), "Apr 24th to 30th, 2022")
    }
    
    func testGetChartAccessibilityLabel() {
        // Test for Today for Total Type
        let r1 = model.getChartAccessibilityLabel(timePeriod: .daily, type: Constants.totalType, dates: Date.now)
        XCTAssertEqual(r1, "Data representing your intake Today")
        
        // Test for Today for Water Type
        let r2 = model.getChartAccessibilityLabel(timePeriod: .daily, type: model.drinkData.drinkTypes.first!, dates: Date.now)
        XCTAssertEqual(r2, "Data representing your Water intake Today")
        
        // Test for Yesterday for Water Type
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: .now)
        let r3 = model.getChartAccessibilityLabel(timePeriod: .daily, type: model.drinkData.drinkTypes.first!, dates: yesterday)
        XCTAssertEqual(r3, "Data representing your Water intake Yesterday")
        
        // Create day, week, month, half, and year from April 8, 2022
        let testDay = Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 8))!
        let testWeek = model.getWeek(date: testDay)
        let testMonth = model.getMonth(day: testDay)
        let testHalfYear = model.getHalfYear(date: testDay)
        let testYear = model.getYear(date: testDay)
        
        // Test for April 8, 2022 for Water Type
        let r4 = model.getChartAccessibilityLabel(timePeriod: .daily, type: model.drinkData.drinkTypes.first!, dates: testDay)
        XCTAssertEqual(r4, "Data representing your Water intake on April 8, 2022.")
        
        // Test for April 3-9, 2022 Week for Water Type
        let r5 = model.getChartAccessibilityLabel(timePeriod: .weekly, type: model.drinkData.drinkTypes.first!, dates: testWeek)
        XCTAssertEqual(r5, "Data representing your Water intake from Apr 3rd to 9th, 2022.")
        
        // Test for April 2022 Month for Water Type
        let r6 = model.getChartAccessibilityLabel(timePeriod: .monthly, type: model.drinkData.drinkTypes.first!, dates: testMonth)
        XCTAssertEqual(r6, "Data representing your Water intake on April 2022.")
        
        // Test for Nov 2021 to Apr 2022 Half Year for Water Type
        let r7 = model.getChartAccessibilityLabel(timePeriod: .halfYearly, type: model.drinkData.drinkTypes.first!, dates: testHalfYear)
        XCTAssertEqual(r7, "Data representing your Water intake from Nov 2021 to Apr 2022.")

        // Test for May 2021 to Apr 2022 Year for Water Type
        let r8 = model.getChartAccessibilityLabel(timePeriod: .yearly, type: model.drinkData.drinkTypes.first!, dates: testYear)
        XCTAssertEqual(r8, "Data representing your Water intake from May 2021 to Apr 2022.")
    }
}
