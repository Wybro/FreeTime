//
//  Extensions.swift
//  Free Time
//
//  Created by Connor Wybranowski on 12/15/16.
//  Copyright © 2016 com.Wybro. All rights reserved.
//

import Foundation

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date? {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)
    }
}
