//
//  SingleInstance.swift
//  RealmSwiftHelperExample
//
//  Created by ryan on 2018/10/29.
//  Copyright © 2018 bechoed. All rights reserved.
//

import Foundation

class SingleInstance {
    
    private static let instance = SingleInstance()
    private init() {}
    
    public static func shared() -> SingleInstance {
        return instance
    }
    
    public func test() {
        print("测试……")
    }
}
