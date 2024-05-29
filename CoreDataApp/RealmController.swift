//
//  RealmController.swift
//  CoreDataApp
//
//  Created by Samxal Quliyev  on 17.05.24.
//

import UIKit
import RealmSwift

class TodoListRealm: Object {
    @Persisted var title: String
}


class RealmController: UIViewController {
    @IBOutlet weak var table: UITableView!
    
    var items = [TodoListRealm]()
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = realm.configuration.fileURL {
            print(url)
        }
        
        getItems()
    }
    
    func getItems() {
        items.removeAll()
        let data = realm.objects(TodoListRealm.self)
        items.append(contentsOf: data)
        table.reloadData()
    }
    
    func saveItem(text: String) {
        do {
            let model = TodoListRealm()
            model.title = text
            try realm.write {
                realm.add(model)
                items.append(model)
                table.insertRows(at: [IndexPath(row: items.count-1, section: 0)], with: .fade)
//                getItems()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Enter new item",
                                                message: "",
                                                preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Add new item"
        }
        let ok = UIAlertAction(title: "Add", style: .default) { _ in
//            let text = alertController.textFields?.first?.text ?? ""
            let text = alertController.textFields?[0].text ?? ""
            self.saveItem(text: text)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(ok)
        alertController.addAction(cancel)
        present(alertController, animated: true)
    }
}

extension RealmController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row].title
        return cell
    }
}
