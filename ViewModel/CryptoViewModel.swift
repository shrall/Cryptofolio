//
//  CryptoViewModel.swift
//  cryptofolio
//
//  Created by Marshall Kurniawan on 04/05/22.
//

import Foundation
import SwiftUI

class CryptoViewModel: ObservableObject {
    @Published var cryptos: [Crypto] = []
    @Published var searchedCryptos: [SearchedCrypto] = []
    @Published var trendingCryptos: [[String: SearchedCrypto]] = []
    @Published var portfolioCryptos: [Crypto] = []
    
    var queryTemp: String = ""
    var constant = Constants()
    
    func fetchTop10() {
        guard let url = URL(string: constant.baseURL + "coins/markets?vs_currency=usd&order=market_cap_desc&per_page=10&page=1&sparkline=true") else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self]
            data, _, error in
            guard let data = data, error == nil else {
                return
            }
            // convert to JSON
            do {
                let meta = try JSONDecoder().decode([Crypto].self, from: data)
                DispatchQueue.main.async {
                    self?.cryptos = meta
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func fetchTrending() {
        guard let url = URL(string: constant.baseURL + "search/trending") else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self]
            data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let meta = try JSONDecoder().decode(Trending.self, from: data)
                DispatchQueue.main.async {
                    self?.trendingCryptos = meta.coins
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func fetchSearch(query: String) {
        if query != queryTemp {
            queryTemp = query
            guard let url = URL(string: constant.baseURL + "search?query=" + query) else {
                return
            }
            let task = URLSession.shared.dataTask(with: url) { [weak self]
                data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                do {
                    let meta = try JSONDecoder().decode(Searched.self, from: data)
                    DispatchQueue.main.async {
                        self?.searchedCryptos = meta.coins
                    }
                } catch {
                    print(error)
                }
            }
            task.resume()
        }
    }
    
    func fetchDetail(id: String, completion: @escaping (CryptoDetail) -> ()) {
        guard let url = URL(string: constant.baseURL + "coins/" + id + "?localization=false&tickers=false&community_data=false&developer_data=false&sparkline=true") else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) {
            data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let meta = try JSONDecoder().decode(CryptoDetail.self, from: data)
                DispatchQueue.main.async {
                    completion(meta)
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func fetchPrice(ids: [String]) {
        var idQuery = ""
        for element in ids {
            if element == ids.last {
                idQuery += element
            } else {
                idQuery += element + ","
            }
        }
        guard let url = URL(string: constant.baseURL + "coins/markets?vs_currency=usd&ids=" + idQuery + "&order=id_asc&per_page=1&page=1&sparkline=false") else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self]
            data, _, error in
            guard let data = data, error == nil else {
                return
            }
            // convert to JSON
            do {
                let meta = try JSONDecoder().decode([Crypto].self, from: data)
                DispatchQueue.main.async {
                    self?.portfolioCryptos = meta
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}
