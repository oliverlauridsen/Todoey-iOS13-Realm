//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Oliver Lauridsen on 05/09/2022.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categories = [CategoryTodo]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(context)
        
        loadItems()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // Fetch a cell of the appropriate type.
       let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
       
       // Configure the cell’s contents.
        cell.textLabel!.text = categories[indexPath.row].name
           
       return cell
    }
    
    // MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
    // MARK: - Data Manipulation Methods


    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // Initialise a text field that we can store the value from the alertTextField later on
        var textField = UITextField()
        
        // Initialise the UIAlertController & text & style
        let alert = UIAlertController(title: "Add new todoey category", message: "", preferredStyle: .alert)
    
        // Define the accept action & button text
        let acceptAction = UIAlertAction(title: "Add", style: .default) { action in
            
            if textField.text != "" {
                
                let newCategory = CategoryTodo(context: self.context)
                newCategory.name = textField.text!
                self.categories.append(newCategory)
                self.saveItems()
                
            }
        }
        
        // Define the cancel action & button text
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("User cancelled the todo creation")
        }
        
        // Add the two actions
        alert.addAction(acceptAction)
        alert.addAction(cancelAction)

        // Add text field to action
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        // Show the alert to the user
        present(alert, animated: true)
        
    }
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print(error)
        }
        tableView.reloadData()
    }
    
    func loadItems(with request:NSFetchRequest<CategoryTodo> = CategoryTodo.fetchRequest()) {
        do {
            categories = try context.fetch(request)
        } catch {
            print(error)
        }
        tableView.reloadData()

    }
}
