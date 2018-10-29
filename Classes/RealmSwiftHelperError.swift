//
//  RealmSwiftHelperError.swift
//  Pods-RealmSwiftHelperExample
//
//  Created by ryan on 2018/10/26.
//

import Foundation

public enum RealmSwiftHelperError: Error {
    case emptyDatabasename
    case fileSystemError
    case unsupportAction(message: String)
    case databaseNotConfigured
}
