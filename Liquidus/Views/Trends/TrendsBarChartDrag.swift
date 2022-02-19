//
//  TrendsBarChartDrag.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 2/18/22.
//

import SwiftUI

extension TrendsBarChart {
    var drag: some Gesture {
        DragGesture()
            .onEnded { value in
                // If translation is right-to-left update selectedDay if the day is today or happened
                if value.translation.width < 0 {
                    // If advancing a day/week/month/half-year, check if the day has happened yet
                    // If it has happened update the appropriate property, if not, don't
                    if selectedTimePeriod == .daily && !model.isTomorrow(currentDate: selectedDay) {
                        if let newDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDay) {
                            if reduceMotion {
                                selectedDay = newDate
                            } else {
                                withAnimation(.spring()) {
                                    selectedDay = newDate
                                }
                            }
                        }
                    } else if selectedTimePeriod == .weekly && !model.isNextWeek(currentWeek: selectedWeek) {
                        if let newWeek = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: self.selectedWeek[0]) {
                            if reduceMotion {
                                selectedWeek = model.getDaysInWeek(date: newWeek)
                            } else {
                                withAnimation(.spring()) {
                                    selectedWeek = model.getDaysInWeek(date: newWeek)
                                }
                            }
                        }
                    } else if selectedTimePeriod == .monthly && !model.isNextMonth(currentMonth: selectedMonth) {
                        if let newMonth = Calendar.current.date(byAdding: .month, value: 1, to: self.selectedMonth[0]) {
                            if reduceMotion {
                                selectedMonth = model.getMonth(day: newMonth)
                            } else {
                                withAnimation(.spring()) {
                                    selectedMonth = model.getMonth(day: newMonth)
                                }
                            }
                        }
                    } else if selectedTimePeriod == .halfYearly && !model.isNextHalfYear(currentHalfYear: selectedHalfYear) {
                        if let lastMonth = selectedHalfYear.last {
                            if let newMonth = Calendar.current.date(byAdding: .month, value: 1, to: lastMonth[0]) {
                                if reduceMotion {
                                    selectedHalfYear = model.getHalfYear(date: newMonth)
                                } else {
                                    withAnimation(.spring()) {
                                        selectedHalfYear = model.getHalfYear(date: newMonth)
                                    }
                                }
                            }
                        }
                    } else if selectedTimePeriod == .yearly && !model.isNextYear(currentYear: selectedYear) {
                        if let lastMonth = selectedYear.last {
                            if let newMonth = Calendar.current.date(byAdding: .month, value: 1, to: lastMonth[0]) {
                                if reduceMotion {
                                    selectedYear = model.getYear(date: newMonth)
                                } else {
                                    withAnimation(.spring()) {
                                        selectedYear = model.getYear(date: newMonth)
                                    }
                                }
                            }
                        }
                    }
                // If translation is left-to-right update selectedDay
                // If going back a day/week/month/half-year update
                // appropriate selected- property
                } else if value.translation.width > 0 {
                    if selectedTimePeriod == .daily {
                        if let newDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDay) {
                            if reduceMotion {
                                selectedDay = newDate
                            } else {
                                withAnimation(.spring()) {
                                    selectedDay = newDate
                                }
                            }
                        }
                    } else if selectedTimePeriod == .weekly {
                        if let newWeek = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: self.selectedWeek[0]) {
                            if reduceMotion {
                                selectedWeek = model.getDaysInWeek(date: newWeek)
                            } else {
                                withAnimation(.spring()) {
                                    selectedWeek = model.getDaysInWeek(date: newWeek)
                                }
                            }
                        }
                    } else if selectedTimePeriod == .monthly {
                        if let newMonth = Calendar.current.date(byAdding: .month, value: -1, to: self.selectedMonth[0]) {
                            if reduceMotion {
                                selectedMonth = model.getMonth(day: newMonth)
                            } else {
                                withAnimation(.spring()) {
                                    selectedMonth = model.getMonth(day: newMonth)
                                }
                            }
                        }
                    } else if selectedTimePeriod == .halfYearly {
                        if let lastMonth = selectedHalfYear.last {
                            if let newMonth = Calendar.current.date(byAdding: .month, value: -1, to: lastMonth[0]) {
                                if reduceMotion {
                                    selectedHalfYear = model.getHalfYear(date: newMonth)
                                } else {
                                    withAnimation(.spring()) {
                                        selectedHalfYear = model.getHalfYear(date: newMonth)
                                    }
                                }
                            }
                        }
                    } else if selectedTimePeriod == .yearly {
                        if let lastMonth = selectedYear.last {
                            if let newMonth = Calendar.current.date(byAdding: .month, value: -1, to: lastMonth[0]) {
                                if reduceMotion {
                                    selectedYear = model.getYear(date: newMonth)
                                } else {
                                    withAnimation(.spring()) {
                                        selectedYear = model.getYear(date: newMonth)
                                    }
                                }
                            }
                        }
                    }
                }
                self.isHeaderFocused = true
            }
    }
}
