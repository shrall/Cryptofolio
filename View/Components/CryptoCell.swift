//
//  CryptoCell.swift
//  cryptofolio
//
//  Created by Marshall Kurniawan on 02/05/22.
//

import SwiftUI

struct CryptoCell: View {
    let crypto: Crypto
    let type: String
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: crypto.image)) { image in
                image.resizable()
                    .clipShape(Circle())
            } placeholder: {
                LinearGradient(colors: [.gray, .white], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .clipShape(Circle())
            }
            .frame(width: 36, height: 36)
            VStack(alignment: .leading, spacing: 2) {
                Text(crypto.name).font(Font.system(size: 18)).foregroundColor(.primary)
                Text(crypto.symbol).font(Font.system(size: 12)).foregroundColor(.gray)
                    .textCase(.uppercase)
            }
            Spacer()
            switch type{
            case "market":
                VStack(alignment: .trailing, spacing: 2) {
                    Text(String(format: "%.2f", crypto.current_price).currencyFormatting()).font(Font.system(size: 18)).foregroundColor(.primary)
                    crypto.price_change_percentage_24h > 0 ?
                    HStack {
                        Image(systemName: "arrowtriangle.up.fill").font(Font.system(size: 12)).foregroundColor(.green)
                        Text(String(format: "%.2f", crypto.price_change_percentage_24h) + "%").font(Font.system(size: 12)).foregroundColor(.green)
                    } :
                    HStack {
                        Image(systemName: "arrowtriangle.down.fill").font(Font.system(size: 12)).foregroundColor(.red)
                        Text(String(format: "%.2f", crypto.price_change_percentage_24h)
                             + "%").font(Font.system(size: 12)).foregroundColor(.red)
                    }
                }
            case "portfolio":
                VStack(alignment: .trailing, spacing: 2) {
                    Text(String(format: "%.2f", crypto.current_price).currencyFormatting()).font(Font.system(size: 18)).foregroundColor(.primary)
                    HStack (spacing:2) {
                        Text(String(format: "%.2f", 23.22)).font(Font.system(size: 12)).foregroundColor(.gray)
                        Text(crypto.symbol).font(Font.system(size: 12)).foregroundColor(.gray)
                            .textCase(.uppercase)
                    }
                }
            default:
                Text("error")
            }
        }
    }
}
