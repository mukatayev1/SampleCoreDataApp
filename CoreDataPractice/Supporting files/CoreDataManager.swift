//
//  CoreDataManager.swift
//  CoreDataPractice
//
//  Created by Aidos Mukatayev on 2022/04/20.
//

import UIKit

class CoreDataManager {
    
    static let shared = CoreDataManager()
    private init() {}
    
    func accessContainer() {
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            
            let container = appDelegate.persistentContainer.viewContext
            
            
        }
    }
}
