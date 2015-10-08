//  Project name: FwiData
//  File name   : FwiDataParam.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 12/3/14
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright (c) 2014 Monster Group. All rights reserved.
//  --------------------------------------------------------------

import Foundation


public class FwiDataParam : NSObject {
   
    
    // MARK: Class's constructors
    public override init() {
        super.init()
    }
    
    
    // MARK: Class's properties
    public var data: NSData! = nil
    public var contentType: String! = nil
}


// Creation
public extension FwiDataParam {

    // MARK: Class's constructors
    public convenience init(string: String?) {
        self.init(data: string?.toData(), contentType: "text/plain; charset=UTF-8")
    }
    public convenience init(data: NSData?, contentType type: String?) {
        self.init()

        // Validate data
        if let d = data {
            self.data = d
        }
        else {
            self.data = NSData()
        }

        // Validate content type
        if let t = type {
            self.contentType = t
        }
        else {
            self.contentType = ""
        }
    }
}