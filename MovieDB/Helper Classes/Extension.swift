//
//  Extension.swift
//  LifSPKStudent
//
//  Created by Ahmed Baloch on 29/10/2019.
//  Copyright © 2019 Ahmed Baloch. All rights reserved.
//


import Foundation
import UIKit
import MBProgressHUD
import CryptoSwift

extension UIImage {
    
    func transform(withNewColor color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(.normal)
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        context.clip(to: rect, mask: cgImage!)
        
        color.setFill()
        context.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}


extension UISearchBar {
    
    private func getViewElement<T>(type: T.Type) -> T? {
        
        let svs = subviews.flatMap { $0.subviews }
        guard let element = (svs.filter { $0 is T }).first as? T else { return nil }
        return element
    }
    
    func getSearchBarTextField() -> UITextField? {
        
        return getViewElement(type: UITextField.self)
    }
    
    func setTextColor(color: UIColor) {
        
        if let textField = getSearchBarTextField() {
            textField.textColor = color
        }
    }
    
    func setTextFieldColor(color: UIColor) {
        
        if let textField = getViewElement(type: UITextField.self) {
            switch searchBarStyle {
            case .minimal:
                textField.layer.backgroundColor = color.cgColor
                textField.layer.cornerRadius = 6
                
            case .prominent, .default:
                textField.backgroundColor = color
            }
        }
    }
    
    func setPlaceholderTextColor(color: UIColor) {
        
        if let textField = getSearchBarTextField() {
            textField.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil ? self.placeholder! : "", attributes: [NSAttributedString.Key.foregroundColor: color])
        }
    }
    
    func setTextFieldClearButtonColor(color: UIColor) {
        
        if let textField = getSearchBarTextField() {
            
            let button = textField.value(forKey: "clearButton") as! UIButton
            if let image = button.imageView?.image {
                button.setImage(image.transform(withNewColor: color), for: .normal)
            }
        }
    }
    
    func setSearchImageColor(color: UIColor) {
        
        if let imageView = getSearchBarTextField()?.leftView as? UIImageView {
            imageView.image = imageView.image?.transform(withNewColor: color)
        }
    }
}
extension Dictionary where Key == String {
    func valueInStringOf(key: String) -> String {
        return ( self[key] as? String ) ?? ""
    }
    func valueInIntOf(key: String) -> Int? {
        return self[key] as? Int
    }
    func valueInBoolOf(key: String) -> Bool? {
        return ( (self[key] as? Int ) ?? 0 ) == 1
    }
    func valueInDoubleOf(key : String) -> Double? {
        return ((self[key] as? Double) ?? 0.0)
    }
}
extension String {
    var stripped: String {
        let okayChars = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-=().!_")
        return self.filter {okayChars.contains($0) }
    }
}
extension RawRepresentable where RawValue: Any {
    /**
     * The name of the enumeration (as written in case).
     */
    var name: String {
        get { return String(describing: self) }
    }
    
    /**
     * The full name of the enumeration
     * (the name of the enum plus dot plus the name as written in case).
     */
    var description: String {
        get { return String(reflecting: self) }
    }
}
extension UIViewController {
    func showHud() {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.isUserInteractionEnabled = false
    }
    
    func hideHUD() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
}

extension UIApplication {
    
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

extension UIButton  {
    func setbgColor_setTitle_setCornerRadius(red : CGFloat , blue : CGFloat , green : CGFloat,title : String,ispopupView : Bool ) {
        self.backgroundColor = UIColor.init(red: red/255, green: green/355, blue: blue/255, alpha: 1)
        self.setTitle(title, for: .normal)
        self.setTitleColor(UIColor.white, for: .normal)
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        if ispopupView {
            DispatchQueue.main.async {
                self.layer.cornerRadius = (self.bounds.height-5)/2
                self.layer.masksToBounds = true
            }
        }else {
            DispatchQueue.main.async {
                self.layer.cornerRadius = (self.bounds.height)/2
                self.layer.masksToBounds = true
            }
        }
    }
    
    func setbgColor_setTitle_setCornerRadius(red : CGFloat , blue : CGFloat , green : CGFloat,title : String ) {
           self.backgroundColor = UIColor.init(red: red/255, green: green/355, blue: blue/255, alpha: 1)
           self.setTitle(title, for: .normal)
           self.setTitleColor(UIColor.white, for: .normal)
           self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
          
       }
}

extension Notification {
    static  func setLocalNotification(alertbody : String , category : String , badge : Int) {
        let localNotification = UILocalNotification()
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 3) as Date
        localNotification.alertBody = alertbody
        localNotification.timeZone = NSTimeZone.local
        localNotification.soundName = UILocalNotificationDefaultSoundName
        localNotification.applicationIconBadgeNumber = badge
        localNotification.category = category
        
        UIApplication.shared.scheduleLocalNotification(localNotification)
    }
}



extension UITableView {

    func scrollToBottom(){

        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1,
                section: self.numberOfSections - 1)
            self.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }

    func scrollToTop() {

        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            self.scrollToRow(at: indexPath, at: .top, animated: false)
        }
    }
}



extension UIView {
    func addPulseAnimation(){
        let pulseAnimation = CABasicAnimation(keyPath: "opacity")
        pulseAnimation.duration = 30
        pulseAnimation.fromValue = 0
        pulseAnimation.toValue = 1
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .greatestFiniteMagnitude
        self.layer.add(pulseAnimation, forKey: nil)
    }
    func animShow(){
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn],
                       animations: {
                        self.center.y -= self.bounds.height
                        self.layoutIfNeeded()
        }, completion: nil)
        self.isHidden = false
    }
    func animHide(){
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveLinear],
                       animations: {
                        self.center.y += self.bounds.height
                        self.layoutIfNeeded()

        },  completion: {(_ completed: Bool) -> Void in
        self.isHidden = true
            })
    }
        func subviews<T:UIView>(ofType WhatType:T.Type) -> [T] {
            var result = self.subviews.compactMap {$0 as? T}
            for sub in self.subviews {
                result.append(contentsOf: sub.subviews(ofType:WhatType))
            }
            return result
        }
    
    func dropShadow(scale: Bool = true) {
      layer.masksToBounds = false
      layer.shadowColor = UIColor.red.cgColor
      layer.shadowOpacity = 0.5
      layer.shadowOffset = CGSize(width: 1, height: -1)
      layer.shadowRadius = 1

      layer.shadowPath = UIBezierPath(rect: bounds).cgPath
      layer.shouldRasterize = true
      layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    func addShadow(scale: Bool = true) {
        
        layer.cornerRadius = 10
        clipsToBounds = true
        layer.shadowPath = UIBezierPath(roundedRect: bounds,
                                        cornerRadius: layer.cornerRadius).cgPath
              
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: -20)
        layer.shadowRadius = 1
        layer.masksToBounds = false
        
    }

    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
           let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
           let mask = CAShapeLayer()
           mask.path = path.cgPath
           layer.mask = mask
       }
    
    // OUTPUT 2
  
    func addshadow(top: Bool,
                   left: Bool,
                   bottom: Bool,
                   right: Bool,
                   shadowRadius: CGFloat = 2.0) {

        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: -15)
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = 1.0
//        self.layer.cornerRadius = 3
        

        let path = UIBezierPath()
        var x: CGFloat = 0
        var y: CGFloat = 0
        var viewWidth = self.frame.width
        var viewHeight = self.frame.height

        // here x, y, viewWidth, and viewHeight can be changed in
        // order to play around with the shadow paths.
        if (!top) {
            y+=(shadowRadius+1)
        }
        if (!bottom) {
            viewHeight-=(shadowRadius+1)
        }
        if (!left) {
            x+=(shadowRadius+1)
        }
        if (!right) {
            viewWidth-=(shadowRadius+1)
        }
        // selecting top most point
        path.move(to: CGPoint(x: x, y: y))
        // Move to the Bottom Left Corner, this will cover left edges
        /*
         |☐
         */
        path.addLine(to: CGPoint(x: x, y: viewHeight))
        // Move to the Bottom Right Corner, this will cover bottom edge
        /*
         ☐
         -
         */
        path.addLine(to: CGPoint(x: viewWidth, y: viewHeight))
        // Move to the Top Right Corner, this will cover right edge
        /*
         ☐|
         */
        path.addLine(to: CGPoint(x: viewWidth, y: y))
        // Move back to the initial point, this will cover the top edge
        /*
         _
         ☐
         */
        path.close()
        self.layer.shadowPath = path.cgPath
    }
}


extension UIView {
    @IBInspectable var radiusCorner : CGFloat {
    get {
        return layer.cornerRadius
    } set {
        layer.cornerRadius = newValue
        layer.masksToBounds = newValue > 0
        }
    }
}

extension UIButton {
    @IBInspectable var cornerRadius : CGFloat {
        get {
            return layer.cornerRadius
        } set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
}
extension UITextField : UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return false
    }
}

extension Collection where Iterator.Element == [String:Any] {
    func toSwiftData(options: JSONSerialization.WritingOptions = .prettyPrinted) -> Data {
        if let arr = self as? [[String:Any]],
           let data = try? JSONSerialization.data(withJSONObject: arr, options: options) {
            return data
        }
        return Data.init()
    }
}

extension NSDictionary {
    func toSwiftData(options: JSONSerialization.WritingOptions = .prettyPrinted) -> Data {
        if let arr = self as? [String:Any],
           let data = try? JSONSerialization.data(withJSONObject: arr, options: options) {
            return data
        }
        return Data.init()
    }
}


extension NSObject {
    static func nameOfClass() -> String {
        return NSStringFromClass(self as AnyClass).components(separatedBy: ".").last!
    }
    
}
