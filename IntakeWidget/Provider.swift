//
//  Provider.swift
//  IntakeWidgetExtension
//
//  Created by Christopher Engelbart on 1/15/22.
//

import WidgetKit

struct Provider: IntentTimelineProvider {
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), relevance: nil, timePeriod: .daily)
    }

    func getSnapshot(for configuration: ViewIntakeIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), relevance: nil, timePeriod: .daily)
        completion(entry)
    }

    func getTimeline(for configuration: ViewIntakeIntent, in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        var entries: [SimpleEntry] = []

        let selectedTimePeriod = timePeriod(for: configuration)
        
        // Generate a timeline consisting of four entries three hours apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0...3 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: 3*hourOffset, to: currentDate)!
            let relevance = TimelineEntryRelevance(score: getScore(timePeriod: selectedTimePeriod, date: entryDate))
            let entry = SimpleEntry(date: entryDate, relevance: relevance, timePeriod: selectedTimePeriod)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    /**
     Convert the `timePeriod` in `ViewIntakeIntent` to `TimePeriod`
     - Parameter configuration: A `ViewIntakeIntent`
     - Returns: `TimePeriod` equivalent with `configuration`
     */
    private func timePeriod(for configuration: ViewIntakeIntent) -> TimePeriod {
        switch configuration.timePeriod {
        case .day:
            return .daily
        case .week:
            return .weekly
        default:
            return .daily
        }
    }
    
    /**
     Get the Relevance Score for the Widget
     - Parameters:
        - timePeriod: The selected time period
        - date: The current day
     - Returns: A Score relative to the user's goal and the amount consumed on `date`
     - Note: `0` is always returned if data cannot be fetched
     */
    private func getScore(timePeriod: TimePeriod, date: Date) -> Float {
        if let userDefaults = UserDefaults(suiteName: Constants.sharedKey) {
            if let data = userDefaults.data(forKey: Constants.savedKey) {
                if let decoded = try? JSONDecoder().decode(DrinkData.self, from: data) {
                    if timePeriod == .daily {
                        let goal = decoded.dailyGoal
                        
                        let amount = IntentLogic.getTotalAmountByDay(date: date, data: decoded)
                        
                        if amount > goal {
                            return Float(goal) + Float(amount)
                        } else {
                            return Float(goal) - Float(amount)
                        }
                        
                    } else {
                        let goal = decoded.dailyGoal*7
                        
                        let amount = IntentLogic.getTotalAmountByWeek(week: IntentLogic.getDaysInWeek(date: date), data: decoded)
                        
                        if amount > goal {
                            return Float(goal) + Float(amount)
                        } else {
                            return Float(goal) - Float(amount)
                        }
                    }
                }
            }
        }
        
        return 0
    }
}
