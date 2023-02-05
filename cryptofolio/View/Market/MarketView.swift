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
    @State private var addView = false
    @State private var detailView = false
    @State var ids = [String]()
    @State private var scrollViewContentSize: CGSize = .zero
    @State var id = ""

    let maxWidth = UIScreen.main.bounds.width
    let maxHeight = UIScreen.main.bounds.height / 4

    @FetchRequest(entity: Portfolio.entity(), sortDescriptors: [NSSortDescriptor(key: "id", ascending: true)]) var fetchedPortfolio: FetchedResults<Portfolio>

    init(){
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Top Cryptos").bold().foregroundColor(.primary).font(Font.system(size: 24)).textCase(.none).padding(.horizontal)
            if(cryptoVM.cryptos.count > 0){
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(cryptoVM.cryptos.indices, id: \.self) { index in
                            NavigationLink{
                                MarketDetailView(id: cryptoVM.cryptos[index].id)
                            }label:{
                                VStack(alignment: .leading, spacing: 2) {
                                    HStack(spacing: 12) {
                                        AsyncImage(url: URL(string: cryptoVM.cryptos[index].image)) { image in
                                            image.resizable().frame(width: 32, height: 32)
                                                .clipShape(Circle())
                                        } placeholder: {
                                            LinearGradient(colors: [.gray, .white], startPoint: .topLeading, endPoint: .bottomTrailing)
                                                .clipShape(Circle())
                                        }
                                        .frame(width: 24, height: 24)
                                        VStack(alignment: .leading) {
                                            Text(cryptoVM.cryptos[index].name).lineLimit(1).frame(width: UIScreen.main.bounds.width / 4, alignment: .leading).foregroundColor(.primary)
                                        }
                                    }.padding(.bottom, 4)
                                    Text("24h change").font(Font.system(size: 12)).foregroundColor(.gray)
                                    cryptoVM.cryptos[index].price_change_percentage_24h > 0.0 ?
                                        HStack {
                                            Image(systemName: "arrowtriangle.up.fill").font(Font.system(size: 18)).foregroundColor(.green)
                                            Text(String(format: "%.2f", cryptoVM.cryptos[index].price_change_percentage_24h) + "%").font(Font.system(size: 16)).foregroundColor(.green)
                                        } :
                                        HStack {
                                            Image(systemName: "arrowtriangle.down.fill").font(Font.system(size: 18)).foregroundColor(.red)
                                            Text(String(format: "%.2f", cryptoVM.cryptos[index].price_change_percentage_24h)
                                                + "%").font(Font.system(size: 16)).foregroundColor(.red)
                                        }
                                }.padding().background().cornerRadius(8).shadow(color: .gray, radius: 1)
                            }
                        }
                    }.padding(.leading)
                }
                .frame(
                    maxHeight: 100
                )
            }else{
                HStack(alignment: .center){
                    ProgressView().frame(width: UIScreen.main.bounds.width, alignment: .center).padding(.leading)
                }
            }
            Text("Trending Cryptos").bold().foregroundColor(.primary).font(Font.system(size: 24)).textCase(.none).padding(.horizontal)
            if(cryptoVM.trendingCryptos.count > 0){
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(cryptoVM.trendingCryptos.indices, id: \.self) { index in
                            NavigationLink{
                                MarketDetailView(id: cryptoVM.trendingCryptos[index]["item"]!.id)
                            }label:{
                                VStack(alignment: .leading) {
                                    HStack(spacing: 12) {
                                        AsyncImage(url: URL(string: cryptoVM.trendingCryptos[index]["item"]!.large)) { image in
                                            image.resizable().frame(width: 32, height: 32)
                                                .clipShape(Circle())
                                        } placeholder: {
                                            LinearGradient(colors: [.gray, .white], startPoint: .topLeading, endPoint: .bottomTrailing)
                                                .clipShape(Circle())
                                        }
                                        .frame(width: 24, height: 24)
                                        Text(cryptoVM.trendingCryptos[index]["item"]!.name).lineLimit(1).frame(width: UIScreen.main.bounds.width / 4, alignment: .leading).foregroundColor(.primary)
                                    }
                                    VStack(alignment: .leading) {
                                        Text("MCap Rank").font(Font.system(size: 12)).foregroundColor(.gray)
                                        Text(String(cryptoVM.trendingCryptos[index]["item"]!.market_cap_rank ?? 0)).font(Font.system(size: 16)).foregroundColor(.primary)
                                    }
                                }.padding().background().cornerRadius(8).shadow(color: .gray, radius: 1)
                            }
                        }
                    }.padding(.leading)
                }
                .frame(
                    maxHeight: 100
                )
            }else{
                HStack(alignment: .center){
                    ProgressView().frame(width: UIScreen.main.bounds.width, alignment: .center).padding(.leading)
                }
            }
            Text("Your Portfolio").bold().foregroundColor(.primary).font(Font.system(size: 24)).textCase(.none).padding(.horizontal)
                ScrollView(.vertical, showsIndicators: false) {
                    if cryptoVM.portfolioCryptos.count > 0 {
                    LazyVStack {
                        ForEach(cryptoVM.portfolioCryptos, id: \.self) { crypto in
                            NavigationLink {
                                MarketDetailView(id: crypto.id)
                            } label: {
                                CryptoCell(type: "market", image: crypto.image, name: crypto.name, symbol: crypto.symbol, current_price: crypto.current_price, price_change_percentage_24h: crypto.price_change_percentage_24h, amount: 0).padding(.horizontal)
                            }
                        }
                    }
                    } else {
                        VStack(alignment: .center) {
                            Text("Your portfolio is empty.").foregroundColor(.gray)
                        }.frame(minWidth: maxWidth, minHeight: maxHeight, alignment: .center).background()
                    }
                }
            NavigationLink(destination: MarketDetailView(id: id), isActive: $detailView) {
                EmptyView()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    addView.toggle()
                } label: {
                    Image(systemName: "magnifyingglass")
                }
            }
        }
        .onAppear {
            cryptoVM.portfolioCryptos = []
            cryptoVM.fetchTop10()
            cryptoVM.fetchTrending()
            ids = []
            if fetchedPortfolio.count > 0 {
                for number in 0 ..< fetchedPortfolio.count {
                    ids.append(fetchedPortfolio[number].id!)
                }
                cryptoVM.fetchPrice(ids: ids)
            }
        }.sheet(isPresented: $addView) {
            SearchCryptoView(marketFunction: self.setup, title: "Search Crypto", isMarket: true, addView: $addView)
        }
    }

    func setup(theID:String) {
        detailView.toggle()
        id = theID
    }
}

struct MarketView_Previews: PreviewProvider {
    static var previews: some View {
        MarketView()
    }
}
