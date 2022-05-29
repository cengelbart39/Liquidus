//
//  Provider.swift
//  IntakeWidgetExtension
//
//  Created by Christopher Engelbart on 1/15/22.
//

import WidgetKit

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), relevance: nil)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), relevance: nil)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of four entries three hours apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0...3 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: 3*hourOffset, to: currentDate)!
            let relevance = TimelineEntryRelevance(score: getScore(date: entryDate))
            let entry = SimpleEntry(date: entryDate, relevance: relevance)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    /**
     Get the Relevance Score for the Widget
     - Parameters:
        - timePeriod: The selected time period
        - date: The current day
     - Returns: A Score relative to the user's goal and the amount consumed on `date`
     - Note: `0` is always returned if data cannot be fetched
     */
    private func getScore(date: Date) -> Float {
        if let userDefaults = UserDefaults(suiteName: Constants.sharedKey) {
            if let data = userDefaults.data(forKey: Constants.savedKey) {
                if let decoded = try? JSONDecoder().decode(DrinkData.self, from: data) {
                    
                    let goal = decoded.dailyGoal
                    
                    let amount = IntentLogic.getTotalAmountByDay(date: date, data: decoded)
                    
                    if amount > goal {
                        return Float(goal) + Float(amount)
                    } else {
                        return Float(goal) - Float(amount)
                    }
                }
            }
        }
        
        return 0
    }
}
