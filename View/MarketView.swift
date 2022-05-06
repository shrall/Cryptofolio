//
//  MarketView.swift
//  cryptofolio
//
//  Created by Marshall Kurniawan on 02/05/22.
//

import SwiftUI

struct MarketView: View {
    @State private var searchText = ""
    @StateObject var apiService = APIService()
    var cryptos: [Crypto] {
        if searchText.isEmpty {
            return apiService.cryptos
        } else {
            return apiService.cryptos.filter {
                $0.name.contains(searchText)
            }
        }
    }
    
    var body: some View {
        List {
            ForEach(cryptos, id: \.self) { crypto in
                NavigationLink {
                    Text(String(format: "%.2f", crypto.current_price))
                } label: {
//                    CryptoCell(crypto: crypto, type: "market")
                }
            }
        }
        .searchable(text: $searchText)
        .navigationBarTitleDisplayMode(.inline).onAppear {
            apiService.fetchAll()
        }.tabItem {
            Label("Market", systemImage: "chart.line.uptrend.xyaxis")
        }
        .tag(2)
    }
}

struct MarketView_Previews: PreviewProvider {
    static var previews: some View {
        MarketView()
    }
}
