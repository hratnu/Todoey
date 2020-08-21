//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Harshil Ratnu on 7/27/20.
//  Copyright © 2020 HRatnu. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    let realm = try! Realm()
    var categoryArray : Results<Category>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
    }
    
    //MARK:- TableView DataSource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let color =  UIColor(hexString: categoryArray?[indexPath.row].bgColor ?? "#FFFFFF")
        cell.backgroundColor = color
        cell.textLabel?.textColor = ContrastColorOf(color!, returnFlat: true)
        cell.textLabel?.text =   categoryArray?[indexPath.row].name ?? "No categories added yet"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    
    
    //MARK:- TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        // now we need to get hold of the selected row which trigger the segue
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    
    
    
    //MARK:- Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.bgColor = UIColor.randomFlat().hexValue()
            self.save(category: newCategory)
        }
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Category Name"
            textField = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK:- Data Manipulation Methods
    func loadCategories(){
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    func save(category: Category){
        do{
            try realm.write{
                realm.add(category)
            }
        }catch {
            print("error saving context, \(error)")
        }
        
        
        tableView.reloadData()
    }
    
    
    override func updateModel(at indexPath: IndexPath){
       if let category = self.categoryArray?[indexPath.row]{
           do{
               try self.realm.write {
                   self.realm.delete(category)
               }

           }catch {
               print("error in deleting the cell,  \(error)")
           }
       }
        
    }

}

