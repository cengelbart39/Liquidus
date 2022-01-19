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

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: TimePeriodSelectionIntent.self, provider: Provider(), content: { entry in
            WidgetView(entry: entry)
                .environmentObject(DrinkModel())
        })
        .configurationDisplayName("Intake Widget")
        .description("See your daily or weekly intake. ")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}
