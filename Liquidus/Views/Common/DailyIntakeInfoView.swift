//
//  DailyIntakeInfoView.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 10/11/21.
//

import SwiftUI

struct DailyIntakeInfoView: View {
    
    var color: Color
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .foregroundColor(color)
                .ignoresSafeArea()
            
            VStack {
                VStack(alignment: .leading) {
                    Text("The United States National Academies of Sciences, Engineering, and Medicine determined that an adequate daily fluid intake is (based on biological gender):")
                        .padding(.bottom, 10)
                    
                    Label("15.5 cups / 124 fl oz / 3.7 L / 3,700 mL for Men", systemImage: "circle.fill")
                        .padding(.bottom, 10)
                    
                    Label("11.5 cups / 92 fl oz / 2.7 L / 2,700 mL for Women", systemImage: "circle.fill")
                        .padding(.bottom)
                    
                    Text("Sourced from the Mayo Clinic")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.top)
                .padding(.horizontal, 40)
                
                Spacer()
            }
            .multilineTextAlignment(.leading)
        }
    }
}

struct DailyIntakeInfoView_Previews: PreviewProvider {
    static var previews: some View {
        DailyIntakeInfoView(color: Color(.systemGray6))
    }
}
