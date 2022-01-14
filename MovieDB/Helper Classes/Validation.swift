//
//  Validation.swift
//  LifSPKStudent
//
//  Created by Ahmed Baloch on 29/10/2019.
//  Copyright © 2019 Ahmed Baloch. All rights reserved.
//

import UIKit

class Validation: NSObject {
    struct ValidationKeys {
        static let PASSWORD_MIN_LENGTH = 6
    }
    
    class func isEmpty(string: String) -> Bool {
        
        let trimmed = string.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        if trimmed.isEmpty{
            return true
        }
        else {
            return false
        }
    }
    
    class func isEmpty(string: String, fieldName: String, controller viewController: AnyObject) -> Bool {
        let trimmed = string.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        if trimmed.isEmpty{
            Alert.showAlert(title: "\(fieldName) Field", message: fieldName+Alert.Message.ALERT_FIELD_EMPTY, vc: viewController as! UIViewController)
            return true
        }
        else {
            return false
        }
        
    }
    
    class func ValidateNumber(myStr: String, fieldName: String, controller viewController: AnyObject) -> Bool {
        let strMatchstring: String = "\\b([0-9%_.+\\-]+)\\b"
        let textpredicate: NSPredicate = NSPredicate(format: "SELF MATCHES %@", strMatchstring)
        let result: Bool = textpredicate.evaluate(with: myStr)
        if !result {
            
            Alert.showAlert(title: "\(fieldName) Field", message: Alert.Message.ALERT_INVLALID_CONTACT, vc: viewController as! UIViewController)
            
        }
        return result
    }
    
    class func isValidEmailAddress(emailAddress: String, controller viewController: AnyObject) -> Bool {
        let emailRegex: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        let result: Bool = emailTest.evaluate(with: emailAddress)
        if !result {
            
            Alert.showAlert(title: "Email Address Field", message: Alert.Message.ALERT_INVALID_EMAIL, vc: viewController as! UIViewController)
        }
        return result
    }
    
    class func isMinimumLength(str: String, fieldName:String, minCharacters: Int, controller viewController: AnyObject) -> Bool {
        let result: Bool = (str.count >= minCharacters)
        if !result {
            Alert.showAlert(title: "\(fieldName) Field", message: String(format:Alert.Message.ALERT_PASSWORD_MINIMUM_CHARACTERS,arguments:[minCharacters]), vc: viewController as! UIViewController)
        }
        return result
    }
    
    class func checkPasswordValidity(str: String, controller viewController: AnyObject) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Z])(?=.*\\d)[A-Za-z\\d$@$!%*?&]{8,}")
        let result:Bool =  passwordTest.evaluate(with: str)
        
        if !result {
            Alert.showAlert(title: "Password Field", message: String(format:Alert.Message.PASSWORD_INVALID_MSG), vc: viewController as! UIViewController)
        }
        
        return result
    }
    
    class func isLength(password: String, maxCharacters: Int, fieldName: String, controller viewController: AnyObject) -> Bool {
        let result: Bool = (password.count <= maxCharacters)
        if !result {
            Alert.showAlert(title: "\(fieldName) Field", message:
                String(format:Alert.Message.ALERT_PASSWORD_MAXIMUM_CHARACTERS,arguments:[maxCharacters]) , vc: viewController as! UIViewController)
        }
        return result
    }
    class func containsAlphabetOnly(str: String, fieldName: String, controller viewController: AnyObject) -> Bool {
        let regex: String = "[a-zA-Z ]+"
        let test: NSPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let result: Bool = test.evaluate(with: str)
        if !result {
            Alert.showAlert(title: "\(fieldName) Field", message: Alert.Message.ALERT_ALPHABETS_ALLOWED, vc: viewController as! UIViewController)
        }
        return result
    }
    
    class func isValidPassword(password: String, confirmPassword: String, controller viewController: AnyObject) -> Bool {
        if !(password == confirmPassword) {
            Alert.showAlert(title: "Error", message: Alert.Message.ALERT_PASSWORD_MISMATCH, vc: viewController as! UIViewController)
            return false
        }
        return true
    }
    
    class func formatNumber(number: String) -> String {
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "(XXX) XXX-XXXX"
        
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask {
            if index == cleanPhoneNumber.endIndex {
                break
            }
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    class func textFieldEmptyValidation(fieldsArr: [UITextField]) -> Bool {
        for mytextfield: UITextField in fieldsArr {
            let rawString: String = mytextfield.text!
            let trimmed: String = rawString.trimmingCharacters(in:NSCharacterSet.whitespacesAndNewlines)
            if trimmed.count == 0 || (rawString == "") {
                return false
            }
        }
        return true
    }
    
    class func isValidDateOrder( firstDate: NSDate, secondDate: NSDate) -> Bool {
        
        let calender = NSCalendar.current
        
        let comp1 = calender.dateComponents([.day,.month,.year], from: firstDate as Date)
        let comp2 = calender.dateComponents([.day,.month,.year], from: secondDate as Date)
        
        let date1 = calender.date(from: comp1)
        let date2 = calender.date(from: comp2)
        
        let result = date1!.compare(date2!)
        
        var returnVal = false;
        
        switch (result)
        {
        case .orderedAscending: returnVal = true;  break;
        case .orderedDescending: returnVal = false; break;
        case .orderedSame: returnVal = true; break;
        }
        return returnVal;
    }
    
    class func isValidDate( givenDate: NSDate) -> Bool {
        
        let calender = NSCalendar.current
        
        let comp1 = calender.dateComponents([.day,.month,.year], from: givenDate as Date)
        let comp2 = calender.dateComponents([.day,.month,.year], from: Date() )
        
        let date1 = calender.date(from: comp1)
        let date2 = calender.date(from: comp2)
        
        let result = date1!.compare(date2!)
        
        var returnVal = false;
        
        switch (result)
        {
        case .orderedAscending: returnVal = true;  break;
        case .orderedDescending: returnVal = false; break;
        case .orderedSame: returnVal = true; break;
        }
        return returnVal;
    }
    
    class func isValidTime( givenTime: NSDate) -> Bool {
        
        let calender = NSCalendar.current
        
        let comp1 = calender.dateComponents([.hour], from: givenTime as Date)
        let comp2 = calender.dateComponents([.hour], from: Date() )
        
        let date1 = calender.date(from: comp1)
        let date2 = calender.date(from: comp2)
        
        let result = date1!.compare(date2!)
        
        var returnVal = false;
        
        switch (result)
        {
        case .orderedAscending: returnVal = false;  break;
        case .orderedDescending: returnVal = true; break;
        case .orderedSame: returnVal = false; break;
        }
        return returnVal;
    }
}
