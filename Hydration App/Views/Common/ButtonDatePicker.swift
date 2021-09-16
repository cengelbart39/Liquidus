//
//  ButtonDatePicker.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/16/21.
//
//  Code credited to chase (https://developer.apple.com/forums/thread/650433?answerId=624094022#624094022)

import SwiftUI

struct ButtonDatePicker: View {
    
    @Binding var selectedDate: Date
    
    var body: some View {

        DatePicker("label", selection: $selectedDate, in: ...Date(), displayedComponents: [.date])
            .datePickerStyle(CompactDatePickerStyle())
            .labelsHidden()
    }
    
}

struct ButtonDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        ButtonDatePicker(selectedDate: .constant(Date()))
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
