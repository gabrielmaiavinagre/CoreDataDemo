//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Gabriel Maia Vinagre Costa on 14/08/17.
//  Copyright © 2017 gabrielVinagre. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDataSource {
    
    @IBAction func addName(_ sender: Any) {
        
        var title = "New Name"
        var message = "Add new name"
        
        
        if sender is Int{
            title = "Change Name"
            message = "Change the name"
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default){
            [unowned self] action in
            
            guard let textField = alert.textFields?.first,
                let nameToSave = textField.text else {
                    return
            }
            if sender is Int{
                DAO.updateData(id: DataAPI.shared.people[sender as! Int].objectID, newName: nameToSave)
            }
            else{
                var newItem = DAO.createData(name: nameToSave)
            }
            
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        
        
        present(alert, animated: true)
        
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var contextManagedObject: NSManagedObjectContext!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "The list"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        DAO.getAllData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataAPI.shared.people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let person = DataAPI.shared.people[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        
        cell.textLabel?.text = person.value(forKey: "name") as? String
        return  cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        addName(indexPath.row)
        
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete
        {
            DAO.deleteData(id:DataAPI.shared.people[indexPath.row].objectID )
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}

