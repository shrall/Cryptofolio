//
//  APIService.swift
//  cryptofolio
//
//  Created by Marshall Kurniawan on 02/05/22.
//

import Foundation

class APIService: ObservableObject{
    @Published var cryptos : [Crypto] = []
    var constant = Constants()
    
    func fetchAll(){
        guard let url = URL(string: constant.baseURL + "coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=false")else{
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self]
            data, _, error in
            guard let data = data, error == nil else {
                return
            }
            //convert to JSON
            do{
                let meta = try JSONDecoder().decode([Crypto].self, from: data)
                DispatchQueue.main.async {
                    self?.cryptos = meta
                }
            }catch{
                print(error)
            }
        }
        task.resume()
    }
}

