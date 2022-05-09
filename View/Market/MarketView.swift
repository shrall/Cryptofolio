//
//  MarketView.swift
//  cryptofolio
//
//  Created by Marshall Kurniawan on 02/05/22.
//

import SwiftUI

struct MarketView: View {
    @State private var searchText = ""
    @StateObject var cryptoVM = CryptoViewModel()
    
    var body: some View {
        Text("market")
        .navigationBarTitleDisplayMode(.inline).onAppear {
            cryptoVM.fetchTop10()
        }
    }
}

struct MarketView_Previews: PreviewProvider {
    static var previews: some View {
        MarketView()
    }
}
