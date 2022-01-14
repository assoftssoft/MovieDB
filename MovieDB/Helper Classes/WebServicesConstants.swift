//
//  WebServicesConstants.swift
//  LifSPKStudent
//
//  Created by Ahmed Baloch on 29/10/2019.
//  Copyright © 2019 Ahmed Baloch. All rights reserved.
//

import Foundation

struct WebServicesConstants {
    
    struct Server {
        
        static let BaseUrl = "https://api.themoviedb.org/3/search/movie"
        static let secretKey = ""
    }
    
    struct URL {
        

    }
    
    struct Response {
        static let Status = "status"
        static let Body = "body"
        static let Message = "message"
        static let Paging = "paging"
        static let ErrorCode = "error_code"
        static let error = "error"
    }
    
    struct Device {
        static let type = "device_type"
        static let uuid = "device_id"
        static let token = "device_token"
    }
 
 
    struct DefualtParams {
        static let TimeStamp        = "timestamp"
        static let Email            = "email"
        static let Password         = "password"
        static let ConfirmPassword  = "confirmpassword"
        static let oldPassword      = "old_pwd"
        static let UserType         = "user_type"
        static let page             = "page"
        static let type             = "type"
        static let Payload          = "payload"
    }
    

    
}
