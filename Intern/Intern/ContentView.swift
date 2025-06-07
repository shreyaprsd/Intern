//
//  ContentView.swift
//  Intern
//
//  Created by Shreya Prasad on 07/06/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            DataView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
       StoredView()
                .tabItem {
                    Label("Stored", systemImage: "list.dash")
                }
            
        }

            }
        }
    


#Preview {
    ContentView()
}
