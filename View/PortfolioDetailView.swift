//
//  PortfolioDetailView.swift
//  cryptofolio
//
//  Created by Marshall Kurniawan on 07/05/22.
//

import SwiftUI

struct PortfolioDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var portfolioVM: PortfolioViewModel
    @EnvironmentObject var transactionVM: TransactionViewModel
    
    var portfolio:Portfolio
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/).toolbar {
            ToolbarItem (placement: .navigationBarTrailing) {
                Button{
                    transactionVM.deleteTransactions(context: viewContext, id: portfolio.id!)
                    portfolioVM.deletePortfolio(context: viewContext, id: portfolio.id!)
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Delete")
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
