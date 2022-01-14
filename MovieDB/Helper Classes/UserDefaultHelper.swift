//
//  UserDefaultHelper.swift
//  LifSPKStudent
//
//  Created by Ahmed Baloch on 29/10/2019.
//  Copyright © 2019 Ahmed Baloch. All rights reserved.
//

import UIKit
import Foundation


class UserDefaultHelper: NSObject {
    
    static func getData(key: String)->Any?{
        let userDefault:UserDefaults = UserDefaults.standard
        var value : Any?
        if let isExistsDataWithKey = userDefault.value(forKey: key){
            value = isExistsDataWithKey
        }
        return value
    }
    
    static func removeData(key: String){
        let userDefault:UserDefaults = UserDefaults.standard
        userDefault.removeObject(forKey: key)
        userDefault.synchronize()
    }
    
    static func saveData(data: Any, key: String){
        let userDefault:UserDefaults = UserDefaults.standard
        userDefault.set(data, forKey: key)
        userDefault.synchronize()
    }
    
    static func setDataString(data : String , key : String) {
        let userDefault : UserDefaults = UserDefaults.standard
        userDefault.setValue(data, forKeyPath: key)
        userDefault.synchronize()
    }
    
    static func setBool(value: Bool, key: String){
        let userDefault:UserDefaults = UserDefaults.standard
        userDefault.set(value, forKey: key)
        userDefault.synchronize()
    }
    
    static func getBool(key: String)->Bool?{
        let userDefault:UserDefaults = UserDefaults.standard
        var value:Bool?
        if let isExistsDataWithKey = userDefault.value(forKey: key) as? Bool{
            value = isExistsDataWithKey
        }
        return value
    }
}
