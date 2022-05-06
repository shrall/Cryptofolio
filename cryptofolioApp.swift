//
//  cryptofolioApp.swift
//  cryptofolio
//
//  Created by Marshall Kurniawan on 02/05/22.
//

import SwiftUI

@main
struct cryptofolioApp: App {
    
    let persistenceController = PersistenceController.shared
    
    @StateObject var portfolioViewModel = PortfolioViewModel()
    @StateObject var transactionViewModel = TransactionViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(portfolioViewModel)
                .environmentObject(transactionViewModel)
        }
    }
}
