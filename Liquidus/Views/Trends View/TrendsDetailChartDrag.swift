//
//  TrendsDetailChartDrag.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 2/18/22.
//

import SwiftUI

extension TrendsDetailView {
    var drag: some Gesture {
        DragGesture()
            .onEnded { value in
                print("x: \(value.translation.width), y: \(value.translation.height)")
                // If translation is right-to-left update selectedDay if the day is today or happened
                if value.translation.width < 0 {
                    // If advancing a day/week/month/half-year, check if the day has happened yet
                    // If it has happened update the appropriate property, if not, don't
                    if selectedTimePeriod == .daily && !selectedDay.isTomorrow() {
                        
                        if reduceMotion {
                            selectedDay.nextDay()
                            
                        } else {
                            withAnimation(.spring()) {
                                selectedDay.nextDay()
                            }
                        }
                    } else if selectedTimePeriod == .weekly && !selectedWeek.isNextWeek() {
                        
                        if reduceMotion {
                            selectedWeek.nextWeek()
                            
                        } else {
                            withAnimation(.spring()) {
                                selectedWeek.nextWeek()
                            }
                        }
                        
                        monthOffset += 1
                        
                    } else if selectedTimePeriod == .monthly && !selectedMonth.isNextMonth() {
                        
                        if reduceMotion {
                            selectedMonth.nextMonth()
                            
                        } else {
                            withAnimation(.spring()) {
                                selectedMonth.nextMonth()
                            }
                        }
                        
                    } else if selectedTimePeriod == .halfYearly && !selectedHalfYear.isNextHalfYear() {
                        
                        if reduceMotion {
                            selectedHalfYear.nextHalfYear()
                            
                        } else {
                            withAnimation(.spring()) {
                                selectedHalfYear.nextHalfYear()
                            }
                        }

                        halfYearOffset += 1
        
                    } else if selectedTimePeriod == .yearly && !selectedYear.isNextYear() {
                        
                        if reduceMotion {
                            selectedYear.nextYear()
                            
                        } else {
                            withAnimation(.spring()) {
                                selectedYear.nextYear()
                            }
                        }
                    }
                    // If translation is left-to-right update selectedDay
                    // If going back a day/week/month/half-year update
                    // appropriate selected- property
                } else if value.translation.width > 0 {
                    if selectedTimePeriod == .daily {
                        
                        if reduceMotion {
                            selectedDay.prevDay()
                            
                        } else {
                            withAnimation(.spring()) {
                                selectedDay.prevDay()
                            }
                        }
                    } else if selectedTimePeriod == .weekly {
                            
                        if reduceMotion {
                            selectedWeek.prevWeek()
                            
                        } else {
                            withAnimation(.spring()) {
                                selectedWeek.prevWeek()
                            }
                        }
                        
                        monthOffset -= 1

                    } else if selectedTimePeriod == .monthly {
                        
                        if reduceMotion {
                            selectedMonth.prevMonth()
                            
                        } else {
                            withAnimation(.spring()) {
                                selectedMonth.prevMonth()
                            }
                        }
                        
                    } else if selectedTimePeriod == .halfYearly {

                        if reduceMotion {
                            selectedHalfYear.prevHalfYear()
                        } else {
                            withAnimation(.spring()) {
                                selectedHalfYear.prevHalfYear()
                            }
                        }
                        
                        halfYearOffset -= 1

                    } else if selectedTimePeriod == .yearly {
                        
                        if reduceMotion {
                            selectedYear.prevYear()
                            
                        } else {
                            withAnimation(.spring()) {
                                selectedYear.prevYear()
                            }
                        }
                    }
                }
                
                self.hiddenTrigger.toggle()
                self.isHeaderFocused = true
            }
    }
}
