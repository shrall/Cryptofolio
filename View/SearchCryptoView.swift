//
//  SearchCryptoView.swift
//  cryptofolio
//
//  Created by Marshall Kurniawan on 04/05/22.
//

import SwiftUI

struct SearchCryptoView: View {
    let maxWidth = UIScreen.main.bounds.width
    let maxHeight = UIScreen.main.bounds.height / 4
    var searchPlaceholder: String = ""
    var function: (() -> Void)?
    var marketFunction : ((String) -> Void)?
    var title: String
    var isMarket: Bool
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
            VStack(spacing: 8){
                SearchBar(text: $searchText, placeholder: "Search..").padding(.horizontal).padding(.vertical, -8)
                if searchedCryptos.count > 0 {
                    List {
                        ForEach(searchedCryptos, id: \.self) { crypto in
                            if(isMarket){
                                Button{
                                    addView.toggle()
                                    self.marketFunction!(crypto.id)
                                } label: {
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
                                    }.foregroundColor(.primary).padding(.horizontal)
                                }.listRowInsets(EdgeInsets())
                            }else{
                                NavigationLink {
                                    AddTransactionView(function: self.function!, addView: $addView, cryptoID: crypto.id)
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
                        }
                    }
                    .onAppear(perform: {
                        UITableView.appearance().contentInset.top = -35
                    }).background().navigationTitle(title).navigationBarTitleDisplayMode(.inline)
                } else {
                    VStack(alignment: .center) {
                        Image("search_empty").resizable()
                            .scaledToFit().frame(maxWidth: maxWidth / 2).padding()
                        if searchText.isEmpty {
                            Text("Waiting to search..").foregroundColor(.gray)
                        } else {
                            Text("No Results Found.").foregroundColor(.gray)
                        }
                    }.frame(minWidth: maxWidth, minHeight: maxHeight * 2, alignment: .center).background().navigationTitle(title).navigationBarTitleDisplayMode(.inline)
                }
                Spacer()
            }.toolbar {
                ToolbarItem (placement: .navigationBarLeading) {
                    Button{
                        addView.toggle()
                    } label: {
                        Text("Cancel")
                    }
                }
            }
        }
    }
}

struct SearchCryptoView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
