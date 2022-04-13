//
//  WidgetView.swift
//  IntakeWidgetExtension
//
//  Created by Christopher Engelbart on 1/15/22.
//

import WidgetKit
import SwiftUI

struct WidgetView : View {
    
    @EnvironmentObject var model: DrinkModel
    
    @Environment(\.widgetFamily) var widgetFamily
    
    var entry: Provider.Entry

    var body: some View {
        switch widgetFamily {
        case .systemMedium:
            MediumWidgetView(entry: entry)
                .onReceive(NotificationCenter.default.publisher(for: UIAccessibility.grayscaleStatusDidChangeNotification)) { _ in
                    model.grayscaleEnabled.toggle()
                }
                .onAppear {
                    model.grayscaleEnabled = UIAccessibility.isGrayscaleEnabled
                }
            
        case .systemLarge:
            LargeWidgetView(entry: entry)
                .onReceive(NotificationCenter.default.publisher(for: UIAccessibility.grayscaleStatusDidChangeNotification)) { _ in
                    model.grayscaleEnabled.toggle()
                }
                .onAppear {
                    model.grayscaleEnabled = UIAccessibility.isGrayscaleEnabled
                }
            
        default:
            MediumWidgetView(entry: entry)
                .onReceive(NotificationCenter.default.publisher(for: UIAccessibility.grayscaleStatusDidChangeNotification)) { _ in
                    model.grayscaleEnabled.toggle()
                }
                .onAppear {
                    model.grayscaleEnabled = UIAccessibility.isGrayscaleEnabled
                }
        }
    }
}
