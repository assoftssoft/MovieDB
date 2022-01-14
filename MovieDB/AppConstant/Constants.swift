//
//  Constants.swift
//  LifSPKStudent
//
//  Created by Ahmed Baloch on 11/11/2019.
//  Copyright © 2019 Ahmed Baloch. All rights reserved.
//

import Foundation
import UIKit


struct ApplicationConstants{
    
    static let Token                                         = "_token"
    static let YearFormat                                    = "yyyy"
    static let DateFormatClient                              = "yyyy-MM-dd" //MM-dd-yyyy
    static let GradeSearchTitle                              = "Grades"
    static let DateFormatServer                              = "dd MMM, yyyy"
    static let UserImageChangNotification                    = "UserImageChangNotification"
}


struct SubmitColor {
    static let red = CGFloat(54.0)
    static let green = CGFloat(137.0)
    static let blue = CGFloat(206.0)
    static let radius = CGFloat(15)
    static let title = "SUBMIT"
}

struct CancelColor {
    static let red = CGFloat(237.0)
    static let green = CGFloat(0.0)
    static let blue = CGFloat(28.0)
    static let radius = CGFloat(15)
    static let title = "OK"
}

struct DefaultSizes{
    static let imageSize = CGSize(width: 200, height: 200)
}


enum DateTimeFormat: String {
    case dateFormat = "dateFormat"
    case timeFormat12Hour = "timeFormat12Hour"
    case dateWithSlashFormat = "dateWithSlashFormat"
    case dateWithMonthName  = "dateWithMonthName"
    case dateMonthYearFormat = "dateMonthYearFormat"
    case monthDateYearFormat = "monthDateYearFormat"
    var value: String {
        switch self {
        case .dateFormat: return "yyyy-MM-dd"
        case .timeFormat12Hour: return "hh:mm a"
        case .dateWithSlashFormat:return "yyyy/MM/dd"
        case .dateWithMonthName:return "MMM dd, yyyy"
        case .dateMonthYearFormat:return "dd-MM-yyyy"
        case .monthDateYearFormat:return "MM-dd-yyyy"
        }
    }
}

enum DateTimeMode: String {
    case date = "date"
    case time = "time"
    var value: Int {
        switch self {
        case .time: return 0
        case .date: return 1
        }
    }
}


var mainSotryboard = UIStoryboard.init(name: "Main", bundle: nil)


