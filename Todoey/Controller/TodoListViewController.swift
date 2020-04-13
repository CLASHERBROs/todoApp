//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class TodoListViewController: SwipeTableViewController{
    var todoItems:Results<Item>?
    let realm = try! Realm()
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
   
    
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
       
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.separatorStyle = .none
        print(FileManager.default.urls(for: .documentDirectory, in: . userDomainMask))
       
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
           title = selectedCategory!.name
         
        searchBar.backgroundColor = UIColor(hexString: selectedCategory!.colour)
       
        if let colorHex = selectedCategory?.colour {
            guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exists.")
                }
            if let navBarColour = UIColor(hexString: selectedCategory!.colour)
            {
                navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:ContrastColorOf(navBarColour, returnFlat: true)]
            }
            
            if let bgColor = UIColor(hexString: colorHex) {
              
                navBar.backgroundColor = bgColor
                navBar.standardAppearance.backgroundColor = bgColor
                navBar.scrollEdgeAppearance?.backgroundColor = bgColor
                navBar.scrollEdgeAppearance?.largeTitleTextAttributes = [.foregroundColor: ContrastColorOf(bgColor, returnFlat: true)]
                navBar.standardAppearance.largeTitleTextAttributes = [.foregroundColor: ContrastColorOf(bgColor, returnFlat: true)]
            }
        }
  
       
        
       
               
               
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let arrayCount = todoItems?.count else { return 1 }
        print ("category has \(arrayCount) cells")
        if arrayCount == 0 {
            return 1
        } else {
            return arrayCount
        }
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if todoItems!.count == 0 {
            cell.textLabel?.text = "No items for this category"
        } else {
            if let item = todoItems?[indexPath.row] {
                let clour=UIColor(hexString:  selectedCategory?.colour ?? "#FFFFFF")
                cell.textLabel?.text = item.title
                if let colour = clour!.darken(byPercentage:
                                CGFloat(indexPath.row)/CGFloat(todoItems!.count))
               {  cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
                }
                cell.accessoryType = item.done ? .checkmark : .none
              
                            
                
            }
        }
        
        return cell
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row]{
            do{
            try realm.write{
                item.done = !item.done
                }
                
            }
            catch{
                print("error")
            }
        }
        tableView.reloadData()
       
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = self.todoItems?[indexPath.row]{
                   do{
                       try self.realm.write{
                       
                           self.realm.delete(itemForDeletion)
                       }
                       
                   }
                   catch{
                       print(error)
                   }
                   
                   
               }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will hapen once user clicks add item button
            
            let a = textField.text
            if let currentCategory = self.selectedCategory{
                
                
                do{
                    try  self.realm.write{
                        let newItem = Item()
                        newItem.title = a ?? "Add a item"
                        newItem.seconds = Float(NSDate().timeIntervalSince1970)
        currentCategory.items.append(newItem)
                        
                        
                    }
                    
                }
                catch{
                    print(error)
                }
                
            }
            self.tableView.reloadData()
            
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item";
            textField = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func loadItems(){
        todoItems = selectedCategory?.items.sorted(byKeyPath: "seconds", ascending: false)
        
        tableView.reloadData()
        
        
    }
    
}

 extension TodoListViewController: UISearchBarDelegate {
 
    
    //MARK: Search Bar Delegate Methods
func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let char = searchText.cString(using: String.Encoding.utf8)
        let isBackspace = strcmp(char, "\\b")
        
        if searchBar.text?.count == 0 {
            // only triggers after text is entered, then del all chars or hit cross
            loadItems()
            self.tableView.reloadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
            else if isBackspace == -92{
                loadItems()
                self.tableView.reloadData()
            }
        else{
            loadItems()
            todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "seconds", ascending: false)
            tableView.reloadData()
            
 
        }
    }
 
}
