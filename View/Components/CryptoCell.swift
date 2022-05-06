//
//  CryptoCell.swift
//  cryptofolio
//
//  Created by Marshall Kurniawan on 02/05/22.
//

import SwiftUI

struct CryptoCell: View {
    let type: String
    let image: String
    let name: String
    let symbol: String
    let current_price: Double
    let price_change_percentage_24h: Double?
    let amount: Double?
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: image)) { image in
                image.resizable()
                    .clipShape(Circle())
            } placeholder: {
                LinearGradient(colors: [.gray, .white], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .clipShape(Circle())
            }
            .frame(width: 36, height: 36)
            VStack(alignment: .leading, spacing: 2) {
                Text(name).font(Font.system(size: 18)).foregroundColor(.primary)
                Text(symbol).font(Font.system(size: 12)).foregroundColor(.gray)
                    .textCase(.uppercase)
            }
            Spacer()
            switch type{
            case "market":
                VStack(alignment: .trailing, spacing: 2) {
                    Text(String(format: "%.2f", current_price).currencyFormatting()).font(Font.system(size: 18)).foregroundColor(.primary)
                    price_change_percentage_24h! > 0.0 ?
                    HStack {
                        Image(systemName: "arrowtriangle.up.fill").font(Font.system(size: 12)).foregroundColor(.green)
                        Text(String(format: "%.2f", price_change_percentage_24h!) + "%").font(Font.system(size: 12)).foregroundColor(.green)
                    } :
                    HStack {
                        Image(systemName: "arrowtriangle.down.fill").font(Font.system(size: 12)).foregroundColor(.red)
                        Text(String(format: "%.2f", price_change_percentage_24h!)
                             + "%").font(Font.system(size: 12)).foregroundColor(.red)
                    }
                }
            case "portfolio":
                switch current_price{
                case 0.0:
                    VStack(alignment: .trailing, spacing: 2) {
                        ProgressView()
                    }
                default:
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(String(format: "%.2f", (amount! * current_price)).currencyFormatting()).font(Font.system(size: 18)).foregroundColor(.primary)
                        HStack (spacing:2) {
                            Text(String(format: "%.2f", amount!)).font(Font.system(size: 12)).foregroundColor(.gray)
                            Text(symbol).font(Font.system(size: 12)).foregroundColor(.gray)
                                .textCase(.uppercase)
                        }
                    }
                }
            default:
                Text("error")
            }
        }
    }
}
