//
//  MarketDetailView.swift
//  cryptofolio
//
//  Created by Marshall Kurniawan on 10/05/22.
//

import SwiftUI
import SwiftUICharts

struct MarketDetailView: View {
    var id: String
    @State var crypto: CryptoDetail?
    @State var cryptoPrice: CryptoPrice?{
        didSet{
            for number in 0 ..< (cryptoPrice?.prices.count ?? 0) {
                chartData.append(cryptoPrice?.prices[number][1] ?? 0)
            }
        }
    }
    @State private var aboutView = false
    @StateObject var cryptoVM = CryptoViewModel()
    
    @State var chartData : [Double] = []

    let chartStyle = ChartStyle(backgroundColor: Color.clear, accentColor: Colors.DarkPurple, secondGradientColor: Colors.GradientPurple, textColor: Color.primary, legendTextColor: Color.gray, dropShadowColor: Color.clear)

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    AsyncImage(url: URL(string: crypto?.image.large ?? "")) { image in
                        image.resizable()
                            .clipShape(Circle())
                    } placeholder: {
                        LinearGradient(colors: [.gray, .white], startPoint: .topLeading, endPoint: .bottomTrailing)
                            .clipShape(Circle())
                    }
                    .frame(width: 32, height: 32)
                    Text(crypto?.name ?? "").bold().font(Font.system(size: 32)).minimumScaleFactor(0.2).lineLimit(1)
                    crypto?.market_data.price_change_percentage_24h ?? 0.0 > 0.0 ?
                        HStack {
                            Image(systemName: "arrowtriangle.up.fill").font(Font.system(size: 24)).foregroundColor(.green)
                            Text(String(format: "%.2f", crypto?.market_data.price_change_percentage_24h ?? 0.0) + "%").font(Font.system(size: 24)).foregroundColor(.green)
                        } :
                        HStack {
                            Image(systemName: "arrowtriangle.down.fill").font(Font.system(size: 24)).foregroundColor(.red)
                            Text(String(format: "%.2f", crypto?.market_data.price_change_percentage_24h ?? 0.0)
                                + "%").font(Font.system(size: 24)).foregroundColor(.red)
                        }
                }
                .padding(.horizontal)
                if(UserDefaults.standard.string(forKey: "preferredCurrency") == "usd" || UserDefaults.standard.string(forKey: "preferredCurrency") == nil){
                    LineView(data: chartData , title: String(crypto?.market_data.current_price.usd ?? 0.0).currencyFormatting(), legend: "Last 24h price change", style: chartStyle)
                        .frame(height: 370)
                        .padding(.horizontal)
                }else{
                    LineView(data: chartData , title: String(crypto?.market_data.current_price.idr ?? 0.0).currencyFormatting(), legend: "Last 24h price change", style: chartStyle)
                        .frame(height: 370)
                        .padding(.horizontal)
                }
                Divider().padding()
                HStack {
                    Image(systemName: "info.circle")
                        .font(Font.title.weight(.medium)).font(Font.system(size: 24))
                    Text("About " + (crypto?.name ?? "")).bold().font(Font.system(size: 24))
                    Spacer()
                    Button {
                        aboutView.toggle()
                    } label: {
                        Text("See more").foregroundColor(.accentColor)
                    }
                }.padding(.horizontal).padding(.bottom, 4)
                Text(crypto?.description.en ?? "").lineLimit(4).padding(.horizontal).padding(.bottom, 12)
                VStack(spacing: 4) {
                    HStack {
                        Text("Market Cap Rank").foregroundColor(.gray)
                        Spacer()
                        Text("#" + String(crypto?.market_cap_rank ?? 0))
                    }
                    if(UserDefaults.standard.string(forKey: "preferredCurrency") == "usd" || UserDefaults.standard.string(forKey: "preferredCurrency") == nil){
                        HStack {
                            Text("Market Cap").foregroundColor(.gray)
                            Spacer()
                            Text(String(crypto?.market_data.market_cap.usd ?? 0).currencyFormatting())
                        }
                        HStack {
                            Text("24H High").foregroundColor(.gray)
                            Spacer()
                            Text(String(crypto?.market_data.high_24h.usd ?? 0).currencyFormatting())
                        }
                        HStack {
                            Text("24H Low").foregroundColor(.gray)
                            Spacer()
                            Text(String(crypto?.market_data.low_24h.usd ?? 0).currencyFormatting())
                        }
                        HStack {
                            Text("All-Time High").foregroundColor(.gray)
                            Spacer()
                            Text(String(crypto?.market_data.ath.usd ?? 0).currencyFormatting())
                        }
                        HStack {
                            Text("All-Time Low").foregroundColor(.gray)
                            Spacer()
                            Text(String(crypto?.market_data.atl.usd ?? 0).currencyFormatting())
                        }
                    }else{
                        HStack {
                            Text("Market Cap").foregroundColor(.gray)
                            Spacer()
                            Text(String(crypto?.market_data.market_cap.idr ?? 0).currencyFormatting())
                        }
                        HStack {
                            Text("24H High").foregroundColor(.gray)
                            Spacer()
                            Text(String(crypto?.market_data.high_24h.idr ?? 0).currencyFormatting())
                        }
                        HStack {
                            Text("24H Low").foregroundColor(.gray)
                            Spacer()
                            Text(String(crypto?.market_data.low_24h.idr ?? 0).currencyFormatting())
                        }
                        HStack {
                            Text("All-Time High").foregroundColor(.gray)
                            Spacer()
                            Text(String(crypto?.market_data.ath.idr ?? 0).currencyFormatting())
                        }
                        HStack {
                            Text("All-Time Low").foregroundColor(.gray)
                            Spacer()
                            Text(String(crypto?.market_data.atl.idr ?? 0).currencyFormatting())
                        }
                    }
                }.padding(.horizontal)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if crypto?.links.homepage.count ?? 0 > 0 {
                    Link("Website", destination: URL(string: crypto?.links.homepage[0] ?? "")!)
                }
            }
        }
        .sheet(isPresented: $aboutView) {
            NavigationView {
                ScrollView {
                    Text(crypto?.description.en ?? "").padding().navigationBarTitle("About " + (crypto?.name ?? ""))
                }.toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            aboutView.toggle()
                        } label: {
                            Text("Close")
                        }
                    }
                }
            }
        }.onAppear {
            crypto = nil
            cryptoVM.fetchDetail(id: id) { result in
                crypto = result
            }
            chartData = []
            cryptoPrice = nil
            cryptoVM.fetchChartData(id: id){result in
                cryptoPrice = result
            }
        }
    }
}
