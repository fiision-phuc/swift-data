//  Project name: FwiData
//  File name   : FwiService.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 1/15/15
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright (c) 2015 Monster Group. All rights reserved.
//  --------------------------------------------------------------

import Foundation
import UIKit
import FwiCore

public class FwiService : FwiOperation, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
   
    
    // MARK: Class's constructors
    public override init() {
        super.init()
    }
    
    
    // MARK: Class's properties
    private var req: NSURLRequest?
    private var con: NSURLConnection?
    private var res: NSHTTPURLResponse?
    // Network
    private var error: NSError?
    private var timer: NSTimer?
    private var statusCode: Int32 = -1
    // File Handler
    private var path: String! = nil
    private var output: NSFileHandle! = nil
    
    
    // MARK: Class's public methods
    public override func businessLogic() {
        if let tempDir = NSTemporaryDirectory(), identifier = String.randomIdentifier(), request = req {
            if let customRequest = request as? FwiRequest {
                customRequest.prepare()
            }

            // Prepare data buffer
            path = "\(tempDir)\(identifier)"

            // Start process
            var runLoop = NSRunLoop.currentRunLoop();

            // Initialize connection
            con = NSURLConnection(request: request, delegate: self, startImmediately: true)
            con?.scheduleInRunLoop(runLoop, forMode: NSDefaultRunLoopMode)

            // Initialize timer
            if self.isLongOperation != true {
                timer = NSTimer(timeInterval: request.timeoutInterval, target: self, selector: Selector("cancel"), userInfo: nil, repeats: false)
                runLoop.addTimer(timer!, forMode: NSDefaultRunLoopMode)
            }

            // Open network connection
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            con?.start()
            runLoop.run()

            // Print out error if available
            if let err = error {
                var errorMessage =  "HTTP Url   : \(request.URL)\n"
                errorMessage     += "HTTP Method: \(request.HTTPMethod)\n"
                errorMessage     += "HTTP Status: \(statusCode) (\(err.localizedDescription))\n"
                errorMessage     += "\(String(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil))"

                println("[FwiService] Transfer Error:\n\(errorMessage)")
            }
        }
        else {
            println("[FwiService] Execute business error: Could not locate temporary folder or could not generate identifier or URL request is invalid.")
            return
        }
    }


    public override func cancel() {
        self.shutdownConnection()

        // Define error
        statusCode = NetworkStatus_Cancelled
        if let url = req?.URL {
            var info: [NSObject : AnyObject] = [NSURLErrorFailingURLErrorKey:url.description,
                                                NSURLErrorFailingURLStringErrorKey:url.description,
                                                NSLocalizedDescriptionKey:NSHTTPURLResponse.localizedStringForStatusCode(Int(statusCode))]
            
            error = NSError(domain: NSURLErrorDomain, code: Int(statusCode), userInfo: info)
        }
        else {
            var info: [NSObject : AnyObject] = [NSURLErrorFailingURLErrorKey:"",
                                                NSURLErrorFailingURLStringErrorKey:"",
                                                NSLocalizedDescriptionKey:NSHTTPURLResponse.localizedStringForStatusCode(Int(statusCode))]

            error = NSError(domain: NSURLErrorDomain, code: Int(statusCode), userInfo: info)
        }
        super.cancel()
    }

    /** Execute with completion blocks. */
    public func sendRequestWithCompletion(completion: ((locationPath: NSURL?, error: NSError?, statusCode: Int32) -> Void)?) {
        super.executeWithCompletion({ () -> Void in
            /* Condition validation: Only generate temp url when status is success */
            var locationPath: NSURL? = nil
            if FwiNetworkStatusIsSuccces(self.statusCode) {
                locationPath = NSURL(fileURLWithPath: self.path)
            }
        
            // Return result to client
            if let completionBlock = completion {
                completionBlock(locationPath: locationPath, error: self.error, statusCode: self.statusCode)
            }
            
            // Delete data
            var manager = NSFileManager.defaultManager()
            if manager.fileExistsAtPath(self.path) {
                manager.removeItemAtPath(self.path, error: nil)
            }
        })
    }
    
    
    // MARK: Class's private methods
    private func shutdownConnection() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
        if output != nil {
            output?.closeFile()
        }
        if timer != nil {
            timer?.invalidate()
        }
        if con != nil {
            con?.cancel()
        }
    }
    
    
    // MARK: NSURLConnectionDelegate's members
    public func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        self.shutdownConnection()
        
        self.error = error
        statusCode = Int32(error.code)
    }
    public func connection(connection: NSURLConnection, willSendRequestForAuthenticationChallenge challenge: NSURLAuthenticationChallenge) {
        FwiLog("\(challenge.protectionSpace.authenticationMethod)")
        
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            var serverTrust = challenge.protectionSpace.serverTrust
            var certificate = SecTrustGetCertificateAtIndex(serverTrust, 0).takeUnretainedValue() as SecCertificateRef
            
            // Ask delegate
            var shouldAllow: Bool? = false
            if let serviceDelegate = self.delegate as? FwiServiceDelegate {
                shouldAllow = serviceDelegate.serviceRequireAuthenticationChallenge?(self, certificate: certificate)
            }
            
            // Create storage if neccessary
            if shouldAllow == false {
                challenge.sender.cancelAuthenticationChallenge(challenge)
            } else {
                var credential = NSURLCredential(trust: serverTrust!)
                challenge.sender.useCredential(credential, forAuthenticationChallenge: challenge)
            }
        } else {
            challenge.sender.cancelAuthenticationChallenge(challenge)
        }
    }
    
    
    // MARK: NSURLConnectionDataDelegate's members
    public func connection(connection: NSURLConnection, didSendBodyData bytesWritten: Int, totalBytesWritten: Int, totalBytesExpectedToWrite: Int) {
        if totalBytesWritten == totalBytesExpectedToWrite {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
        else {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        }
    }
    
    public func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        res = response as? NSHTTPURLResponse

        /* Condition validation: Validate response status */
        if let status = res?.statusCode {
            statusCode = Int32(status)
            
            if !FwiNetworkStatusIsSuccces(statusCode) {
                if let url = req?.URL {
                    var info: [NSObject : AnyObject] = [NSURLErrorFailingURLErrorKey:url.description,
                                                        NSURLErrorFailingURLStringErrorKey:url.description,
                                                        NSLocalizedDescriptionKey:NSHTTPURLResponse.localizedStringForStatusCode(Int(statusCode))]

                    error = NSError(domain: NSURLErrorDomain, code: Int(statusCode), userInfo: info)
                }
                else {
                    var info: [NSObject : AnyObject] = [NSURLErrorFailingURLErrorKey:"",
                                                        NSURLErrorFailingURLStringErrorKey:"",
                                                        NSLocalizedDescriptionKey:NSHTTPURLResponse.localizedStringForStatusCode(Int(statusCode))]

                    error = NSError(domain: NSURLErrorDomain, code: Int(statusCode), userInfo: info)
                }
            }
        }
        
        /* Condition validation: Validate content length */
        var contentSize: Int = 4096
        if let contentLength = res?.allHeaderFields["Content-Length"] as? String, length = contentLength.toInt() {  // Try to obtain content length from response headers
            contentSize = length
        }
        
        // Open output stream
        NSFileManager.defaultManager().createFileAtPath(path, contents: nil, attributes: nil)
        output = NSFileHandle(forWritingAtPath: path)
        
        // Notify delegate
        if let serviceDelegate = self.delegate as? FwiServiceDelegate {
            serviceDelegate.service?(self, totalBytesWillReceive: contentSize)
        }
    }
    public func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        /* Condition validation */
        if data.length == 0 {
            return
        }
        output.writeData(data)
        
        // Notify delegate
        if let serviceDelegate = self.delegate as? FwiServiceDelegate {
            serviceDelegate.service?(self, bytesReceived: data.length)
        }
    }
    
    public func connectionDidFinishLoading(connection: NSURLConnection) {
        self.shutdownConnection()
    }
}


// Creation
public extension FwiService {
    
    // MARK: Class's constructors
    public convenience init(request: NSURLRequest) {
        self.init()
        self.req = request
    }
    
//    public class func serviceWithURL(url: NSURL) {
//        
//    }
//    public class func serviceWithURL:(NSURL *)url method:(FwiMethodType)method;
//    public class func serviceWithURL:(NSURL *)url method:(FwiMethodType)method requestMessage:(FwiJson *)requestMessage;
//    public class func serviceWithURL:(NSURL *)url method:(FwiMethodType)method requestDictionary:(NSDictionary *)requestDictionary;
}


// Delegate
@objc
public protocol FwiServiceDelegate : FwiOperationDelegate {
    
    /** Request authentication permission from delegate. */
    optional func serviceRequireAuthenticationChallenge(service: FwiService, certificate cert: SecCertificateRef) -> Bool
    
    /** Notify receive data process. */
    optional func service(service: FwiService, totalBytesWillReceive totalBytes: Int)
    optional func service(service: FwiService, bytesReceived bytes: Int)
}