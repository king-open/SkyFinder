//
//  ContentView.swift
//  SkyFinder
//
//  Created by 不二 Jack on 2024/12/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            NavigationLink {
                FlightBookingView()
            } label: {
                Text("Book a Flight")
            }
        }
    }
}

#Preview {
    ContentView()
}
