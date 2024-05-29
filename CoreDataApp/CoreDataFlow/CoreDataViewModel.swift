//
//  CoreDataViewModel.swift
//  CoreDataApp
//
//  Created by Samxal Quliyev  on 24.05.24.
//

import Foundation
import UIKit

class CoreDataViewModel {
    var items = [ToDoList]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var fetchItemCallback: (() -> Void)?
    
    func fetchItems() {
        do {
            items = try context.fetch(ToDoList.fetchRequest())
            fetchItemCallback?()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func saveItem(text: String) {
        do {
            let model = ToDoList(context: context)
            model.title = text
            try context.save()
            fetchItems()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteItem(data: ToDoList) {
        do {
            context.delete(data)
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteItem(index: Int) {
        do {
            context.delete(items[index])
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
