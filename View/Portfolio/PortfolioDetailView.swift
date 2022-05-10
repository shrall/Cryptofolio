//
//  PortfolioDetailView.swift
//  cryptofolio
//
//  Created by Marshall Kurniawan on 07/05/22.
//

import SwiftUI
import SwiftUICharts

struct PortfolioDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var portfolioVM: PortfolioViewModel
    @EnvironmentObject var transactionVM: TransactionViewModel

    var portfolio: Portfolio
    let chartStyle = ChartStyle(backgroundColor: Color.clear, accentColor: Colors.DarkPurple, secondGradientColor: Colors.GradientPurple, textColor: Color.primary, legendTextColor: Color.gray, dropShadowColor: Color.clear)
    @State var chartData: [Double] = []
    @State private var addView = false

    var body: some View {
        VStack(alignment: .center) {
            LineView(data: chartData, title: String(portfolio.amount)+" "+(portfolio.symbol?.uppercased() ?? ""), style: chartStyle)
                .padding(.horizontal)
            HStack {
                Text("Transactions").bold().foregroundColor(.primary).font(Font.system(size: 22)).textCase(.none)
                Spacer()
                Button {
                    addView.toggle()
                } label: {
                    Image(systemName: "plus").resizable().frame(width: 18, height: 18)
                }
            }.padding(.horizontal)
            ScrollView {
                if transactionVM.transactions.count > 0 {
                    LazyVStack(alignment: .leading) {
                        ForEach(transactionVM.transactions.indices, id: \.self) { index in
                            HStack {
                                transactionVM.transactions[index].isBuy ?
                                    Image(systemName: "arrow.up.circle").font(Font.system(size: 24)).foregroundColor(.green)
                                    : Image(systemName: "arrow.down.circle").font(Font.system(size: 24)).foregroundColor(.red)
                                VStack(alignment: .leading) {
                                    transactionVM.transactions[index].isBuy ?
                                        Text("Buy").font(Font.system(size: 14))
                                        : Text("Sell").font(Font.system(size: 14))
                                    Text(transactionVM.transactions[index].date ?? Date(), style: .date).font(Font.system(size: 14)).foregroundColor(.gray)
                                }
                                Spacer()
                                if transactionVM.transactions[index].isBuy {
                                    Text(String(transactionVM.transactions[index].amount)+" "+(portfolio.symbol?.uppercased() ?? "")).font(Font.system(size: 18))
                                } else {
                                    Text(String(transactionVM.transactions[index].amount)+" "+(portfolio.symbol?.uppercased() ?? "")).font(Font.system(size: 18))
                                }
                            }
                        }
                    }.background()
                }
            }.padding(.horizontal).frame(height: UIScreen.main.bounds.height / 3)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    AsyncImage(url: URL(string: portfolio.image ?? "")) { image in
                        image.resizable()
                            .clipShape(Circle())
                    } placeholder: {
                        LinearGradient(colors: [.gray, .white], startPoint: .topLeading, endPoint: .bottomTrailing)
                            .clipShape(Circle())
                    }
                    .frame(width: 24, height: 24)
                    Text(portfolio.name ?? "")
                }.frame(minWidth: UIScreen.main.bounds.width / 2)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(role: .destructive) {
                        transactionVM.deleteTransactions(context: viewContext, id: portfolio.id!)
                        portfolioVM.deletePortfolio(context: viewContext, id: portfolio.id!)
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "trash")
                            Text("Delete "+(portfolio.symbol?.uppercased() ?? ""))
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis")
                }
            }
        }
        .onAppear {
            setup()
        }.sheet(isPresented: $addView) {
            NavigationView {
                AddTransactionView(function: self.setup, addView: $addView, cryptoID: portfolio.id!).navigationBarTitleDisplayMode(.inline)
            }
        }
    }

    func setup() {
        print("setup")
        transactionVM.getTransactions(context: viewContext, id: portfolio.id!)
        for index in transactionVM.transactions.indices {
            if index == 0 {
                if transactionVM.transactions[transactionVM.transactions.count - 1 - index].isBuy {
                    chartData.append(transactionVM.transactions[transactionVM.transactions.count - 1 - index].amount)
                } else {
                    chartData.append(transactionVM.transactions[transactionVM.transactions.count - 1 - index].amount * -1)
                }
            } else {
                if transactionVM.transactions[transactionVM.transactions.count - 1 - index].isBuy {
                    chartData.append(chartData[index - 1]+transactionVM.transactions[transactionVM.transactions.count - 1 - index].amount)
                } else {
                    chartData.append(chartData[index - 1] - transactionVM.transactions[transactionVM.transactions.count - 1 - index].amount)
                }
            }
        }
    }
}

struct PortfolioDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
