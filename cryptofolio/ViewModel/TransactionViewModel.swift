//
//  TransactionViewModel.swift
//  cryptofolio
//
//  Created by Marshall Kurniawan on 04/05/22.
//

import Foundation
import Combine
import CoreData

class TransactionViewModel:ObservableObject{
    @Published var cryptoID = ""
    @Published var amount = 0.0
    @Published var isBuy = true
    @Published var transactions:[Transaction] = []
    
    
    func createTransaction(context:NSManagedObjectContext){
        let transaction = Transaction(context: context)
        transaction.id = cryptoID
        transaction.isBuy = isBuy
        transaction.amount = amount
        transaction.date = Date()
        save(context: context)
    }
    
    func deleteTransactions(context:NSManagedObjectContext, id:String){
        getTransactions(context: context, id: id)
        for transaction in transactions {
            context.delete(transaction)
        }
        save(context: context)
    }
    
    
    func getTransactions(context:NSManagedObjectContext, id: String){
        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@" ,id)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        do {
            let allTransactions = try context.fetch(fetchRequest)
            transactions = allTransactions
        } catch {
            fatalError("Uh, fetch problem...")
        }
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
        amount = 0.0
        isBuy = true
    }
}
