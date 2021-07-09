//
//  Constants.swift
//  SmokingFree
//
//  Created by Jeongho Han on 2021-06-04.
//

import UIKit

struct K {
    static let totalKey = "total"
    
    static let DB = UserDefaults.standard
    
    static let isDoneKey = "isDone"
    
    static let targetDay = "targetDay"
    
    struct CurrentDate {
        static let currentYear = NSCalendar.current.component(.year, from: Date())
        static let currentMonth = NSCalendar.current.component(.month, from: Date())
        static let currentWeek = NSCalendar.current.component(.weekOfYear, from: Date())
        static let today = NSCalendar.current.component(.day, from: Date())
    }
    
}
