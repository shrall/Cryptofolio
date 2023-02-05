//
//  MarketView.swift
//  CryptofolioWatch WatchKit Extension
//
//  Created by Marshall Kurniawan on 18/05/22.
//

import SwiftUI

struct MarketView: View {
    @State private var searchText = ""
    @StateObject var cryptoVM = CryptoViewModel()
    var body: some View {
        if(cryptoVM.cryptos.count > 0){
            if searchText == ""{
                List{
                    ForEach(cryptoVM.cryptos, id:\.self){crypto in
                        NavigationLink{
                            MarketDetailView(id: crypto.id)
                        }label: {
                            HStack(spacing:12){
                                AsyncImage(url: URL(string: crypto.image)) { image in
                                    image.resizable().frame(width: 32, height: 32)
                                        .clipShape(Circle())
                                } placeholder: {
                                    LinearGradient(colors: [.gray, .white], startPoint: .topLeading, endPoint: .bottomTrailing)
                                        .clipShape(Circle())
                                }
                                .frame(width: 24, height: 24)
                                Text(crypto.name)
                            }
                        }
                    }
                }
                .searchable(text: $searchText)
                .onSubmit(of: .search) {
                    cryptoVM.fetchSearch(query: searchText)
                }
            }else {
                if(cryptoVM.cryptos.count > 0){
                    List{
                        ForEach(cryptoVM.searchedCryptos, id:\.self){crypto in
                            NavigationLink{
                                MarketDetailView(id: crypto.id)
                            }label: {
                                HStack(spacing:12){
                                    AsyncImage(url: URL(string: crypto.large)) { image in
                                        image.resizable().frame(width: 32, height: 32)
                                            .clipShape(Circle())
                                    } placeholder: {
                                        LinearGradient(colors: [.gray, .white], startPoint: .topLeading, endPoint: .bottomTrailing)
                                            .clipShape(Circle())
                                    }
                                    .frame(width: 24, height: 24)
                                    Text(crypto.name)
                                }
                            }
                        }
                    }
                    .searchable(text: $searchText)
                    .onSubmit(of: .search) {
                        cryptoVM.fetchSearch(query: searchText)
                    }
                }else{
                    ProgressView()
                }
            }
        }else {
            ProgressView()
                .onAppear{
                    cryptoVM.fetchTop100()
                }
        }
    }
}
