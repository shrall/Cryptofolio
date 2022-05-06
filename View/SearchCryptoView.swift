//
//  SearchCryptoView.swift
//  cryptofolio
//
//  Created by Marshall Kurniawan on 04/05/22.
//

import SwiftUI

struct SearchCryptoView: View {
    var function: () -> Void
    let maxWidth = UIScreen.main.bounds.width
    let maxHeight = UIScreen.main.bounds.height / 4
    var title: String
    @Binding var addView: Bool

    @State private var searchText = ""
    @StateObject var cryptoVM = CryptoViewModel()
    var searchedCryptos: [SearchedCrypto] {
        if searchText.isEmpty {
            return cryptoVM.searchedCryptos
        } else {
            cryptoVM.fetchSearch(query: searchText)
            return cryptoVM.searchedCryptos.filter { $0.name.lowercased().contains(searchText.lowercased())
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0){
                SearchBar(text: $searchText, placeholder: "Search..").padding(.horizontal).padding(.vertical, -8)
                if searchedCryptos.count > 0 {
                    List {
                        ForEach(searchedCryptos, id: \.self) { crypto in
                            NavigationLink {
                                AddTransactionView(function: self.function, addView: $addView, cryptoID: crypto.id)
                            } label: {
                                AsyncImage(url: URL(string: crypto.large)) { image in
                                    image.resizable()
                                        .clipShape(Circle())
                                } placeholder: {
                                    LinearGradient(colors: [.gray, .white], startPoint: .topLeading, endPoint: .bottomTrailing)
                                        .clipShape(Circle())
                                }
                                .frame(width: 24, height: 24)
                                Text(crypto.name)
                            }
                        }
                    }.background().navigationTitle(title).navigationBarTitleDisplayMode(.inline)
                } else {
                    VStack(alignment: .center) {
                        Image("search_empty").resizable()
                            .scaledToFit().frame(maxWidth: maxWidth / 2).padding()
                        Text("There's nothing here..").foregroundColor(.gray)
                    }.frame(minWidth: maxWidth, minHeight: maxHeight * 2, alignment: .center).background().navigationTitle(title).navigationBarTitleDisplayMode(.inline)
                }
                Spacer()
            }
        }
    }
}

struct SearchCryptoView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
