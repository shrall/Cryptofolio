//
//  Persistence.swift
//  cryptofolio
//
//  Created by Marshall Kurniawan on 04/05/22.
//

import Foundation
import CoreData

struct PersistenceController{
    static let shared = PersistenceController()
    
    let container:NSPersistentContainer
    init(inMemory: Bool = false){
        container = NSPersistentContainer(name: "cryptofolio")
        if inMemory{
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores(completionHandler: {(storeDescription, error) in
                                       if let error = error as NSError? {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
                                       }
        )
    }
}
