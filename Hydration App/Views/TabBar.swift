//
//  TabBar.swift
//  Hydration App
//
//  Created by Christopher Engelbart on 9/6/21.
//

import SwiftUI

struct TabBar: View {
    
    @EnvironmentObject var model: DrinkModel
    
    var body: some View {
        
        if model.weeksPopulated {
            TabView {
                
                StatsView()
                    .tabItem {
                        VStack {
                            Image(systemName: "drop.fill")
                            Text("Stats")
                        }
                    }
                    .tag(0)
                
                DataLogsView()
                    .tabItem {
                        VStack {
                            Image(systemName: "list.bullet")
                            Text("Logs")
                        }
                    }
                    .tag(1)
                
                SettingsView()
                    .tabItem {
                        VStack {
                            Image(systemName: "gearshape.fill")
                            Text("Settings")
                        }
                    }
                    .tag(2)
            }
        }
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}
