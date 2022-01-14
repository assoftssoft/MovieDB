//
//  WebServiceManager.swift
//  LifSPKStudent
//
//  Created by Ahmed Baloch on 29/10/2019.
//  Copyright © 2019 Ahmed Baloch. All rights reserved.
//

import Foundation
import Alamofire
import MBProgressHUD
import SwiftyJSON


class WebServiceManager {
    
    var webHeader:HTTPHeaders = ["Accept":"application/json"]
    
    var hudView : MBProgressHUD!
    
    class var sharedInstance: WebServiceManager {
        struct Static {
            static let instance: WebServiceManager = WebServiceManager()
        }
        return Static.instance
    }
    
    func getRequest(urlString: String,
                    isUsingHMAC: Bool? = false,
                    shouldShowHud : Bool = true,
                    paramDict: [String : Any]? = nil,
                    completionHandler: @escaping (NSDictionary?,Bool?, NSError?) -> ()) {
        
        
        if let isHMAC = isUsingHMAC {
            if isHMAC{
                if let params = paramDict {
                    print("============================")
                    print("URL String: \(urlString)")
                    print("============================")
                    print("============================")
                    print("Params Dic\(params)")
                    print("============================")
                    let hmacString = HMACHelper.createHMACFromDictionary(info: params)
//                    webHeader.updateValue(hmacString, forKey: "signature")
//                    webHeader.add(HTTPHeader.init(name: "signature", value: hmacString))
            
                }
            }
        }
        
        if shouldShowHud {
            showHud(message: "")
        }
       
        AF.request(urlString,
                   method: .get , parameters: [:], headers: nil)
            .responseJSON { response in
                
                
                self.hideHud()
                switch response.result {
                case .success(let JSON):
                    print("JSON",JSON)
                    let responseDic = JSON as! NSDictionary
                   
                    completionHandler(responseDic, true, nil)
                    guard self.checkTokenExpiry(response: responseDic) else {
                        return
                    }
                    if responseDic[WebServicesConstants.Response.Status] as? Bool == true{
                        completionHandler(responseDic, true, nil)
                    }else{self.hideWithCompletion {
                        completionHandler(responseDic, false, nil)
                        if !urlString.contains("studentWaiting") {
                            Alert.showAlertController(message: responseDic[WebServicesConstants.Response.Message] as? String ?? "")
                        }
                    }
                      
                        completionHandler(responseDic, false, nil)
                    }
                case .failure(let error):
                    completionHandler(nil,false, error as NSError?)
                }
        }
        
    }
    
    
    func postRequest(urlString: String,
                     isUsingHMAC: Bool? = true,
                     shouldShowHud : Bool = true,
                     paramDict: [String : Any]? = nil,
                     completionHandler: @escaping (NSDictionary?, Bool?,NSError?) -> ()) {
        
        if let isHMAC = isUsingHMAC {
            if isHMAC{
                if let params = paramDict {
                    print("============================")
                    print("URL String: \(urlString)")
                    print("============================")
                    print("============================")
                    print("Params Dic\(params)")
                    print("============================")
                    let hmacString = HMACHelper.createHMACFromDictionary(info: params)
//                    webHeader.updateValue(hmacString, forKey: "signature")
                    webHeader.add(HTTPHeader.init(name: "signature", value: hmacString))
                }
            }
        }
        
        if shouldShowHud {
            showHud(message: "")
        }
        AF.request(urlString, method:.post , parameters: paramDict, headers:webHeader)
            .responseJSON { response in
                self.hideHud()
                switch response.result {
                case .success(let JSON):
                    let responseDic = JSON as! NSDictionary
                    print("response : \(responseDic)")
                    guard self.checkTokenExpiry(response: responseDic) else {
                        return
                    }
                    if responseDic[WebServicesConstants.Response.Status] as? Bool == true{
                        completionHandler(responseDic, true, nil)
                    }else{
                        self.hideWithCompletion {
                            completionHandler(responseDic, false, nil)
                            Alert.showAlertController(message: responseDic[WebServicesConstants.Response.Message] as? String ?? "")
                        }
                    }
                case .failure(let error):
                    completionHandler(nil, false,error as NSError? )
                }
        }
    }
    
    func postRequestWithImage(urlString: String,
                              isUsingHMAC: Bool? = true,
                              shouldShowHud : Bool = true,
                              paramDict:[String : Any]? = nil,
                              imageParams:[[String : Any]]? = nil,
                              completionHandler: @escaping (NSDictionary?, Bool?, NSError?) -> ()) {
        
        
        if let isHMAC = isUsingHMAC {
            if isHMAC{
                if let params = paramDict {
                    print("============================")
                    print("URL String: \(urlString)")
                    print("============================")
                    print("============================")
                    print("Params Dic\(params)")
                    print("============================")
                    
                    let hmacString = HMACHelper.createHMACFromDictionary(info: params)
//                    webHeader.updateValue(hmacString, forKey: "signature")
                    webHeader.add(HTTPHeader.init(name: "signature", value: hmacString))
            
                }
            }
        }
        
        if shouldShowHud {
            showHud(message: "")
        }
        
        AF.upload(
            multipartFormData: { multipartFormData in
                
                if let imageInfoArray = imageParams {
                    
                    for imageInfo in imageInfoArray {
                        
                        if  let image = imageInfo["image"] as? UIImage,
                            let imageKey = imageInfo["image_key"] as? String,
                            let imageCompression = imageInfo["image_compression"] as? CGFloat,
                            let imageTypeName = imageInfo["image_type"] as? String,
                            let imageType = ImageType(rawValue: imageTypeName),
                            let imageData = imageType == ImageType.png ?image.pngData() : image.jpegData(compressionQuality: imageCompression) {
                            
                            multipartFormData.append(imageData, withName:imageKey, fileName: imageKey+"."+imageType.name, mimeType: "image/"+imageType.name)
                        }
                    }
                }
                
                if let paramDictionary = paramDict {
                    
                    for (key, value) in paramDictionary {
                        if let data = "\(value)".data(using: .utf8) {
                            multipartFormData.append(data, withName: key)
                        }
                    }
                }
        },
            to: urlString,
            headers:webHeader).response
            { response in
                switch response.result
                {
                case .success(let JSON):
                    var responseDic : NSDictionary?
                   
                    let encoder = JSONEncoder()
                    let nsd: NSData = NSData(base64Encoded: (JSON?.base64EncodedString())!, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!

                    if let jsonString = String(data: nsd as Data, encoding: .utf8) {
                            print(jsonString)
                            if let data = jsonString.data(using: String.Encoding.utf8) {
                                       
                                       do {
                                        responseDic = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                                        print("response : \(responseDic)")
                                           if let myDictionary = responseDic
                                           {
    //                                            print(" First name is: \(myDictionary["first_name"]!)")
                                           }
                                       } catch let error as NSError {
                                           print(error)
                                       }
                                   }
                            
                        }
                    
                    if shouldShowHud {
                        self.hideHud()
                    }
                    guard self.checkTokenExpiry(response: responseDic) else {
                        return
                    }
                    if responseDic?[WebServicesConstants.Response.Status] as? Bool == true{
                        completionHandler(responseDic, true, nil)
                    }else{
                        self.hideWithCompletion {
                            completionHandler(responseDic, false, nil)
                            Alert.showAlertController(message: responseDic?[WebServicesConstants.Response.Message] as? String ?? "")
                        }
                    }
                case .failure(let error):
                    if shouldShowHud {
                        self.hideHud()
                    }
                    completionHandler(nil,false, error as NSError?)
                }
        }
                
                
//                encodingResult
//                switch encodingResult
//                {
//                case .success(let upload):
//                    upload.responseJSON
//                        { response in
//                            switch response.result
//                            {
//                            case .success(let JSON):
//                                let responseDic = JSON as! NSDictionary
//                                print("response : \(responseDic)")
//                                if shouldShowHud {
//                                    self.hideHud()
//                                }
//                                guard self.checkTokenExpiry(response: responseDic) else {
//                                    return
//                                }
//                                if responseDic[WebServicesConstants.Response.Status] as? Bool == true{
//                                    completionHandler(responseDic, true, nil)
//                                }else{
//                                    self.hideWithCompletion {
//                                        completionHandler(responseDic, false, nil)
//                                        Alert.showAlertController(message: responseDic[WebServicesConstants.Response.Message] as? String ?? "")
//                                    }
//                                }
//                            case .failure(let error):
//                                if shouldShowHud {
//                                    self.hideHud()
//                                }
//                                completionHandler(nil,false, error as NSError?)
//                            }
//                    }
//                case .failure(let encodingError):
//                    if shouldShowHud {
//                        self.hideHud()
//                    }
//                    completionHandler(nil,false, encodingError as NSError)
//                }
        
    }
    
    
    //MARK: Utility Methods
    
    func downloadImageFromURL(imageURLString: String, controllerView: UIView,
                              completionHandler: @escaping (Bool?, UIImage?) -> ()) {
        
        if let url = URL(string: imageURLString) {
            
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if let imageData = data,
                        let image = UIImage(data: imageData) {
                        completionHandler(true,image)
                    }
                    completionHandler(false,nil)
                }
            }
        }
    }
    
    func checkTokenExpiry(response: NSDictionary?)-> Bool {
        if response?.value(forKey: WebServicesConstants.Response.error) as? String == "invalid_token" {
            NotificationCenter.default.post(name: Notification.Name(NotificationName.TokenExpiry), object: nil)
            return false
        }
        
        if response?.value(forKey: WebServicesConstants.Response.error) as? String == "token_absent" {
            NotificationCenter.default.post(name: Notification.Name(NotificationName.TokenExpiry), object: nil)
            return false
        }
        if response?.value(forKey: WebServicesConstants.Response.error) as? String == "token_expired" {
            NotificationCenter.default.post(name: Notification.Name(NotificationName.TokenExpiry), object: nil)
            return false
        }
        return true
    }
    
    class func getServiceBody(dic:NSDictionary) -> AnyObject {
        return dic.value(forKey: WebServicesConstants.Response.Body) as AnyObject
    }
    
    class func getServiceMessage(dic:NSDictionary) -> String {
        if let errorMessage = dic.value(forKey: WebServicesConstants.Response.Message) as? String {
            return errorMessage
        }
        return "Error Message"
    }
    
    class func getServiceStatus(dic:NSDictionary) -> Bool {
        if let status = dic.value(forKey: WebServicesConstants.Response.Status) as? NSNumber {
            if status == 0 { return false } else { return true }
        }
        return false
    }
    
    func showHud(message:String){
        print("adding hud on Services")
        
        let window: UIView =  UIApplication.shared.keyWindow ?? UIView.init()
        hudView = MBProgressHUD.showAdded(to: window, animated: true)
    }
    
    
    func hideHud() {
        print("adding hud on Services")
        let window: UIView =  UIApplication.shared.keyWindow!
        MBProgressHUD.hide(for: window, animated: true)
    }
    
    func hideWithCompletion(completion:(()->Void)){
        print("adding hud on Services")
        let window: UIView =  UIApplication.shared.keyWindow!
        MBProgressHUD.hide(for: window, animated: true)
        completion()
    }
    
    
//    func hideHud(){
//        
//        let window: UIView =  UIApplication.shared.keyWindow!
//        DispatchQueue.global(qos: .background).async {
//            // Go back to the main thread to update the UI
//            DispatchQueue.main.async {
//                print("removing hud on webservices")
//                MBProgressHUD.hide(for: window, animated: true)
//            }
//        }
//    }
}
