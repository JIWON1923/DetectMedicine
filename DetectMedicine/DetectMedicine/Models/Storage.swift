//
//  Storage.swift
//  DetectMedicine
//
//  Created by 이지원 on 2022/09/01.
//

import Foundation

public class Storage {
    static func isFirstTime() -> Bool {
        let defaults = UserDefaults.standard
        
        if defaults.object(forKey: "isFirst") == nil {
            return true
        } else {
            return false
        }
    }
}
