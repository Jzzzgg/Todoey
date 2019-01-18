//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Zhuguang Jiang on 1/15/19.
//  Copyright © 2019 Zhuguang Jiang. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    var category_Array = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    func save_Item(){
        
        do{
            try context.save()
        }catch{
            print("Error with saving! \(error)")
        }
        tableView.reloadData()
    }
    func load_Item(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        
        do{
            category_Array = try context.fetch(request)
        }catch{
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category_Array.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = category_Array[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        return cell
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        load_Item()
       
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let DCV = segue.destination as! TodoListViewController
        
        if let indexpath = tableView.indexPathForSelectedRow {
            DCV.selectedCategory = category_Array[indexpath.row]
        }
        
    }
  
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField.init()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let new_Category = Category(context: self.context)
            new_Category.name = textField.text!
                
            self.category_Array.append(new_Category)
            self.save_Item()
        }
        alert.addTextField { (alertTextFiled) in
            alertTextFiled.placeholder = "Create new category"
            textField = alertTextFiled
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
}
