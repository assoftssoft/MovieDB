//
//  CommonCryptoHelper.swift
//  LifSPKStudent
//
//  Created by Muhammad Rizwan on 27/03/2020.
//  Copyright © 2020 Ahmed Baloch. All rights reserved.
//

import Foundation

enum Operation {
    case encrypt
    case decrypt
}

class CommonCryptoHelper: NSObject {
    
    
    private let keySizeAES128 = 60
    private let aesBlockSize = 16
    
    func encrypt(data: Data) -> Data {
        return cryptCC(data: data, key: "", operation: kCCEncrypt)
    }
    
    func decrypt(data: Data, key:String) -> Data {
        return cryptCC(data: data, key: key, operation: kCCDecrypt)
    }
    
    private func cryptCC(data: Data, key: String, operation: Int) -> Data {
        
        guard key.count == keySizeAES128 else {
            fatalError("Key size failed!")
        }
        
        var ivBytes: [UInt8]
        var inBytes: [UInt8]
        var outLength: Int
        
        if operation == kCCEncrypt {
            ivBytes = [UInt8](repeating: 0, count: kCCBlockSizeAES128)
            guard kCCSuccess == SecRandomCopyBytes(kSecRandomDefault, ivBytes.count, &ivBytes) else {
                fatalError("IV creation failed!")
            }
            
            inBytes = Array(data)
            outLength = data.count + kCCBlockSizeAES128
            
        } else {
            ivBytes = Array(Array(data).dropLast(data.count - kCCBlockSizeAES128))
            inBytes = Array(Array(data).dropFirst(kCCBlockSizeAES128))
            outLength = inBytes.count
            
        }
        
        var outBytes = [UInt8](repeating: 0, count: outLength)
        var bytesMutated = 0
        
        guard kCCSuccess == CCCrypt(CCOperation(operation), CCAlgorithm(kCCAlgorithmAES128), CCOptions(kCCOptionPKCS7Padding), Array(key), kCCKeySizeAES128, &ivBytes, &inBytes, inBytes.count, &outBytes, outLength, &bytesMutated) else {
            fatalError("Cryptography operation \(operation) failed")
        }
        
        var outData = Data(bytes: &outBytes, count: bytesMutated)
        
        if operation == kCCEncrypt {
            ivBytes.append(contentsOf: Array(outData))
            outData = Data(bytes: ivBytes)
        }
        return outData
        
    }
}
