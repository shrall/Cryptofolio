//
//  ContentView.swift
//  cryptofolio
//
//  Created by Marshall Kurniawan on 02/05/22.
//

import SwiftUI

struct ContentView: View {
    @State private var tabSelection = 1
    var body: some View {
        NavigationView {
            TabView(selection: $tabSelection) {
                PortfolioView()
                MarketView()
            }
            .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
