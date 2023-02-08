//
//  AddTransactionView.swift
//  cryptofolio
//
//  Created by Marshall Kurniawan on 04/05/22.
//

import SwiftUI

struct AddTransactionView: View {
    var function: () -> Void
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var transactionVM: TransactionViewModel
    @EnvironmentObject var portfolioVM: PortfolioViewModel
    @Binding var addView: Bool
    @State var crypto: CryptoDetail?
    @StateObject var cryptoVM = CryptoViewModel()
    let cryptoID: String
    
    let doubleFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.zeroSymbol = ""
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading) {
            Picker("", selection: $transactionVM.isBuy) {
                Text("Buy").tag(true)
                Text("Sell").tag(false)
            }
            .pickerStyle(.segmented)
            HStack(alignment: .firstTextBaseline, spacing: 0) {
                TextField("0.00", value: $transactionVM.amount, formatter: doubleFormatter)
                    .font(Font.system(size: 60))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .keyboardType(.decimalPad).expandable()
                Text(crypto?.symbol ?? "").textCase(.uppercase)
            }.padding(.horizontal).toolbar {
                ToolbarItem {
                    Button {
                        if !portfolioVM.checkPortfolio(context: viewContext, id: crypto?.id ?? "") {
                            //create new
                            portfolioVM.cryptoID = crypto?.id ?? ""
                            portfolioVM.name = crypto?.name ?? ""
                            portfolioVM.symbol = crypto?.symbol ?? ""
                            portfolioVM.image = crypto?.image.large ?? ""
                            if(transactionVM.isBuy){
                                portfolioVM.amount = transactionVM.amount
                            }else{
                                portfolioVM.amount = transactionVM.amount * -1
                            }
                            portfolioVM.createPortfolio(context: viewContext)
                        } else {
                            portfolioVM.cryptoID = crypto?.id ?? ""
                            portfolioVM.amount = transactionVM.amount
                            portfolioVM.editPortfolio(context: viewContext, isBuy: transactionVM.isBuy)
                        }
                        transactionVM.cryptoID = crypto?.id ?? ""
                        transactionVM.createTransaction(context: viewContext)
                        self.function()
                        addView.toggle()
                    } label: {
                        Text("Save")
                    }
                }
                ToolbarItem(placement: .principal) {
                    HStack {
                        AsyncImage(url: URL(string: crypto?.image.large ?? "")) { image in
                            image.resizable()
                                .clipShape(Circle())
                        } placeholder: {
                            LinearGradient(colors: [.gray, .white], startPoint: .topLeading, endPoint: .bottomTrailing)
                                .clipShape(Circle())
                        }
                        .frame(width: 24, height: 24)
                        Text(crypto?.name ?? "")
                    }.frame(minWidth: UIScreen.main.bounds.width / 2)
                }
            }
            Spacer()
        }.padding().onAppear {
            cryptoVM.fetchDetail(id: cryptoID) { result in
                crypto = result
            }
            transactionVM.amount = 0.0
        }
    }
}
