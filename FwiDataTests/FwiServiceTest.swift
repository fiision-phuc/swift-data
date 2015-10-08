//  Project name: FwiData
//  File name   : FwiServiceTest.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 1/20/15
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright (c) 2015 Monster Group. All rights reserved.
//  --------------------------------------------------------------

import UIKit
import XCTest


class FwiServiceTest: XCTestCase, FwiServiceDelegate {

    
    var baseHTTP = NSURL(string: "http://httpbin.org")
    var baseHTTPS = NSURL(string: "https://httpbin.org")
    
    var authenticationCalled: Bool = false
    var bytesReceivedCalled: Bool = false
    var totalBytesWillReceiveCalled: Bool = false
    
    var locationPath: NSURL?
    
    
    // MARK: Setup
    override func setUp() {
        super.setUp()
        authenticationCalled = false
        bytesReceivedCalled = false
        totalBytesWillReceiveCalled = false
        
        locationPath = nil
    }
    
    
    // MARK: Tear Down
    override func tearDown() {
        if let path = locationPath?.path {
            var manager = NSFileManager.defaultManager()
            XCTAssertFalse(manager.fileExistsAtPath(path), "Success connection should delete temporary file after return location to delegate.")
        }
        super.tearDown()
    }
    
    
    // MARK: Test Cases
    func testFwiServiceDelegate() {
        var completedExpectation = self.expectationWithDescription("Operation completed.")
        
        // Generate request
        var request = NSURLRequest(URL: NSURL(string: "/", relativeToURL: baseHTTPS)!)
        var service = FwiService(request: request)
        
        service.delegate = self
        service.sendRequestWithCompletion { (locationPath, error, statusCode) -> Void in
            completedExpectation.fulfill()
        }
        
        // Wait for timeout handler
        self.waitForExpectationsWithTimeout(60.0, handler: { (error: NSError!) -> Void in
            XCTAssertTrue(self.authenticationCalled, "Authentication should be called.")
            XCTAssertTrue(self.bytesReceivedCalled, "Bytes received should be called.")
            XCTAssertTrue(self.totalBytesWillReceiveCalled, "Total bytes will receive should be called.")
            
            if error == nil {
                XCTAssertTrue(service.finished, "Operation finished.")
            } else {
                XCTAssertFalse(service.finished, "Operation could not finish.")
            }
        })
    }
    func testHttpSuccessConnection() {
        var completedExpectation = self.expectationWithDescription("Operation completed.")
        
        // Generate request
        var request = NSURLRequest(URL: NSURL(string: "/", relativeToURL: baseHTTP)!)
        var service = FwiService(request: request)
        
        service.sendRequestWithCompletion { (locationPath, error, statusCode) -> Void in
            XCTAssertTrue(FwiNetworkStatusIsSuccces(statusCode), "Success connection should return status code range 200 - 299. But found \(statusCode)")
            XCTAssertNil(error, "Success connection should not return error. But found \(error)")
            
            XCTAssertNotNil(locationPath, "Success connection should return path to temporary file. But found \(locationPath)")
            
            // Validate File
            if let path = locationPath?.path {
                var manager = NSFileManager.defaultManager()
                XCTAssertTrue(manager.fileExistsAtPath(path), "Success connection should persist data to temporary file and return to delegate.")
            } else {
                XCTFail("Success connection could not persist data to temporary file to return to delegate.")
            }
            
            self.locationPath = locationPath
            completedExpectation.fulfill()
        }
        
        // Wait for timeout handler
        self.waitForExpectationsWithTimeout(60.0, handler: { (error: NSError!) -> Void in
            if error == nil {
                XCTAssertTrue(service.finished, "Operation finished.")
            } else {
                XCTAssertFalse(service.finished, "Operation could not finish.")
            }
        })
    }
    func testHttpsSuccessConnection() {
        var completedExpectation = self.expectationWithDescription("Operation completed.")
        
        // Generate request
        var request = NSURLRequest(URL: NSURL(string: "/", relativeToURL: baseHTTPS)!)
        var service = FwiService(request: request)
        
        service.delegate = self
        service.sendRequestWithCompletion { (locationPath, error, statusCode) -> Void in
            XCTAssertTrue(FwiNetworkStatusIsSuccces(statusCode), "Success connection should return status code range 200 - 299. But found \(statusCode)")
            XCTAssertNil(error, "Success connection should not return error. But found \(error)")
            
            XCTAssertNotNil(locationPath, "Success connection should return path to temporary file. But found \(locationPath)")
            
            // Validate File
            if let path = locationPath?.path {
                var manager = NSFileManager.defaultManager()
                XCTAssertTrue(manager.fileExistsAtPath(path), "Success connection should persist data to temporary file and return to delegate.")
            } else {
                XCTFail("Success connection could not persist data to temporary file to return to delegate.")
            }
            
            self.locationPath = locationPath
            completedExpectation.fulfill()
        }
        
        // Wait for timeout handler
        self.waitForExpectationsWithTimeout(60.0, handler: { (error: NSError!) -> Void in
            if error == nil {
                XCTAssertTrue(service.finished, "Operation finished.")
            } else {
                XCTAssertFalse(service.finished, "Operation could not finish.")
            }
        })
    }
    
    func testUnsupportedURL() {
        var completedExpectation = self.expectationWithDescription("Operation completed.")
        
        // Generate request
        var request = NSURLRequest(URL: NSURL(string: "/", relativeToURL: nil)!)
        var service = FwiService(request: request)
        
        service.sendRequestWithCompletion { (locationPath, error, statusCode) -> Void in
            XCTAssertFalse(FwiNetworkStatusIsSuccces(statusCode), "Fail connection should return status code not in range 200 - 299. But found \(statusCode)")
            XCTAssertTrue(statusCode == NetworkStatus_UnsupportedURL, "Fail connection status should be \(NetworkStatus_UnsupportedURL). But found \(statusCode)")
            XCTAssertNotNil(error, "Fail connection should not return error. But found \(error)")

            XCTAssertNil(locationPath, "Fail connection should return path to temporary file. But found \(locationPath)")
            completedExpectation.fulfill()
        }
        
        // Wait for timeout handler
        self.waitForExpectationsWithTimeout(60.0, handler: { (error: NSError!) -> Void in
            if error == nil {
                XCTAssertTrue(service.finished, "Operation finished.")
            } else {
                XCTAssertFalse(service.finished, "Operation could not finish.")
            }
        })
    }
    
    func testTimeout() {
        var completedExpectation = self.expectationWithDescription("Operation completed.")
        
        // Generate request
        var request = NSURLRequest(URL: NSURL(string: "http://192.168.0.6:8888/scripts/data/backend2/index.php/name/_all")!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 10.0)
        var service = FwiService(request: request)
        
        service.sendRequestWithCompletion { (locationPath, error, statusCode) -> Void in
            XCTAssertFalse(FwiNetworkStatusIsSuccces(statusCode), "Cancelled connection should return status code not in range 200 - 299. But found \(statusCode)")
            XCTAssertTrue(statusCode == NetworkStatus_Cancelled, "Cancelled connection status should be \(NetworkStatus_Cancelled). But found \(statusCode)")
            XCTAssertNotNil(error, "Cancelled connection should not return error. But found \(error)")
            
            XCTAssertNil(locationPath, "Fail connection should return path to temporary file. But found \(locationPath)")
            completedExpectation.fulfill()
        }
        
        // Wait for timeout handler
        self.waitForExpectationsWithTimeout(60.0, handler: { (error: NSError!) -> Void in
            if error == nil {
                XCTAssertTrue(service.finished, "Operation finished.")
            } else {
                XCTAssertFalse(service.finished, "Operation could not finish.")
            }
        })
    }
    
    
    // MARK: FwiServiceDelegate's members
    func serviceRequireAuthenticationChallenge(service: FwiService, certificate cert: SecCertificateRef) -> Bool {
        authenticationCalled = true
        return true
    }
    func service(service: FwiService, totalBytesWillReceive totalBytes: Int) {
        totalBytesWillReceiveCalled = true
    }
    func service(service: FwiService, bytesReceived bytes: Int) {
        bytesReceivedCalled = true
    }
}
