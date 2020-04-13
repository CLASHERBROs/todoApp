//
//  CategoryViewController.swift
//  Todoey
//
//  Created by paritosh on 09/04/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//
import RealmSwift
import UIKit
import ChameleonFramework


class CategoryViewController: SwipeTableViewController{
    let realm = try! Realm()
    var categories :Results<Category>?
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
      
        tableView.separatorStyle = .none
        tableView.rowHeight = 80
    
    }
    override func viewWillAppear(_ animated: Bool) {
        if let index = self.tableView.indexPathForSelectedRow{
              self.tableView.deselectRow(at: index, animated: true)
          }
         guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exists.")}
   let bgColor = UIColor(hexString: "1D9BF6")
        navBar.backgroundColor = bgColor
         navBar.standardAppearance.backgroundColor = bgColor
         navBar.scrollEdgeAppearance?.backgroundColor = bgColor
        navBar.scrollEdgeAppearance?.largeTitleTextAttributes = [.foregroundColor: ContrastColorOf(bgColor!, returnFlat: true)]
        navBar.standardAppearance.largeTitleTextAttributes = [.foregroundColor: ContrastColorOf(bgColor!, returnFlat: true)]
     }
    
    
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will hapen once user clicks add item button
            
            let a = textField.text
            let newCategory = Category()
            newCategory.name = a!
            newCategory.colour = UIColor.randomFlat().hexValue()
            
            
            
            self.save(category: newCategory)
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category";
            textField = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
        
        
        
    }
    //MARK: -TableViewDataSourceMethods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1 //nil coalecing operator
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = categories?[indexPath.row]{
             cell.textLabel?.text = categories?[indexPath.row].name ?? "no categories added"
            guard let categoryColor = UIColor(hexString: category.colour) else{fatalError()}
           
            cell.backgroundColor = categoryColor
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        }
      
        return cell
    }
    
    //MARK: -TableViewDelegateMethods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
        // categoryArray[indexPath.row].name
    }
    //    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
    //        cell.delegate = self
    //        return cell
    //    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if  let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row]
            
        }
        
    }
    
    //MARK: -TableViewManipulationMethods
    func save(category: Category){
        
        do{
            try realm.write{
                realm.add(category)
            }
            
        }catch{print("eRROR SAVING DATA")
            
        }
        self.tableView.reloadData()
        
    }
    func loadCategories(){
        categories = realm.objects(Category.self)
        tableView.reloadData()}
    
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row]{
            do{
                try self.realm.write{
                    self.realm.delete(categoryForDeletion.items)
                    self.realm.delete(categoryForDeletion)
                }
                
            }
            catch{
                print(error)
            }
            
            
        }
    }
    
    
    
}
