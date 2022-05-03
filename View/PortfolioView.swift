//
//  PortfolioView.swift
//  cryptofolio
//
//  Created by Marshall Kurniawan on 02/05/22.
//

import SwiftUI

struct PortfolioView: View {
    let maxWidth = UIScreen.main.bounds.width
    let maxHeight = UIScreen.main.bounds.height / 4
    @StateObject var apiService = APIService()
    @State private var animateGradient = false
    @State var showHeader = false
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .top))  {
            ScrollView {
                VStack(alignment: .center, spacing: 0) {
                    GeometryReader{reader -> AnyView in
                        
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
                        
                        return AnyView (
                            VStack(alignment: .leading) {
                                Spacer()
                                Text("GM, Marshall!").bold().font(Font.system(size: 32))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Total Asset Value").font(Font.system(size: 12)).padding(.top, 1)
                                Text(String(format: "%.2f", 120.137).currencyFormatting()).font(Font.system(size: 36)).bold().padding(.bottom)
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
                            print("Image tapped!")
                        } label: {
                            Image(systemName: "plus")
                        }
                    }.padding().background().cornerRadius(12, corners: [.topLeft,.topRight])
                    VStack (alignment:.center) {
                        Image("portfolio_empty").resizable()
                            .scaledToFit().frame(maxWidth: maxWidth/2).padding()
                        Text("You have no assets.")
                    }.frame(minWidth:maxWidth,minHeight:maxHeight*2, alignment: .center).background()
//                    LazyVStack(alignment:.leading) {
//                        ForEach(apiService.cryptos, id: \.self) { crypto in
//                            NavigationLink {
//                                Text(String(format: "%.2f", crypto.current_price))
//                            } label: {
//                                CryptoCell(crypto: crypto, type: "portfolio").padding(.horizontal)
//                            }
//                        }
//                        Spacer()
//                    }.frame(minHeight:maxHeight*2, alignment: .topLeading).background()
                }
                .navigationBarHidden(true)
                
            }
            .ignoresSafeArea(.all, edges: .top)
            
            VStack (alignment: .leading, spacing: 2) {
                Text("Total Asset Value").font(Font.system(size: 8))
                Text(String(format: "%.2f", 120.137).currencyFormatting()).font(Font.system(size: 24)).bold()
                HStack {
                    Text("Assets").bold().foregroundColor(.primary).font(Font.system(size: 22)).textCase(.none)
                    Spacer()
                    Button {
                        print("Image tapped!")
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .padding([.horizontal, .bottom]).padding(.top, UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .compactMap({$0 as? UIWindowScene})
                .first?.windows
                .filter({$0.isKeyWindow}).first?.safeAreaInsets.top)
            .background(BlurView(style: .prominent))
            .ignoresSafeArea(.all, edges: .top)
            .opacity(showHeader ? 1 : 0)
        }
        .onAppear {
            apiService.fetchAll()
        }
        .tabItem {
            Label("Portfolio", systemImage: "chart.pie")
        }
        .tag(1)
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
