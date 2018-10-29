//
//  RealmAction.swift
//  Pods-RealmSwiftHelperExample
//
//  Created by ryan on 2018/10/29.
//

import Foundation
import RealmSwift

public enum RealmAction<T: Object> {
    case add(object: T)
    case addObjects(objects: [T])
    case delete(object: T)
    case deleteObjects(objects: [T])
    case update(object: T)
    case updateObjects(objects: [T])
    case query
}
