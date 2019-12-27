//
//  CoreDataManager.swift
//  CoreData Training
//
//  Created by Deonte on 12/26/19.
//  Copyright © 2019 Deonte. All rights reserved.
//

import CoreData

struct CoreDataManager {
    static let shared = CoreDataManager() // This will last forever as long as your application is still alive, Its properties will too.
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataTrainingModels")
        container.loadPersistentStores { (storeDescription, err) in
            if let err = err {
                fatalError("Loading of store failed: \(err)")
            }
        }
        return container
    }()
    
}
