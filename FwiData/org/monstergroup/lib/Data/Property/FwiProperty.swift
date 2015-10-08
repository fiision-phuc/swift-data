//  Project name: FwiData
//  File name   : FwiProperty.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 12/4/14
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright (c) 2014 Monster Group. All rights reserved.
//  --------------------------------------------------------------
//
//  Permission is hereby granted, free of charge, to any person obtaining  a  copy
//  of this software and associated documentation files (the "Software"), to  deal
//  in the Software without restriction, including without limitation  the  rights
//  to use, copy, modify, merge,  publish,  distribute,  sublicense,  and/or  sell
//  copies of the Software,  and  to  permit  persons  to  whom  the  Software  is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF  ANY  KIND,  EXPRESS  OR
//  IMPLIED, INCLUDING BUT NOT  LIMITED  TO  THE  WARRANTIES  OF  MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO  EVENT  SHALL  THE
//  AUTHORS OR COPYRIGHT HOLDERS  BE  LIABLE  FOR  ANY  CLAIM,  DAMAGES  OR  OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING  FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN  THE
//  SOFTWARE.
//
//
//  Credits
//  _______
//  The original author is: James Gill
//  https://github.com/jagill/JAGPropertyConverter
//
//
//  Disclaimer
//  __________
//  Although reasonable care has been taken to  ensure  the  correctness  of  this
//  software, this software should never be used in any application without proper
//  testing. Monster Group  disclaim  all  liability  and  responsibility  to  any
//  person or entity with respect to any loss or damage caused, or alleged  to  be
//  caused, directly or indirectly, by the use of this software.

import Foundation
import FwiCore


public class FwiProperty : NSObject {
    
    
    // MARK: Class's constructors
    public override init() {
        super.init()
    }
    
    
    // MARK: Class's override properties
    public override var hash: Int {
        var name = self.name
        var type = self.typeEncoding
        
        var hash = name.hash ^ (type != nil ? type!.hash : 0)
        return hash
    }
    public override var description: String {
        var name = self.name
        var ivarName = self.ivarName
        var propertyType = self.propertyType
        var typeEncoding = self.typeEncoding
        
        propertyType = (propertyType != nil ? propertyType : "-")
        typeEncoding = (typeEncoding != nil ? typeEncoding : "-")
        
        return "<Property:\(name) (ivar:\(ivarName)) \(propertyType!) \(typeEncoding!) | \(String.fromCString(property_getAttributes(property!)))>"
    }
    
    
    // MARK: Class's properties
    private var attributes: [String]?
    private var property: objc_property_t?
    
    public var isAssign: Bool {
        if property == nil {
            return false
        }
        else {
            return !(self.isCopy || self.isRetain)
        }
    }
    public var isCopy: Bool {
        return self.hasAttribute("C")
    }
    public var isDynamic: Bool {
        return self.hasAttribute("D")
    }
    public var isNonatomic: Bool {
        return self.hasAttribute("N")
    }
    public var isReadonly: Bool {
        return self.hasAttribute("R")
    }
    public var isRetain: Bool {
        return self.hasAttribute("&")
    }
    
    public var isWeak: Bool {
        return self.isWeakReference || (self.isObject && !self.isCopy && !self.isRetain)
    }
    public var isWeakReference: Bool {
        return self.hasAttribute("W")
    }
    
    public var isBlock: Bool {
        return (self.typeEncoding == "@?")
    }
    public var isCollection: Bool {
        if let propClass: AnyClass = self.propertyClass {
            return (propClass.isSubclassOfClass(NSArray) || propClass.isSubclassOfClass(NSSet) || propClass.isSubclassOfClass(NSDictionary))
        }
        else {
            return false
        }
    }
    public var isId: Bool {
        return (self.typeEncoding == "@")
    }
    public var isObject: Bool {
        return (self.typeEncoding?.hasPrefix("@") == true && !self.isBlock)
    }
    public var isPrimitive: Bool {
        var typeEncoding = self.typeEncoding
        var isPrimitive = false
        
        isPrimitive = isPrimitive || (typeEncoding == "i" || typeEncoding == "I")
        isPrimitive = isPrimitive || (typeEncoding == "s" || typeEncoding == "S")
        isPrimitive = isPrimitive || (typeEncoding == "l" || typeEncoding == "L")
        isPrimitive = isPrimitive || (typeEncoding == "q" || typeEncoding == "Q")
        isPrimitive = isPrimitive || (typeEncoding == "f")
        isPrimitive = isPrimitive || (typeEncoding == "d")
        isPrimitive = isPrimitive || (typeEncoding == "B")
        isPrimitive = isPrimitive || (typeEncoding == "c" || typeEncoding == "C")
        
        return isPrimitive
    }
    
    public var name: String {
        if let p = property, name = String.fromCString(property_getName(p)) {
            return name
        }
        else {
            return ""
        }
    }
    public var ivarName: String {
        return self.contentOfAttribute("V")
    }
    public var propertyClass: AnyClass? {
        /* Condition validation */
        if !self.isObject {
            return nil
        }

        /* Condition validation: Object description must be >= 2 */
        var tokens = self.typeEncoding?.splitWithSeparator("\"")
        if tokens?.count < 2 {
            return nil
        }

        if let className = tokens?[1] {
            var aClass: AnyClass? = NSClassFromString(className)
            return aClass
        }
        else {
            return nil
        }
    }
    
    /**
     * - `R`                    The property is read-only (`readonly`)
     * - `C`                    The property is a copy of the value last assigned (`copy`)
     * - `&`                    The property is a reference to the value last assigned (`retain`)
     * - `N`                    The property is non-atomic (`nonatomic`)
     * - `G<myGetter>`          The property defines a custom getter selector myGetter. The name follows the `G` (for example, `GmyGetter`)
     * - `S<mySetter:>`         The property defines a custom setter selector mySetter. The name follows the `S` (for example, `SmySetter:`)
     * - `D`                    The property is dynamic (`@dynamic`)
     * - `W`                    The property is a weak reference (`__weak`)
     * - `P`                    The property is eligible for garbage collection
     * - `t<encoding>`          Specifies the type using old-style encoding
     *
     * https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html
     */
    public var propertyType: String? {
        if let result = attributes?.filter({ (encoded: String) -> Bool in return (encoded.hasPrefix("T") && !encoded.hasPrefix("V")) }) {
            return join(",", result)
        }
        else {
            return nil
        }
    }
    
    /**
     * - `c`                    A char (including `BOOL`)
     * - `i`                    An int
     * - `s`                    A short
     * - `l`                    A long (l is treated as a 32-bit quantity on 64-bit programs)
     * - `q`                    A long long
     * - `C`                    An unsigned char
     * - `I`                    An unsigned int
     * - `S`                    An unsigned short
     * - `L`                    An unsigned long
     * - `Q`                    An unsigned long long
     * - `f`                    A float
     * - `d`                    A double
     * - `B`                    A C++ bool or a C99 _Bool
     * - `v`                    A void
     * - `*`                    A character string (`char *`)
     * - `@`                    An object (whether statically typed or typed id)
     * - `#`                    A class object (`Class`)
     * - `:`                    A method selector (`SEL`)
     * - `[array type]`         An array
     * - `{name=type...}`       A structure
     * - `(name=type...)`       A union
     * - `bNUM`                 A bit field of num bits
     * - `^type`                A pointer to type
     * - `?`                    An unknown type (among other things, this code is used for function pointers)
     *
     * https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
     */
    public var typeEncoding: String? {
        var typeEncoding = self.contentOfAttribute("T")
        return (count(typeEncoding) > 0 ? typeEncoding : nil)
    }
    public var typeOldEncoding: String? {
        var typeOldEncoding = self.contentOfAttribute("t")
        return (count(typeOldEncoding) > 0 ? typeOldEncoding : nil)
    }
    
    
    // MARK: Class's override methods
    public override func isEqual(other: AnyObject?) -> Bool {
        /* Condition validation */
        if other == nil {
            return false
        }
        return (self.hash == other!.hash)
    }
    
    
    // MARK: Class's public methods
    public func canAssignValue(value: AnyObject?) -> Bool {
        if let v: AnyObject = value {
            if self.isId {
                return true
            }
            else if self.isObject && self.propertyClass != nil && !(v.isKindOfClass(NSArray) || v.isKindOfClass(NSDictionary)) {
                return v.isKindOfClass(self.propertyClass!)
            }
            else if self.isPrimitive {
                return v.isKindOfClass(NSNumber)
            }

            // We don't handle structs, char*, etc yet.  KVC does, tho.
            return true
        }
        else {
            return false
        }
    }
    
    
    // MARK: Class's private methods
    private func hasAttribute(attribute: String) -> Bool {  /** Check if it is has specific type of attribute. */
        if let attr = attributes {
            for encoded in attr {
                if encoded.hasPrefix(attribute) {
                    return true
                }
            }
        }
        return false
    }
    
    /** Return content of specific attribute. */
    private func contentOfAttribute(attribute: String) -> String {
        if let attr = attributes {
            for encoded in attr {
                if encoded.hasPrefix(attribute) {
                    return encoded.substringFromIndex(advance(encoded.startIndex, 1))
                }
            }
        }
        return ""
    }
}


// Creation
public extension FwiProperty {

    // MARK: Class's static constructors
    public class func propertiesWithClass(aClass: AnyClass?) -> [FwiProperty]? {
        if let c: AnyClass = aClass {
            var subClass: AnyClass = c
            var className = NSStringFromClass(c)

            var properties = [FwiProperty]()
            while className != NSStringFromClass(NSObject) {
                var count: UInt32 = 0
                var list = class_copyPropertyList(subClass, &count)

                for var i = 0; i < Int(count); i++ {
                    var property = FwiProperty(property: list[i])
                    properties.append(property)
                }
                free(list)

                // Check super class
                if let sub: AnyClass = subClass.superclass() {
                    subClass = sub
                    className = NSStringFromClass(sub)
                }
            }
            return properties
        }
        else {
            return nil
        }
    }

    
    // MARK: Class's constructors
    public convenience init(property: objc_property_t?) {
        self.init()

        if let p = property {
            var info = String.fromCString(property_getAttributes(p))
            self.attributes = info?.splitWithSeparator(",")
        }
        self.property = property
    }
}