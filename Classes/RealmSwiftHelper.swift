//
//  RealmSwiftHelper.swift
//  RealmSwiftHelperExample
//
//  Created by ryan on 2018/10/26.
//  Copyright © 2018 bechoed. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

public class RealmSwiftHelper {
    
    private static let instance = RealmSwiftHelper()
    private lazy var configurations: [String: Realm.Configuration] = Dictionary()
    public lazy var newSchemaVersion = {
        return UInt64((Bundle.main.infoDictionary?["CFBundleVersion"] as! String))!
    }()
    
    private init() {}
    
    public static func shared() -> RealmSwiftHelper {
        return instance
    }
    
    /// 配置数据库
    ///
    /// - Parameter dbName: 数据库名字
    /// - Returns: Single<Bool>
    public func config(dbName: String, migration: MigrationBlock? = nil) -> Single<Bool> {
        return Single.create(subscribe: {[unowned self] emitter -> Disposable in
            if self.configurations.keys.contains(dbName) {
                emitter(.success(true))
                return Disposables.create()
            }
            if dbName.isEmpty {
                print("dbName is nil, while it cannot be nil!")
                emitter(.error(RealmSwiftHelperError.emptyDatabasename))
                return Disposables.create()
            }
            var configuration = Realm.Configuration.defaultConfiguration
            configuration.schemaVersion = self.newSchemaVersion
            configuration.migrationBlock = migration
            guard let dir = configuration.fileURL?.deletingLastPathComponent().appendingPathComponent("\(dbName).realm") else {
                emitter(.error(RealmSwiftHelperError.fileSystemError))
                return Disposables.create()
            }
            configuration.fileURL = dir
            do {
                _ = try Realm(configuration: configuration)
                self.configurations[dbName] = configuration
                emitter(.success(true))
            } catch {
                print("Realm对象创建失败\(error)")
                emitter(.error(error))
            }
            return Disposables.create()
        })
    }
    
    public func realm(dbName: String = "default") -> Realm? {
        guard let config = configurations[dbName] else {
            return nil
        }
        do {
            return try Realm(configuration: config)
        } catch {
            print("Realm创建失败\(error)")
            return nil
        }
    }
    
    /// Realm写入操作
    ///
    /// - Parameters:
    ///   - action: 写入类型
    ///   - dbName: 数据库名称
    /// - Returns: Single<Bool>
    public func write<T: Object>(action: RealmAction<T>, dbName: String = "default") -> Single<Bool> {
        return config(dbName: dbName).map({ _ -> Bool in
            let config = self.configurations[dbName]
            let realm = try Realm(configuration: config!)
            try realm.write {
                switch action {
                case .add(let object):
                    realm.add(object, update: true)
                case .addObjects(let objects):
                    realm.add(objects, update: true)
                case .delete(let object):
                    realm.delete(object)
                case .deleteObjects(let objects):
                    realm.delete(objects)
                case .update(let object):
                    realm.add(object, update: true)
                case .updateObjects(let objects):
                    realm.add(objects, update: true)
                default:
                    throw RealmSwiftHelperError.unsupportAction(message: "该方法不支持查询")
                }
            }
            return true
        })
    }
    
}
