//
//  DAO.swift
//  CoreDataDemo
//
//  Created by Gabriel Maia Vinagre Costa on 18/08/17.
//  Copyright © 2017 gabrielVinagre. All rights reserved.
//

import Foundation
import UIKit
import CoreData


//Data Access Object
final class DAO {
    
    static func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
        return appDelegate.persistentContainer.viewContext
    }
    
    //static function cannot be declared if it are using class` properties
    
    
    static func createData(name:String) {
        
        let managedObjectContext = DAO.getContext()
        
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedObjectContext)
        
        let newPerson = NSManagedObject(entity: entity!, insertInto: managedObjectContext)
        
        newPerson.setValue(name, forKey: "name")
        
        DAO.saveContext()
        DataAPI.shared.people.append(newPerson as! Person)
        
    }
    
    static func getAllData(){
        
        let managedObjectContext = DAO.getContext()
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:"Person")
        
        do{
            let people = try managedObjectContext.fetch(fetchRequest)
            DataAPI.shared.people = people as! [Person]
            //sort the array alphabetically
//            DataAPI.shared.people = (people as! [Person]).sorted{$0.name! < $1.name!}
        }catch let error as NSError{
            print("Could not fetch. \(error), \(error.userInfo)")

        }
        
    }
    
    static func deleteData(id: NSManagedObjectID!){
        let managedObjectContext = DAO.getContext()
        
        let person = managedObjectContext.object(with: id)
        managedObjectContext.delete(person)
        
        DAO.saveContext()
        var elementIndex:Int = DAO.elementSearch(id: id)
        
        DataAPI.shared.people.remove(at: elementIndex)
        
    }
    
    static func updateData(id: NSManagedObjectID!, newName:String!){
        let managedObjectContext = DAO.getContext()
        let person = managedObjectContext.object(with: id) as! Person
//        let oldName = person.name
        person.name =  newName
        DAO.saveContext()
        var elementIndex:Int = DAO.elementSearch(id: id)
        
        DataAPI.shared.people[elementIndex].name = newName
    }
    
    private static func saveContext(){
        let managedObjectContext = DAO.getContext()
        do{
            try managedObjectContext.save()
        }catch let error as NSError{
            print(error)
        }
    }
    
    static func elementSearch(id:NSManagedObjectID)->Int{
        let managedObjectContext = DAO.getContext()
        let person = managedObjectContext.object(with: id) as! Person
        let i = DataAPI.shared.people.index(where:{$0.name == person.name})
        return i!
    }
    
    
    
}
