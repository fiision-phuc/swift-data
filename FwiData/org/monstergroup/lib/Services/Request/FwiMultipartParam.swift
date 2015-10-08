//  Project name: FwiData
//  File name   : FwiMultipartParam.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 12/3/14
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright (c) 2014 Monster Group. All rights reserved.
//  --------------------------------------------------------------

import Foundation


public class FwiMultipartParam : NSObject {
   
    
    // MARK: Class's constructors
    public override init() {
        super.init()
    }
    
    
    // MARK: Class's properties
    public var name: String! = nil
    public var fileName: String! = nil
    public var contentData: NSData! = nil
    public var contentType: String! = nil
    
    public override var hash: Int {
        var hash = (name != nil ? name.hash : 0)
        hash ^= (fileName != nil ? fileName.hash : 0)
        hash ^= (contentData != nil ? contentData.hash : 0)
        hash ^= (contentType != nil ? contentType.hash : 0)
        
        return hash
    }
    
    
    // MARK: Class's public methods
    public override func isEqual(object: AnyObject?) -> Bool {
        if let other = object as? FwiMultipartParam {
            return (self.hash == other.hash)
        }
        return false
    }
    
    public func compare(param: FwiMultipartParam) -> NSComparisonResult {
        if name == nil {
            return NSComparisonResult.OrderedAscending
        }
        else if param.name == nil {
            return NSComparisonResult.OrderedDescending
        }
        return name.compare(param.name)
    }
}


// Creation
extension FwiMultipartParam {

    // MARK: Class's constructors
    public convenience init(name: String?, fileName file: String?, contentData data: NSData?, contentType type: String?) {
        self.init()

        // Validate name
        if let n = name {
            self.name = n
        }
        else {
            self.name = ""
        }

        // Validate file
        if let f = file {
            self.fileName = f
        }
        else {
            self.fileName = ""
        }

        // Validate data
        if let d = data {
            self.contentData = d
        }
        else {
            self.contentData = NSData()
        }

        // Validate type
        if let t = type {
            self.contentType = t
        }
        else {
            self.contentType = ""
        }
    }
}