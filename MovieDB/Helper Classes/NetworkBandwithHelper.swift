//
//  NetworkBandwithHelper.swift
//  LifSPKStudent
//
//  Created by DEVELOPER on 22/01/2021.
//  Copyright © 2021 Ahmed Baloch. All rights reserved.
//

import Foundation
import UIKit

class NetworkSpeedProvider: NSObject {

var startTime = CFAbsoluteTime()
var stopTime = CFAbsoluteTime()
var bytesReceived: CGFloat = 0
var speedTestCompletionHandler: ((_ megabytesPerSecond: CGFloat, _ error: Error?) -> Void)? = nil

func test() {

    testDownloadSpeed(withTimout: 5.0, completionHandler: {(_ megabytesPerSecond: CGFloat, _ error: Error?) -> Void in
        print("%0.1f; error = \(megabytesPerSecond)")
    })
  }
}


extension NetworkSpeedProvider: URLSessionDataDelegate, URLSessionDelegate {


func testDownloadSpeed(withTimout timeout: TimeInterval, completionHandler: @escaping (_ megabytesPerSecond: CGFloat, _ error: Error?) -> Void) {



    // you set any relevant string with any file
    let urlForSpeedTest = URL(string: "https://staging.appmaisters.com/lifspk/public/dummy_image.jpg")




    startTime = CFAbsoluteTimeGetCurrent()
    stopTime = startTime
    bytesReceived = 0
    speedTestCompletionHandler = completionHandler
    let configuration = URLSessionConfiguration.ephemeral
    configuration.timeoutIntervalForResource = timeout
    let session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)

    guard let checkedUrl = urlForSpeedTest else { return }

    session.dataTask(with: checkedUrl).resume()
}

func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
    bytesReceived += CGFloat(data.count)
    stopTime = CFAbsoluteTimeGetCurrent()
}

func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
    let elapsed = (stopTime - startTime) //as? CFAbsoluteTime
    let speed: CGFloat = elapsed != 0 ? bytesReceived / (CGFloat(CFAbsoluteTimeGetCurrent() - startTime)) / 1024.0 / 1024.0 : -1.0
    // treat timeout as no error (as we're testing speed, not worried about whether we got entire resource or not
    if error == nil || ((((error as NSError?)?.domain) == NSURLErrorDomain) && (error as NSError?)?.code == NSURLErrorTimedOut) {
        speedTestCompletionHandler?(speed, nil)
    }
    else {
        speedTestCompletionHandler?(speed, error)
    }
  }
}
