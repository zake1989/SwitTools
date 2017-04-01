//
//  BaseSQLObject.swift
//  SQLiteDemo
//
//  Created by zeng on 31/03/2017.
//  Copyright © 2017 zengyukai. All rights reserved.
//

import UIKit

class BaseSQLObject: NSObject {
    
    lazy var ID: Int = {
        return Int(Date().timeIntervalSince1970)
    }()
    
    override init() {
        super.init()
    }
    
    func propertyList() -> Array<(propertyName:String, propertyType:String)> {
        // 创建返回列表
        var results: Array<(String, String)> = [];
        // 用 class_copyPropertyList 获取成员变量列表
        var count: UInt32 = 0
        let myClass: AnyClass = self.classForCoder
        // 确保获取到了成员变量列表
        guard let properties = class_copyPropertyList(myClass, &count) else {
            return results
        }
        // 读取列表参数
        for i: Int in 0..<Int(count) {
            let property = properties[i]
            // 获取变量名称 类型
            if let cname = property_getName(property),let ctype = property_getAttributes(property) {
                // 转换成swift的string类型
                let name = String(cString: cname)
                let type = String(cString: ctype)
                results.append((name,type))
            }
        }
        // 释放列表
        free(properties)
        return results
    }
    
    var className: String {
        return String(describing: type(of: self))
    }
    
    func createTableQuery() -> String {
        var query: String = "CREATE TABLE IF NOT EXISTS \(className)(" + "ID INT PRIMARY KEY NOT NULL"
        let properties = propertyList()
        for i: Int in 0..<properties.count {
            let value = properties[i]
            let name = value.propertyName
            let type = value.propertyType.lowercased()
            
            var typeDefineString = "BLOB"
            if type.contains("string") {
                typeDefineString = "CHAR(255)"
            }  else if type.contains("int") {
                typeDefineString = "INT"
            } else if type.contains("float") || type.contains("double") {
                typeDefineString = "DOUBLE"
            }
            if name != "ID" {
                query = query + ", \(name) \(typeDefineString)"
            }
        }
        query = query + ");"
        return query
    }
    
    func dropTableQuery() -> String {
        return "DROP TABLE IF EXISTS \(className);"
    }
    
    func deletQuery() -> String {
        return "DELETE FROM \(className) WHERE ID = \(ID);"
    }
    
    func insertQuery() -> (query: String, dataArray: Array<Any?>) {
        var propertyString = "ID"
        var prototypeString = "?"
        var dataList: [Any?] = []
        dataList.append(self.ID)
        let properties = propertyList()
        for i: Int in 0..<properties.count {
            let value = properties[i]
            let name = value.propertyName
            if name != "ID" {
                propertyString = propertyString+",\(name)"
                prototypeString = prototypeString+",?"
                dataList.append(self.value(forKey: name))
            }
        }
        let query = "INSERT INTO \(className) (\(propertyString)) VALUES (\(prototypeString));"
        return (query,dataList)
    }
    
}

extension BaseSQLObject {
    
    func createTable(complete: (_ error: Error?)->()) {
        let createQuery = self.createTableQuery()
        do {
            try DataBase.sharedInstance.createTable(createQuery)
            complete(nil)
        } catch SQLiteError.prepare(message: let message) {
            complete(SQLiteError.prepare(message: message) as Error)
        } catch SQLiteError.step(message: let message) {
            complete(SQLiteError.step(message: message) as Error)
        } catch {
            complete(SQLiteError.step(message: "Create Fail!") as Error)
        }

    }
    
    func saveToDataBase(complete: (_ error: Error?)->()) {
        let insertData = self.insertQuery()
        do {
            try DataBase.sharedInstance.insert(insertData.query, valueArray: insertData.dataArray)
            complete(nil)
        } catch SQLiteError.prepare(message: let message) {
            complete(SQLiteError.prepare(message: message) as Error)
        } catch SQLiteError.step(message: let message) {
            complete(SQLiteError.step(message: message) as Error)
        } catch {
            complete(SQLiteError.step(message: "Insert Fail!") as Error)
        }
    }
    
    func deleteFromDataBase(complete: (_ error: Error?)->()) {
        let deleteQuery = self.deletQuery()
        do {
            try DataBase.sharedInstance.delete(deleteQuery)
            complete(nil)
        } catch SQLiteError.prepare(message: let message) {
            complete(SQLiteError.prepare(message: message) as Error)
        } catch SQLiteError.step(message: let message) {
            complete(SQLiteError.step(message: message) as Error)
        } catch {
            complete(SQLiteError.step(message: "Delete Fail!") as Error)
        }
    }
    
}
