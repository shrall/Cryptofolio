//
//  Crypto.swift
//  cryptofolio
//
//  Created by Marshall Kurniawan on 02/05/22.
//

import Foundation

struct Crypto: Hashable, Codable{
    let id: String
    let name: String
    let symbol: String
    let image: String
    let current_price: Double
    let market_cap: Int64
    let price_change_percentage_24h: Double
}
