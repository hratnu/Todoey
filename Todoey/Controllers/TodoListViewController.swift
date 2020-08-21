//
//  ViewController.swift
//  Todoey
import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController{
    var realm = try! Realm()
    var itemArray: Results<Item>!
    var defaults = UserDefaults()
  
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0

    }
    
    override func viewWillAppear(_ animated: Bool) {
       
            title = selectedCategory?.name ?? "Items"
//         if let colorHex = selectedCategory?.bgColor{
//            guard let navBar = navigationController?.navigationBar else {
//                fatalError("navigation controller does not exist")
//            }
//
//            navBar.barTintColor = UIColor(hexString: colorHex)
//        }
    }
    
    //MARK:- Table View Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item =  itemArray?[indexPath.row]{
        cell.textLabel?.text = item.title
            if let parentColor = selectedCategory?.bgColor{
                let color = UIColor(hexString: parentColor )!.darken(byPercentage: colorDepth(at: indexPath))
                    cell.backgroundColor = color
                    cell.textLabel?.textColor = ContrastColorOf(color!, returnFlat: true)
                
            }
            
        
        cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No items in this category yet"
        }
        
        return cell
        
    }
    
    //MARK:- Table View delegate Methods -- handles interactions with the table  view
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  
        
        if let item = itemArray?[indexPath.row]{
            do{
                try realm.write{
                    item.done = !item.done
                }
            }catch {
                print("Error in updating check property, \(error)")
            }
        }
        tableView.reloadData()

        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    //MARK:- Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {

        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in

            if let currentCategory = self.selectedCategory {
                   let newItem = Item()
                    newItem.title =  textField.text!
                    newItem.date = Date()
                do{
                       try self.realm.write {
                                //instead of directly adding an item added that into its parents list
                               currentCategory.items.append(newItem)
                       }
                   } catch {
                       print("error in adding item to realm db, \(error)")
                   }
           
            }
            
            self.tableView.reloadData()
     
        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
        }

        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func loadItems(){

        itemArray =  selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()

    }
    
    
    //MARK:- SwipeCellView Deletion

    override func updateModel(at indexPath: IndexPath){
       if let item = self.itemArray?[indexPath.row]{
           do{
               try self.realm.write {
                   self.realm.delete(item)
               }

           }catch {
               print("error in deleting the cell,  \(error)")
           }
       }
        
    }
    
    
    //MARK:- ColorDepth based on indexPath and total items
    func colorDepth(at indexPath: IndexPath) -> CGFloat{
        let percentage = CGFloat(indexPath.row)/CGFloat(itemArray.count)
        return percentage
    }


}

//MARK:- SearchBarDelegate

extension TodoListViewController : UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        itemArray = itemArray?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "date", ascending: false)
        tableView.reloadData()
    }
    
    // to dismiss  the search Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchBar.text?.count == 0){
            loadItems()
            DispatchQueue.main.async{
                searchBar.resignFirstResponder()
            }
        }else{
            searchBarSearchButtonClicked(searchBar)
        }
    }
}


