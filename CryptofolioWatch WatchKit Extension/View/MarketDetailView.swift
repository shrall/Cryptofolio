//
//  MarketDetailView.swift
//  CryptofolioWatch WatchKit Extension
//
//  Created by Marshall Kurniawan on 18/05/22.
//

import SwiftUI


struct MarketDetailView: View {
    var id: String
    @State var crypto: CryptoDetail?
    @StateObject var cryptoVM = CryptoViewModel()
    
    var body: some View {
        if crypto != nil{
            VStack(spacing: 4){
                AsyncImage(url: URL(string: crypto?.image.large ?? "")) { image in
                    image.resizable()
                        .clipShape(Circle())
                } placeholder: {
                    LinearGradient(colors: [.gray, .white], startPoint: .topLeading, endPoint: .bottomTrailing)
                        .clipShape(Circle())
                }
                .frame(width: 64, height: 64)
                Text(crypto?.name ?? "").bold().font(Font.system(size: 24)).minimumScaleFactor(0.2).lineLimit(1)
                Text(String(crypto?.market_data.current_price.usd ?? 0.0).currencyFormatting())
                crypto?.market_data.price_change_percentage_24h ?? 0.0 > 0.0 ?
                HStack {
                    Image(systemName: "arrowtriangle.up.fill").font(Font.system(size: 18)).foregroundColor(.green)
                    Text(String(format: "%.2f", crypto?.market_data.price_change_percentage_24h ?? 0.0) + "%").font(Font.system(size: 18)).foregroundColor(.green)
                } :
                HStack {
                    Image(systemName: "arrowtriangle.down.fill").font(Font.system(size: 18)).foregroundColor(.red)
                    Text(String(format: "%.2f", crypto?.market_data.price_change_percentage_24h ?? 0.0)
                         + "%").font(Font.system(size: 18)).foregroundColor(.red)
                }
            }
        }else{
            ProgressView()
                .onAppear {
                    crypto = nil
                    cryptoVM.fetchDetail(id: id) { result in
                        crypto = result
                    }
                }
        }
    }
}

struct MarketDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MarketDetailView(id: "bitcoin")
    }
}
