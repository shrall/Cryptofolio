//
//  AddPortfolioView.swift
//  cryptofolio
//
//  Created by Marshall Kurniawan on 04/05/22.
//

import SwiftUI

struct AddPortfolioView: View {
    let cryptos:[SearchedCrypto] = []
    @Binding var addView:Bool
    @State private var amount:Double = 0.0
    @State private var pickerSelection: String = ""
    @State private var searchTerm: String = ""
    @StateObject var cryptoVM = CryptoViewModel()
    var searchedCryptos: [SearchedCrypto] {
        if(searchTerm.isEmpty){
            return cryptoVM.searchedCryptos
        }else{
            cryptoVM.fetchSearch(query: searchTerm)
            return cryptoVM.searchedCryptos.filter { $0.name.lowercased().contains(searchTerm.lowercased())
            }
        }
    }
    
    let doubleFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.zeroSymbol = ""
        return formatter
    }()
    
    var body: some View {
        NavigationView{
            Form{
                Picker(selection: $pickerSelection, label: Text("Select Crypto")) {
                    SearchBar(text: $searchTerm, placeholder: "Search Cryptos")
                    ForEach(searchedCryptos, id: \.self) { crypto in
                        HStack{
                            AsyncImage(url: URL(string: crypto.large)) { image in
                                image.resizable()
                                    .clipShape(Circle())
                            } placeholder: {
                                LinearGradient(colors: [.gray, .white], startPoint: .topLeading, endPoint: .bottomTrailing)
                                    .clipShape(Circle())
                            }
                            .frame(width: 24, height: 24)
                            Text(crypto.name)
                        }.tag(crypto.id)
                    }
                }
                TextField("Enter Amount", value: $amount, formatter: doubleFormatter)
                    .frame(maxWidth: .infinity)
                    .keyboardType(.decimalPad)
            }.navigationTitle("Add Portfolio").navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem (placement: .navigationBarTrailing) {
                        Button{
                            addView.toggle()
                        } label: {
                            Text("Save")
                        }
                    }
                }
        }
    }
}

struct AddPortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
