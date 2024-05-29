//
//  ViewController.swift
//  CoreDataApp
//
//  Created by Samxal Quliyev  on 15.05.24.
//

import UIKit

class CoreDataController: UIViewController {
    @IBOutlet weak var table: UITableView!
    
    let viewModel = CoreDataViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.fetchItems()
        viewModel.fetchItemCallback = {
            self.table.reloadData()
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
            self.viewModel.saveItem(text: text)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(ok)
        alertController.addAction(cancel)
        present(alertController, animated: true)
    }
}

extension CoreDataController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = viewModel.items[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        viewModel.deleteItem(index: indexPath.row)
        viewModel.items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
}
