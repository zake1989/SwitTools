//
//  ViewController.swift
//  SQLiteDemo
//
//  Created by zeng on 27/03/2017.
//  Copyright © 2017 zengyukai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let man = Man()
        man.avatar = UIImage(named: "image")
        man.name = "Bob"
        
        print(man.ID)
        
        print(man.createTableQuery())
        
        
        
//        let anyobjectype : BaseSQLObject.Type = NSClassFromString("Man")! as! BaseSQLObject.Type
//        let rec: AnyObject = anyobjectype()
//        rec.setValue("haha", forKey: "name")
//        print(rec.value(forKey: "name"))
        
//        let aClass = swiftClassFromString(className: "Man") as! NSObject.Type
//        let newMan = aClass.init()
//        if let newMan = newMan as? BaseSQLObject {
//            let list = newMan.propertyList()
//            print(list)
//            newMan.setValue("haha", forKey: "name")
//            print(newMan.value(forKey: "name"))
//            print(newMan.value(forKey: "ID"))
//        }

        
        
        let databaseFileName = "database.sqlite"
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        let pathToDatabase = documentsDirectory.appending("/\(databaseFileName)")
        
        DataBase.sharedInstance.openDataBase(DBType.persistent(pathToDatabase)) { (error:Error?) in
            if error == nil {
                if let manArray:[Man] = DataBase.sharedInstance.fetchAllDataFromTable(tableName: "Man") as! [Man] {
                    
                }
                
                
//                man.saveToDataBase(complete: { (error:Error?) in
//                    if let error = error {
//                        print(error)
//                    }
//                })
            }
        }
        
//
//        let dbManager = DataBase()
//        do {
//            try dbManager.openDataBaseConnectionWithType(DBType.persistent(pathToDatabase), readOnly: false)
//            print("Successfully opened connection to database.")
//        } catch SQLiteError.openDatabase(let message) {
//            print("\(message)")
//        } catch {
//            print("other error")
//        }
        
//        let createTableString = "DROP TABLE House;"
        
//        let createTableString = "CREATE TABLE Man(" +
//                                "Id INT PRIMARY KEY NOT NULL," +
//                                "Name CHAR(255)," +
//                                "Avatar BLOB);"
        
//        let createTableString = "CREATE TABLE House(" +
//            "ID INT PRIMARY KEY NOT NULL," +
//            "SIZE INT," +
//            "BELONG_TO INT," +
//            "FOREIGN KEY(BELONG_TO) REFERENCES Man(Id));"
//
//        do {
//            try dbManager.createTable(man.createTableQuery())
//            print("table created.")
//        } catch SQLiteError.prepare(message: let message) {
//            print(message)
//        } catch SQLiteError.step(message: let message) {
//            print(message)
//        } catch {
//            print("other error")
//        }

//        let insertStatementString = "INSERT INTO House (ID, SIZE, BELONG_TO) VALUES (?, ?, ?);"
//        
//        let insertData = man.insertQuery()
//        print(insertData.query)
//        print(insertData.dataArray)
//        dbManager.insert(insertData.query, valueArray: insertData.dataArray)
        
//        let insertStatementString = "INSERT INTO Man (Id, Name, Avatar) VALUES (?, ?, ?);"
//
//        let id: Int = 2
//
//        dbManager.insert(insertStatementString, valueArray: [id,"Ada",UIImageJPEGRepresentation(UIImage(named: "image")!, 1.0)!])
//
//        let updateStatementString = "UPDATE Contact SET Name = 'Chrises' WHERE Id = 2;"
//        
//        dbManager.update(updateStatementString)
        
//        let deleteStatementStirng = "DELETE FROM Contact WHERE Id = 3;"
//        
//        dbManager.delete(deleteStatementStirng)
//        
//        let queryStatementString = "SELECT * FROM Man;"
//        
//        dbManager.query(queryStatementString)
        
    }
    
    func swiftClassFromString(className: String) -> AnyClass! {
        if let appName: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
            let classStringName = "\(appName).\(className)"
            // return the class!
            return NSClassFromString(classStringName)
        }
        return nil;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

