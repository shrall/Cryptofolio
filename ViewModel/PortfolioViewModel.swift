//
//  PortfolioViewModel.swift
//  cryptofolio
//
//  Created by Marshall Kurniawan on 04/05/22.
//

import Foundation
import Combine
import CoreData
import SwiftUI

class PortfolioViewModel:ObservableObject{
    @Published var cryptoID = ""
    @Published var name = ""
    @Published var image = ""
    @Published var symbol = ""
    @Published var amount = 0.0
    @Published var portfolioItem:Portfolio!
    
    func createPortfolio(context:NSManagedObjectContext){
        let portfolio = Portfolio(context: context)
        portfolio.id = cryptoID
        portfolio.amount = amount
        portfolio.symbol = symbol
        portfolio.name = name
        portfolio.image = image
        save(context: context)
    }
    
    func deletePortfolio(context:NSManagedObjectContext, id: String){
        getPortfolio(context: context, id: id)
        context.delete(portfolioItem)
        save(context: context)
    }
    
    func editPortfolio(context:NSManagedObjectContext, isBuy:Bool){
        getPortfolio(context: context, id: cryptoID)
        switch isBuy{
        case true:
            portfolioItem.amount += amount
        default:
            portfolioItem.amount -= amount
        }
        save(context: context)
    }
    
    func save(context:NSManagedObjectContext){
        do{
            try context.save()
            resetVariables()
        }catch{
            
        }
    }
    
    func resetVariables(){
        cryptoID = ""
        name = ""
        image = ""
        symbol = ""
        amount = 0.0
        portfolioItem = nil
    }
    
    func checkPortfolio(context:NSManagedObjectContext, id: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Portfolio")
        fetchRequest.fetchLimit =  1
        fetchRequest.predicate = NSPredicate(format: "id == %@" ,id)
        do {
            let count = try context.count(for: fetchRequest)
            if count > 0 {
                return true
            }else {
                return false
            }
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return false
        }
    }
    
    func getPortfolio(context:NSManagedObjectContext, id: String){
        let fetchRequest: NSFetchRequest<Portfolio> = Portfolio.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@" ,id)
        do {
            let firstPortfolio = try context.fetch(fetchRequest)
            portfolioItem = firstPortfolio[0]
        } catch {
            fatalError("Uh, fetch problem...")
        }
    }
}
