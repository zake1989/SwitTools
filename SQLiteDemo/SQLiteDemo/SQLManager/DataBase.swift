//
//  DataBase.swift
//  SQLiteDemo
//
//  Created by zeng on 27/03/2017.
//  Copyright © 2017 zengyukai. All rights reserved.
//

import UIKit

enum DBType {
    case inMemory
    case temporary
    case persistent(String)
    
    public var description: String {
        switch self {
        case .inMemory:
            return ":memory:"
        case .temporary:
            return ""
        case .persistent(let URI):
            return URI
        }
    }
}

enum SQLDataType: NSInteger {
    case TINTEGER = 1
    case TFLOAT = 2
    case TTEXT = 3
    case TBLOB = 4
    case TNULL = 5
}

enum SQLiteError: Error {
    case openDatabase(message: String)
    case prepare(message: String)
    case step(message: String)
    case bind(message: String)
}

class DataBase {
    
    static let sharedInstance = DataBase()
    
    private init() {
        
    }
    
    public var db: OpaquePointer? = nil
    
    func openDataBaseConnectionWithType(_ databaseType: DBType, readOnly: Bool = false) throws {
        // SQLITE_OPEN_CREATE 开启时候 如果没有就创建数据库
        // SQLITE_OPEN_READONLY 为只读模式 开启后 无法插入 ⚠️ 只读不能和SQLITE_OPEN_CREATE模式混用
        let flags = readOnly ? SQLITE_OPEN_READONLY :  SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE
        
        // SQLITE_OPEN_FULLMUTEX 开启的是串行模式天生带有线程保护 
        // 对应的模式是 SQLITE_OPEN_NOMUTEX 开启的是多线程的保护模式
        
        if sqlite3_open_v2(databaseType.description, &db, flags |
            SQLITE_OPEN_FULLMUTEX
            , nil) == SQLITE_OK {
            
        } else {
            defer {
                if db != nil {
                    sqlite3_close(db)
                    db = nil
                }
            }
            
            if let error = sqlite3_errmsg(db) {
                throw SQLiteError.openDatabase(message: String(cString: error))
            } else {
                throw SQLiteError.openDatabase(message: "No error message provided from sqlite.")
            }
        }
    }

    func createTable(_ sql:String) throws {
        guard (db != nil) else {
            throw SQLiteError.openDatabase(message: "Database connection not created.")
        }
        
        var createStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, sql, -1, &createStatement, nil) == SQLITE_OK {
            if sqlite3_step(createStatement) == SQLITE_DONE {
                
            } else {
                throw SQLiteError.step(message: String(cString: sqlite3_errmsg(createStatement)))
            }
        } else {
            throw SQLiteError.prepare(message: String(cString: sqlite3_errmsg(db)))
        }
        sqlite3_finalize(createStatement)
    }
    
    func insert(_ sql:String, valueArray:Array<Any?>) throws {
        guard (db != nil) else {
            throw SQLiteError.openDatabase(message: "Database connection not created.")
        }
        
        var insertStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, sql, -1, &insertStatement, nil) == SQLITE_OK {
            
            for index : Int in 1...valueArray.count {
                bindObject(valueArray[index-1], toColumn: index, inStatement: insertStatement!)
            }
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                
            } else {
                throw SQLiteError.step(message: String(cString: sqlite3_errmsg(insertStatement)))
            }
        }  else {
            throw SQLiteError.prepare(message: String(cString: sqlite3_errmsg(db)))
        }
        sqlite3_finalize(insertStatement)
    }
    
    func update(_ sql:String) {
        guard (db != nil) else {
            return
        }
        
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, sql, -1, &updateStatement, nil) == SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated row.")
            } else {
                print("Could not update row.")
            }
        } else {
            print("UPDATE statement could not be prepared")
        }
        sqlite3_finalize(updateStatement)
    }
    
    func delete(_ sql:String) throws {
        guard (db != nil) else {
            throw SQLiteError.openDatabase(message: "Database connection not created.")
        }
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, sql, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                
            } else {
                throw SQLiteError.step(message: String(cString: sqlite3_errmsg(deleteStatement)))
            }
        } else {
            throw SQLiteError.prepare(message: String(cString: sqlite3_errmsg(db)))
        }
        sqlite3_finalize(deleteStatement)
    }
    
    func query(_ sql:String) throws -> [[String:Any]]? {
        
        guard (db != nil) else {
            throw SQLiteError.openDatabase(message: "Database connection not created.")
        }
        
        var queryStatement: OpaquePointer? = nil

        if sqlite3_prepare_v2(db, sql, -1, &queryStatement, nil) == SQLITE_OK {
            
            var dataResult: [[String:Any]] = []
            
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                
                let count:Int32=sqlite3_column_count(queryStatement)
                var dataDic:[String:Any] = [:]
                for i: Int32 in 0..<count {
                    
                    let dataType = sqlite3_column_type(queryStatement, i)
                    
                    let name =  String(cString: sqlite3_column_name(queryStatement, i))
                    
                    if let realType = SQLDataType.init(rawValue: NSInteger(dataType)) {
                        switch realType {
                        case SQLDataType.TINTEGER:
                            print("integer")
                            dataDic[name] = sqlite3_column_int(queryStatement, i)
                        case SQLDataType.TFLOAT:
                            print("float")
                            dataDic[name] = sqlite3_column_double(queryStatement, i)
                        case SQLDataType.TTEXT:
                            print("text")
                            dataDic[name] = String(cString: sqlite3_column_text(queryStatement, i))
                        case SQLDataType.TBLOB:
                            print("blob")
                            let length = sqlite3_column_bytes(queryStatement, i)
                            let point = sqlite3_column_blob(queryStatement, i)
                            let imageData = NSData(bytes: point, length: Int(length))
                            dataDic[name] = imageData
                        case SQLDataType.TNULL:
                            dataDic[name] = nil
                            print("null")
                        }
                    }
                }
                dataResult.append(dataDic)
            }
            print("\(dataResult)")
            return dataResult
        } else {
            throw SQLiteError.prepare(message: String(cString: sqlite3_errmsg(db)))
        }
        sqlite3_finalize(queryStatement)
        return nil
        
    }
    
    func bindObject(_ value: Any?, toColumn index:Int, inStatement stmt: OpaquePointer) {
        if value == nil {
            print("nil")
            sqlite3_bind_null(stmt, Int32(index))
        } else if let value = value as? NSData {
            print("data")
            sqlite3_bind_blob(stmt, Int32(index), value.bytes, Int32(value.length), unsafeBitCast(-1, to: sqlite3_destructor_type.self))
        } else if let value = value as? Double {
            print("double")
            sqlite3_bind_double(stmt, Int32(index), value)
        } else if let value = value as? Int64 {
            print("Int64")
            sqlite3_bind_int64(stmt, Int32(index), value)
        } else if let value = value as? String {
            print("string")
            sqlite3_bind_text(stmt, Int32(index), value, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
        } else if let value = value as? Int {
            print("Int")
            sqlite3_bind_int(stmt, Int32(index), Int32(value))
        } else if let value = value as? Bool {
            print("Bool")
            sqlite3_bind_int(stmt, Int32(index), (value ? 1 : 0))
        } else if let value = value as? UIImage {
            print("image")
            guard let data = UIImageJPEGRepresentation(value, 1.0) as NSData? else {
                return
            }
            sqlite3_bind_blob(stmt, Int32(index), data.bytes, Int32(data.length), unsafeBitCast(-1, to: sqlite3_destructor_type.self))
        } else if let value = value {
            fatalError("tried to bind unexpected value \(value)")
        }
    }
    
}

extension DataBase {
    func openDataBase(_ databaseType: DBType, readOnly: Bool = false, complete: (_ error: Error?)->()) {
        do {
            try self.openDataBaseConnectionWithType(databaseType, readOnly: readOnly)
            complete(nil)
        } catch SQLiteError.openDatabase(let message) {
            complete(SQLiteError.openDatabase(message: message) as Error)
        } catch {
            complete(SQLiteError.openDatabase(message: "Other error!") as Error)
        }
    }
    
    func fetchAllDataFromTable(tableName: String) -> [BaseSQLObject]? {
        let query = "SELECT * FROM \(tableName);"
        
        do {
            let resultArray = try self.query(query)
            
            for dataDic:[String:Any] in resultArray! {
                let aClass = swiftClassFromString(className: tableName) as! NSObject.Type
                if let sqlObject = aClass.init() as? BaseSQLObject {
                    let list = sqlObject.propertyList()
                    for property:(propertyName:String, propertyType:String) in list {
                        let name = property.propertyName
                        let type = property.propertyType.lowercased()
                        if type.contains("image") {
                            
                        } else if type.contains("int") {
                        
                        } else if type.contains("float") || type.contains("double") {
                        
                        } else if type.contains("string") {
                        
                        }
                    }
                }
            }
            
        } catch SQLiteError.openDatabase(let message) {
            
        } catch SQLiteError.step(message: let message) {
        
        } catch {
            
        }
    
        return nil
    }

    
    func sqlObjectFrom(className: String) -> NSObject? {
        if let aClass = swiftClassFromString(className: className) as? NSObject.Type {
            return aClass.init()
        }
        return nil
    }
    
    func swiftClassFromString(className: String) -> AnyClass! {
        if let appName: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
            let classStringName = "\(appName).\(className)"
            return NSClassFromString(classStringName)
        }
        return nil
    }
}
