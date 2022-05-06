//
//  PortfolioView.swift
//  cryptofolio
//
//  Created by Marshall Kurniawan on 02/05/22.
//

import SwiftUI

struct PortfolioView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var portfolioVM: PortfolioViewModel
    @EnvironmentObject var transactionVM: TransactionViewModel
    
    
    @FetchRequest(entity: Portfolio.entity(), sortDescriptors: [NSSortDescriptor(key: "id", ascending: true)]) var fetchedPortfolio: FetchedResults<Portfolio>
    
    let maxWidth = UIScreen.main.bounds.width
    let maxHeight = UIScreen.main.bounds.height / 4
    let time = Calendar.current.component(.hour, from: Date())
    @State private var animateGradient = false
    @State var showHeader = false
    @State private var addView = false
    
    @State var ids = [String]()
    @State var totalAssetValue = 0.0
    
    @StateObject var cryptoVM = CryptoViewModel()
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
            ScrollView {
                VStack(alignment: .center, spacing: 0) {
                    GeometryReader { reader -> AnyView in
                        let y = reader.frame(in: .global).minY + maxHeight
                        
                        if y < 0 {
                            withAnimation(.linear(duration: 0.1)) {
                                showHeader = true
                            }
                        } else {
                            withAnimation(.linear(duration: 0.1)) {
                                showHeader = false
                            }
                        }
                        return AnyView(
                            VStack(alignment: .leading) {
                                Spacer()
                                if time < 18{
                                    Text("GM, Marshall!").bold().font(Font.system(size: 32))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }else{
                                    Text("GN, Marshall!").bold().font(Font.system(size: 32))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                Text("Total Asset Value").font(Font.system(size: 12)).padding(.top, 1)
                                if cryptoVM.cryptos.count != fetchedPortfolio.count {
                                    ProgressView().frame(width: 36, height: 48)
                                } else {
                                    Text(String(format: "%.2f", totalAssetValue).currencyFormatting()).font(Font.system(size: 36)).bold().padding(.bottom)
                                }
                            }.padding(.horizontal).frame(width: maxWidth, height: maxHeight).background(
                                LinearGradient(gradient: Gradient(colors: [Color("PrimaryColor"), Color("PrimaryColorDark")]), startPoint: .topLeading, endPoint: .bottomTrailing).hueRotation(.degrees(animateGradient ? 15 : 0))
                                    .onAppear {
                                        withAnimation(.easeInOut(duration: 5.0).repeatForever(autoreverses: true)) {
                                            animateGradient.toggle()
                                        }
                                    }).foregroundColor(.white).offset(y: -reader.frame(in: .global).minY)
                        )
                    }.frame(width: maxWidth, height: maxHeight)
                    HStack {
                        Text("Assets").bold().foregroundColor(.primary).font(Font.system(size: 22)).textCase(.none)
                        Spacer()
                        Button {
                            addView.toggle()
                        } label: {
                            Image(systemName: "plus").resizable().frame(width: 18, height: 18)
                        }
                    }.padding().background().cornerRadius(12, corners: [.topLeft, .topRight])
                    if fetchedPortfolio.count > 0 {
                        LazyVStack(alignment: .leading) {
                            ForEach(fetchedPortfolio.indices, id: \.self) { index in
                                NavigationLink {
                                    PortfolioDetailView(portfolio: fetchedPortfolio[index])
                                } label: {
                                    if cryptoVM.cryptos.count != fetchedPortfolio.count {
                                        CryptoCell(type: "portfolio", image: fetchedPortfolio[index].image!, name: fetchedPortfolio[index].name!, symbol: fetchedPortfolio[index].symbol!, current_price: 0.0, price_change_percentage_24h: 0.0, amount: fetchedPortfolio[index].amount).padding(.horizontal)
                                    } else {
                                        CryptoCell(type: "portfolio", image: fetchedPortfolio[index].image!, name: fetchedPortfolio[index].name!, symbol: fetchedPortfolio[index].symbol!, current_price: cryptoVM.cryptos[index].current_price, price_change_percentage_24h: 0.0, amount: fetchedPortfolio[index].amount).padding(.horizontal).task {
                                            updateTotalPrice()
                                        }
                                    }
                                }
                            }
                            Spacer()
                        }.frame(minHeight: maxHeight * 2, alignment: .topLeading).background()
                    } else {
                        VStack(alignment: .center) {
                            Image("portfolio_empty").resizable()
                                .scaledToFit().frame(maxWidth: maxWidth / 2).padding()
                            Text("Your portfolio is empty.").foregroundColor(.gray)
                        }.frame(minWidth: maxWidth, minHeight: maxHeight * 2, alignment: .center).background()
                    }
                }
                .navigationBarHidden(true)
            }
            .ignoresSafeArea(.all, edges: .top)
            VStack(alignment: .leading, spacing: 2) {
                Text("Total Asset Value").font(Font.system(size: 8))
                Text(String(format: "%.2f", 120.137).currencyFormatting()).font(Font.system(size: 24)).bold()
                HStack {
                    Text("Assets").bold().foregroundColor(.primary).font(Font.system(size: 22)).textCase(.none)
                    Spacer()
                    Button {
                        addView.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .padding([.horizontal, .bottom]).padding(.top, UIApplication.shared.connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .compactMap { $0 as? UIWindowScene }
                .first?.windows
                .filter { $0.isKeyWindow }.first?.safeAreaInsets.top)
            .background(BlurView(style: .prominent))
            .ignoresSafeArea(.all, edges: .top)
            .opacity(showHeader ? 1 : 0)
        }.onAppear {
            setup()
            cryptoVM.cryptos = []
        }.sheet(isPresented: $addView) {
            SearchCryptoView(function: self.setup, title: "Select Crypto", addView: $addView).onDisappear{
                updateTotalPrice()
            }
        }
        .tabItem {
            Label("Portfolio", systemImage: "chart.pie")
        }
        .tag(1)
    }
    
    func setup() {
        ids = []
        if fetchedPortfolio.count > 0 {
            for number in 0 ..< fetchedPortfolio.count {
                ids.append(fetchedPortfolio[number].id!)
            }
            cryptoVM.fetchPrice(ids: ids)
            cryptoVM.cryptos = []
        }
    }
    
    func updateTotalPrice() {
        if fetchedPortfolio.count == cryptoVM.cryptos.count {
            totalAssetValue = 0
            for number in 0 ..< fetchedPortfolio.count {
                totalAssetValue += fetchedPortfolio[number].amount * cryptoVM.cryptos[number].current_price
            }
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}
