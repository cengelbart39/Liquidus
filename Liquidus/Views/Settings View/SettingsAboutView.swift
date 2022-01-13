//
//  SettingsAboutView.swift
//  Liquidus
//
//  Created by Christopher Engelbart on 1/12/22.
//

import SwiftUI

struct SettingsAboutView: View {
    var body: some View {
        Form {
            // MARK: - About Me
            Section(header: Text("About Me")) {
                Text("Developed by Christopher Engelbart")
                
                Text("A college student from New Jersey studying for a degree in Computer Science")
            }
            
            // MARK: - Challenge
            Section(header: Text("Challenge")) {
                Text("Developed for the CodeCrew HealthKit Community Challenge")
                
                Link(destination: URL(string: "https://codecrew.codewithchris.com/t/healthkit-community-app-challenge/14547")!) {
                    Label {
                        Text("HealthKit Community Challenge")
                            .foregroundColor(.primary)
                    } icon: {
                        Image(systemName: "safari")
                    }
                }
            }
            
            // MARK: - Special Thanks
            Section(header: Text("Special Thanks")) {
                Text("Special Thanks to CodeWithChris and the CodeCrew Community for helping me through this journey")
                
                Link(destination: URL(string: "https://codewithchris.com")!) {
                    Label {
                        Text("CodeWithChris")
                            .foregroundColor(.primary)
                    } icon: {
                        Image(systemName: "safari")
                    }
                }
                
                Link(destination: URL(string: "https://codecrew.codewithchris.com")!) {
                    Label {
                        Text("CodeCrew Community")
                            .foregroundColor(.primary)
                    } icon: {
                        Image(systemName: "safari")
                    }
                }
            }
        }
        .navigationTitle("About")
    }
}

struct SettingsAboutView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsAboutView()
    }
}
