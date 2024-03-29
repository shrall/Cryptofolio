//
//  Crypto.swift
//  CryptofolioWatch WatchKit Extension
//
//  Created by Marshall Kurniawan on 18/05/22.
//

import Foundation

struct Searched: Hashable, Codable {
    let coins: [SearchedCrypto]
}

struct Trending: Hashable, Codable {
    let coins: [Dictionary<String, SearchedCrypto>]
}

struct Crypto: Hashable, Codable {
    let id: String
    let name: String
    let symbol: String
    let image: String
    let current_price: Double
    let market_cap: Int64
    let price_change_percentage_24h: Double
}

struct SearchedCrypto: Hashable, Codable {
    let id: String
    let name: String
    let symbol: String
    let large: String
    let market_cap_rank: Int?
}

// MARK: - CryptoDetail

struct CryptoDetail: Hashable, Codable {
    let id, symbol, name: String
    let description: Description
    let links: Links
    let image: CryptoImage
    let market_cap_rank: Int?
    let market_data: MarketData
}

// MARK: - Description

struct Description: Hashable, Codable {
    let en: String
}

// MARK: - Image

struct CryptoImage: Hashable, Codable {
    let thumb, small, large: String
}

// MARK: - Links

struct Links: Hashable, Codable {
    let homepage: [String]
}

// MARK: - MarketData

struct MarketData: Hashable, Codable {
    let current_price, ath, ath_change_percentage, atl: CurrencyType
    let atl_change_percentage, market_cap, high_24h, low_24h: CurrencyType
    let price_change_24h, price_change_percentage_24h: Double?
    let price_change_24h_in_currency, price_change_percentage_24h_in_currency: [String: Double?]
    let sparkline_7d: Sparkline7D
}

struct CurrencyType: Hashable, Codable {
    let usd: Double
    let idr: Double
}

// MARK: - Sparkline7D

struct Sparkline7D: Hashable, Codable {
    let price: [Double]
}

struct CryptoPrice: Hashable, Codable, Equatable {
    let prices: [[Double]]
}
