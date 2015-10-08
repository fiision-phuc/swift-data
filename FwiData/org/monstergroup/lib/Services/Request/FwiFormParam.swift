//  Project name: FwiData
//  File name   : FwiFormParam.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 12/3/14
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright (c) 2014 Monster Group. All rights reserved.
//  --------------------------------------------------------------

import Foundation


public class FwiFormParam : NSObject {
   
    
    // MARK: Class's constructors
    public override init() {
        super.init()
    }
    
    
    // MARK: Class's properties
    public var key: String! = nil
    public var value: String! = nil

    public override var hash: Int {
        var hash = (key != nil ? key.hash : 0) ^ (value != nil ? value.hash : 0)
        return hash
    }
    public override var description: String {
        if let encodedValue = value.encodeHTML() {
            return "\(key)=\(encodedValue)"
        }
        else {
            return "\(key)="
        }
    }
    
    
    // MARK: Class's override methods
    public override func isEqual(object: AnyObject?) -> Bool {
        if let other = object as? FwiFormParam {
            return (self.hash == other.hash)
        }
        return false
    }
    
    
    // MARK: Class's public methods
    public func compare(param: FwiFormParam) -> NSComparisonResult {
        if key == nil {
            return NSComparisonResult.OrderedAscending
        }
        else if param.key == nil {
            return NSComparisonResult.OrderedDescending
        }
        else {
            return key.compare(param.key)
        }
    }
}


// Creation
public extension FwiFormParam {

    // MARK: Class's constructors
    public convenience init(key: String?, value param: String?) {
        self.init()

        // Validate key
        if let k = key {
            self.key = k
        }
        else {
            self.key = ""
        }

        // Validate value
        if let v = param {
            self.value = v
        }
        else {
            self.value = ""
        }
    }
}