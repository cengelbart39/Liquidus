//
//  IntakeWidget.swift
//  IntakeWidget
//
//  Created by Christopher Engelbart on 1/15/22.
//

import WidgetKit
import SwiftUI

@main
struct IntakeWidget: Widget {
    let kind: String = "IntakeWidget"
    
    let context = PersistenceController.shared.container.viewContext

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WidgetView(entry: entry)
                .environment(\.managedObjectContext, context)
                .environmentObject(DrinkModel(test: false, suiteName: nil))
        }
        .configurationDisplayName("Daily Intake Widget")
        .description("See your daily intake. ")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}
