//
//  HMACHelper.swift
//  LifSPKStudent
//
//  Created by Ahmed Baloch on 29/10/2019.
//  Copyright © 2019 Ahmed Baloch. All rights reserved.
//

import UIKit
import CryptoSwift
import CommonCrypto

extension String {
    
    func hmac(key: String) -> String {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256), key, key.count, self, self.count, &digest)
        let data = Data(bytes: digest)
        return data.toHexString()
    }
    
    
}
class HMACHelper: NSObject {

    /// This method is used to create an HMAC Value from the parameters dictionary. This method creates a clean JSON after sorting the dictionary keys alphabetically. Then this JSON is used to create an HMAC Value.
    ///
    /// - Parameter info: Dictionary of Params that is used to create HMAC
    /// - Returns: HMAC Value in Strings
    
    class func sha256Hash(_ string: String) -> Data? {
        let len = Int(CC_SHA256_DIGEST_LENGTH)
        let data = string.data(using:.utf8)!
        var hash = Data(count:len)
        
        let _ = hash.withUnsafeMutableBytes {hashBytes in
            data.withUnsafeBytes {dataBytes in
                CC_SHA256(dataBytes, CC_LONG(data.count), hashBytes)
            }
        }
        return hash
    }
    
    class func createHMACFromDictionary(info:[String : Any]) -> String {
        
        let sorted = info.sorted(by: { $0.key < $1.key })
        let keysArraySorted = Array(sorted.map({ $0.key }))
        
        print(sorted)
        //        print(keysArraySorted)
        
        var jstr = "{"
        for key in keysArraySorted {
            let value = info[key]!
            
            jstr.append( "\"\(key)\":\"\(value)\"," )
        }
        jstr.removeLast()
        jstr.append("}")
        
        print(jstr)
        
        let dictStr = jstr.trimmingCharacters(in: .whitespacesAndNewlines)
        let newStr = dictStr.replacingOccurrences(of: ": ", with: ":")
        let aStr = newStr.replacingOccurrences(of: " :", with: ":")
        let theStr = aStr.replacingOccurrences(of: ", ", with: ",")
        //        let maStr = theStr.replacingOccurrences(of: " ", with: "")
        let ja = theStr.replacingOccurrences(of: "{ ", with: "{")
        let ga = ja.replacingOccurrences(of: " }", with: "}")
        let na = ga.replacingOccurrences(of: "\n", with: "")
        print("PARAM JSON:: " + na)
        
        let aHmac = na.hmac(key: WebServicesConstants.Server.secretKey)
        print("HMAC:: " + aHmac)
        return aHmac
    }
}
