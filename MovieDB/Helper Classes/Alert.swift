//
//  Alert.swift
//  LifSPKStudent
//
//  Created by Ahmed Baloch on 29/10/2019.
//  Copyright © 2019 Ahmed Baloch. All rights reserved.
//

import UIKit

class Alert: NSObject {

    struct Message {
        static let ALERT_FIELD_EMPTY = " Field can't be left empty!"
        static let ALERT_ALPHABETS_ALLOWED = "Only alphabets are allowed!"
        static let ALERT_INVALID_EMAIL = "Invalid email address!"
        static let ALERT_INVLALID_CONTACT = "Phone Number is not valid!"
        static let ALERT_PASSWORD_MINIMUM_CHARACTERS = "There Must be minimum %d characters!"
        static let ALERT_PASSWORD_MAXIMUM_CHARACTERS = "There Must be maximum %d characters!"
        static let ALERT_PASSWORD_MISMATCH = "Password and confirm password mismatch!"
        static let ALERT_SERVICE_FAIL = "Server Not Responding, please try again later!"
        static let ALERT_SELECTED = " Select Missing Field"
        static let CameraWarning = "You have disallowed camera access.  Please navigate to phone settings and allow app access to the camera."
        static let PASSWORD_INVALID_MSG = "Password should have minimum 8 characters, one number, and one capital letter"
        static let ALERT_SKIPSIGNUP = "Do you want to skip the rest of Signup Steps?"
        static let ACTIVE_APPOINTMENT = "You have an active request. In order have another, you need to cancel current request."
        
    }
    
    class func showAlert(message:String, vc:UIViewController) {
        
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
    class func showAlert(title:String, message:String, vc:UIViewController) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
    class func showAlert(title:String, message:String, vc:UIViewController, completionHandler: @escaping (Bool?) -> ()) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
            completionHandler(true)
        }))
        vc.present(alert, animated: true, completion: nil)
    }
    
    class func showAlertWithYesNo(title:String, message:String, vc:UIViewController, completionHandler: @escaping (Bool) -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action in
            completionHandler(true)
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { action in
            completionHandler(false)
        }))
        vc.present(alert, animated: true, completion: nil)
    }
    
    class func showAlertController(message:String , actionBtn : UIAlertAction){
        
        var alertWindow : UIWindow!
        
        
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        _ = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action -> Void in
            alert.dismiss(animated: true, completion: nil)
            alertWindow=nil
        })
        alert.addAction(actionBtn)
        
        alertWindow = UIWindow.init(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alert, animated: false, completion: nil)
    }
    
    
    class func showAlertController(message:String){
        
        var alertWindow : UIWindow!
        
        
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action -> Void in
            alert.dismiss(animated: true, completion: nil)
            alertWindow=nil
        })
        alert.addAction(okAction)
        
        alertWindow = UIWindow.init(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alert, animated: false, completion: nil)
    }
    
    class func showAlertController(message:String , actionBtn : UIAlertAction , withNoBtn : Bool){
        
        var alertWindow : UIWindow!
        
        
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action -> Void in
            alert.dismiss(animated: true, completion: nil)
        })
        let noAction = UIAlertAction(title: "No", style: .default, handler: nil)
        if withNoBtn {
            
            alert.addAction(actionBtn)
            alert.addAction(noAction)
        }else {
            if actionBtn.title == "OK" {
                alert.addAction(actionBtn)
            }else {
                alert.addAction(okAction)
            }
            
        }
        
        
        
        alertWindow = UIWindow.init(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alert, animated: false, completion: nil)
    }
}
