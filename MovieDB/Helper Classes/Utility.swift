//
//  Utility.swift
//  LifSPKStudent
//
//  Created by Ahmed Baloch on 29/10/2019.
//  Copyright © 2019 Ahmed Baloch. All rights reserved.
//

import UIKit

class Utility: NSObject {
    
    class func getDestinationPath(_ name: String, format:NSString = ".pdf") -> String {
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let path = documentsPath+"/"+name+(format as String)
        return path
    }
    class func sizeOfString(usingFont font: UIFont, string:String) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return string.size(withAttributes: fontAttributes)
    }
    
    class func getTimeFromNSDate(unixTime: Double) -> String? {
        
        //let date : Date? = Date.init(timeIntervalSinceNow: unixTime)
        let date : NSDate? = NSDate(timeIntervalSince1970: unixTime/1000)
        
        let formatter = DateFormatter()
        if self.isDateDifferenceOneDay((date! as Date), end: Date()) {
            formatter.dateFormat = "dd/MM/YY"
        } else {
            formatter.dateFormat = "hh:mm a"
        }
        formatter.timeZone = NSTimeZone(forSecondsFromGMT: NSTimeZone.local.secondsFromGMT()) as TimeZone
        var strDate: String? = nil
        if let aDate = date {
            strDate = formatter.string(from: aDate as Date)
        }
        return strDate
    }
    class func isDateDifferenceOneDay(_ startDate: Date?, end endDate: Date?) -> Bool {
        var components: DateComponents?
        var days: Int
        // var hour: Int
        // var minutes: Int
        if let aDate = startDate, let aDate1 = endDate {
            //components = Calendar.current.components([.day, .hour, .minute], from: aDate, to: aDate1, options: [])
            components = Calendar.current.dateComponents([.day, .hour, .minute], from: aDate, to: aDate1)
        }
        days = components?.day ?? 0
        //hour = components?.hour ?? 0
        // minutes = components?.minute ?? 0
        if days > 0 {
            return true
        }
        return false
    }
    class func getTimeStringFromUnixTime(unixTime: Double) -> Date {
        let date = Date.init(timeIntervalSinceNow: unixTime)
        let dateFormatter = DateFormatter()
        // Returns date formatted as 12 hour time.
        dateFormatter.dateFormat = "dd/MM/YYYY hh:mm a"
        dateFormatter.timeZone = NSTimeZone() as TimeZone?
        let localDateStr = dateFormatter.string(from: date)
        let localDate = dateFormatter.date(from: localDateStr)
        return localDate!
    }
    class func getDateInString(_ date : Date, format : String)->String{
        
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date
        formatter.dateFormat = format
        
        return formatter.string(from: date)
    }
    
    class func getTimeInString(_ date : Date)->String{
        
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date
        formatter.dateFormat = "HH:mm"
        
        return formatter.string(from: date)
    }
    class func getTimeStamp(from date: Date) -> NSNumber {
        let milliseconds = Int64((date.timeIntervalSince1970))
        let timeStampObj = Int(milliseconds)
        return timeStampObj as NSNumber
    }
    
    class func getDateTimeInFormat(_ date : Date, format : String)->String{
        
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.string(from: date)
    }
    
    class func showAlert(_ title: String, message: String, controller : UIViewController ){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
    
    class func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    class func getEventIntresetActivity()->[String]{
        
        var eventActivity : [String]!
        eventActivity = ["Active(Fitness,Hiking,Running)","Interests(Painting,Programming)","Entertainment(concerts,movie,game)","Social(bar-b-ques)","Recreational Sports(pick-up games & sports)"]
        
        return eventActivity
    }
    class func isNewVersionSupported()->Bool{
        var flag = false
        if #available(iOS 11, *) {
            flag = true
        } else {
            flag = false
        }
        return flag
    }
    
    class func formattedNumber(format:String, number: String) -> String {
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = format
        
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            }
            else {
                result.append(ch)
            }
        }
        return result
    }
    
    class func getImage(imageName: String) -> UIImage{
        if let image = UIImage(named: imageName) {
            return image
        }  else {
            return UIImage()
        }
    }
    
    
    class func setUserType(type:String){
        let userDefaults: UserDefaults = UserDefaults.standard
        userDefaults.setValue(type, forKey: "userState")
        userDefaults.synchronize()
    }
    
    
    
    
    class func goToApplicationSettings(){
        UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
    }
    
    class func createSingleChatGroupName(_ currentUserID: String?, recipientUserID: String?) -> String? {
        let userID = currentUserID?.replacingOccurrences(of: "u", with: "")
        let rUserID = recipientUserID?.replacingOccurrences(of: "u", with: "")
        let sorted = ([userID!, rUserID!] as NSArray).sortedArray(comparator: { string1, string2 in
            return ((string1 as? String)?.compare((string2 as? String) ?? "", options: .numeric, range: nil, locale: .current))!
        })
        //    NSArray *sorted = [@[userID,rUserID] sortedArrayUsingSelector:@selector(compare:) ];
        var uID: String? = nil
        if let anObject = sorted.first {
            uID = "u\(anObject)"
        }
        var rID: String? = nil
        if let anObject = sorted.last {
            rID = "u\(anObject)"
        }
        return "\(uID ?? "")_\(rID ?? "")"
    }

    
    class func convertObjectToJson(array: Any)->(String){
        var json:String = ""
        do {
            //Convert to Data
            let jsonData = try JSONSerialization.data(withJSONObject: array , options: JSONSerialization.WritingOptions.prettyPrinted)
            
            //Convert back to string. Usually only do this for debugging
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                json = JSONString
            }
            
        } catch {
            print("catch on document json array")
        }
        return json
    }
    
    class func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                    return json
                } catch {
                    print("Something went wrong")
                }
            }
            return nil
    }
    
    class func getImagesDict(images: [UIImage], key: String, type: String, compression: CGFloat)-> [[String: Any]]{
        
        var array : [[String: Any]] = []
        
        // getting new images which are not posted on server
        for image in images{
            let imageInfo = ["image" : image,
                             "image_key" : key,
                             "image_type" : type as Any ,
                             "image_compression" : compression as AnyObject ] as [String : Any] as [String : Any]
            array.append(imageInfo)
        }
        
        return array
    }
    
    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
            
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)
            
        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
    
}
