//
//  ContentView.swift
//  cryptofolio
//
//  Created by Marshall Kurniawan on 02/05/22.
//

import SwiftUI

struct ContentView: View {
    init(){
        UITableView.appearance().backgroundColor = .clear
    }
    @State private var tabSelection = 1
    var body: some View {
        TabView(selection: $tabSelection) {
            NavigationView{
                PortfolioView()
                    .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
                
            }.tabItem {
                Label("Portfolio", systemImage: "chart.pie")
            }
            .tag(1)
            NavigationView{
                MarketView()
                    .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
                
            }.tabItem {
                Label("Market", systemImage: "chart.line.uptrend.xyaxis")
            }
            .tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
