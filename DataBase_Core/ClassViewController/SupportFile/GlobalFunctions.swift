//
//  GlobalFunctions.swift
//  DataBase_Core
//
//  Created by w3OnDemand on 19/02/20.
//  Copyright © 2020 w3OnDemand. All rights reserved.
//

import UIKit
import CoreData
import Foundation
import SystemConfiguration

class GlobalFunctions: NSObject {
    
    static let shareInstance = GlobalFunctions()
    
    struct GlobalConstants {
        
        static let AppName = "DataBase_Core"
        static let KappDelegate = UIApplication.shared.delegate as! AppDelegate
    }
    
    func emptyChecker(_ textString:String) -> Bool {
        
        let boolValue = textString.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        return boolValue.isEmpty
    }
    
    
    //MARK:- Data Base -> CreateData
    func insertData(_ emp_Details: [String:String], emp_ProfileImage: NSData) -> String {
        
        var status = ""
        //Container is set up in the AppDelegates so we need to refer that container.
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate
        {
            //Create a context from this container
            let managedContext = appDelegate.persistentContainer.viewContext
            
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "EmployDetails")
            fetchRequest.predicate = NSPredicate(format: "emp_id = %@", emp_Details["id"]!)
            
            do
            {
                let test = try managedContext.fetch(fetchRequest)
                if test.count == 0 {
                    
                    //Create an entity and new user records.
                    let userEntity = NSEntityDescription.entity(forEntityName: "EmployDetails", in: managedContext)!
                    
                    let EMP = NSManagedObject(entity: userEntity, insertInto: managedContext)
                    EMP.setValue(emp_ProfileImage, forKey: "emp_image")
                    EMP.setValue(emp_Details["id"]!, forKey: "emp_id")
                    EMP.setValue(emp_Details["name"]!, forKey: "emp_name")
                    EMP.setValue(emp_Details["email_ID"]!, forKey: "emp_email_id")
                    EMP.setValue(emp_Details["password"]!, forKey: "emp_password")
                    
                    //Now we have set all the values. the next step is to save them inside the core data
                    do {
                        
                        status = "200"
                        try managedContext.save()
                    } catch let error as NSError {
                        
                        status = "400"
                        print("Could not save. \(error), \(error.userInfo)")
                    }
                }
                else
                {
                    status = "401"
                }
            } catch {
                
                print(error)
            }
        }
        return status
    }
    
    //MARK:- Data Base -> Retrieve Data
    func retrieveData(completion: @escaping (_ result: AnyObject?, _ error: String?) -> Void) {
        
        //Container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //Create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Prepare the request of type NSFetchRequest for the entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EmployDetails")
        
        do {
            
            let result = try managedContext.fetch(fetchRequest)
            
            let arrDataList = NSMutableArray()
            var dictData = NSMutableDictionary()
            for data in result as! [NSManagedObject] {
                
                dictData = NSMutableDictionary()
                dictData.setValue(data.value(forKey: "emp_image"), forKey: "profileImage")
                dictData.setValue(data.value(forKey: "emp_id"), forKey: "id")
                dictData.setValue(data.value(forKey: "emp_name"), forKey: "name")
                dictData.setValue(data.value(forKey: "emp_email_id"), forKey: "email_ID")
                dictData.setValue(data.value(forKey: "emp_password"), forKey: "password")
                arrDataList.add(dictData)
            }
            completion(arrDataList, nil)
        } catch {
            
            print("Failed")
            completion(nil, "Failed")
        }
    }
    
    //MARK:- Data Base -> Update Data
    func updateData(_ employee_Id: String, newUpdateDict: [String:String], emp_ProfileImage: NSData) -> String {
        
        var status = ""
        //Container is set up in the AppDelegates so we need to refer that container.
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate
        {
            
            //Create a context from this container
            let managedContext = appDelegate.persistentContainer.viewContext
            
            //Prepare the request of type NSFetchRequest for the entity
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "EmployDetails")
            fetchRequest.predicate = NSPredicate(format: "emp_id = %@", employee_Id)
            
            do
            {
                let test = try managedContext.fetch(fetchRequest)
                if let EMP = test[0] as? NSManagedObject
                {
                    EMP.setValue(newUpdateDict["id"], forKey: "emp_id")
                    EMP.setValue(newUpdateDict["name"], forKey: "emp_name")
                    EMP.setValue(newUpdateDict["email_ID"], forKey: "emp_email_id")
                    EMP.setValue(newUpdateDict["password"], forKey: "emp_password")
                    EMP.setValue(emp_ProfileImage, forKey: "emp_image")
                }
                
                do {
                    
                    try managedContext.save()
                    status = "200"
                    
                } catch let error as NSError {
                    
                    print("Could not save. \(error), \(error.userInfo)")
                    status = "400"
                }
                
            } catch {
                
                print(error)
            }
        }
        return status
    }
    
    //MARK:- Data Base -> Delete Data
    func deleteData(_ employee_Id: String) -> String {
        
        var status = ""
        //Container is set up in the AppDelegates so we need to refer that container.
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate
        {
            
            //Create a context from this container
            let managedContext = appDelegate.persistentContainer.viewContext
            
            //Prepare the request of type NSFetchRequest for the entity
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EmployDetails")
            fetchRequest.predicate = NSPredicate(format: "emp_id = %@", employee_Id)
            
            do
            {
                let test = try managedContext.fetch(fetchRequest)
                let objectToDelete = test[0] as! NSManagedObject
                managedContext.delete(objectToDelete)
                
                do {
                    
                    try managedContext.save()
                    status = "200"
                    
                } catch let error as NSError {
                    
                    print("Could not save. \(error), \(error.userInfo)")
                    status = "400"
                }
            } catch {
                
                print(error)
            }
        }
        return status
    }
}
