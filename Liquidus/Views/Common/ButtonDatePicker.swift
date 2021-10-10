//
//  ButtonDatePicker.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 10/9/21.
//
//  Code credited to chase (https://developer.apple.com/forums/thread/650433?answerId=624094022#624094022)

import Foundation
import SwiftUI

struct ButtonDatePicker: View {
    
    @Binding var selectedDate: Date
    
    var body: some View {
        
        DatePicker("label", selection: $selectedDate, in: ...Date(), displayedComponents: [.date])
            .datePickerStyle(CompactDatePickerStyle())
            .labelsHidden()
        
    }
}

struct NoHitTesting: ViewModifier {
    func body(content: Content) -> some View {
        SwiftUIWrapper { content }.allowsHitTesting(false)
    }
}

extension View {
    func userInteractionDisabled() -> some View {
        self.modifier(NoHitTesting())
    }
}

struct SwiftUIWrapper<T: View>: UIViewControllerRepresentable {
    let content: () -> T
    func makeUIViewController(context: Context) -> UIHostingController<T> {
        UIHostingController(rootView: content())
    }
    func updateUIViewController(_ uiViewController: UIHostingController<T>, context: Context) {}
}
