//
//  CoreDataManager.swift
//  Navigation
//
//  Created by Toha Shilin on 2.12.25.
//
import CoreData
import Foundation
import StorageService

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
}
