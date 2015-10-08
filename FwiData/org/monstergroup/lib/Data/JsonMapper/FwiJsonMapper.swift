//  Project name: FwiData
//  File name   : FwiJsonMapper.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 12/6/14
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


public class FwiJsonMapper : NSObject {
   
    
    // MARK: Class's constructors
    public override init() {
        super.init()

        numberFormat = NSNumberFormatter()
        numberFormat.generatesDecimalNumbers = true
        numberFormat.numberStyle = NSNumberFormatterStyle.DecimalStyle
        numberFormat.formatterBehavior = NSNumberFormatterBehavior.Behavior10_4
    }

    // MARK: Class's properties
    var shouldConvertToCamelCase: Bool = true
    var numberFormat: NSNumberFormatter! = nil

    private var classList: [String : AnyClass]! = nil
    private var propertiesList: [String : [FwiProperty]]! = nil


    // MARK: Class's public methods
    public func decodeJsonDataWithModel(jsonData: NSData?, model classes: [AnyClass]?) -> AnyObject? {
        /* Condition validation: Validate classes */
        if let clazzes = classes {
            propertiesList = [String : [FwiProperty]]()
            classList = [String : AnyClass]()

            for aClass in clazzes {
                if let clazz: AnyClass = aClass as? NSObject.Type, name = NSStringFromClass(clazz), tokens: [String] = name.splitWithSeparator(".") {
                    tokens.count == 2 ? (propertiesList[tokens[1]] = FwiProperty.propertiesWithClass(clazz)) : (propertiesList[tokens[0]] = FwiProperty.propertiesWithClass(clazz))
                    tokens.count == 2 ? (classList[tokens[1]] = clazz) : (classList[tokens[0]] = clazz)
                }
                else {
                    println("[FwiJsonMapper] Decode Error: Class model must be extended from NSObject.")
                    propertiesList = nil
                    classList = nil
                    return nil
                }
            }
        }

        /* Condition validation: Validate json data */
        if let data = jsonData, decodedJson: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) {
            return self.convertDataToModel(decodedJson)
        }
        else {
            if let string = jsonData?.toString() {
                println("[FwiJsonMapper] Decode Error: Invalid json string. Found \(string)")
            }
            return nil
        }
    }
    public func decodeJsonStringWithModel(jsonString: String?, model classes: [AnyClass]?) -> AnyObject? {
        return self.decodeJsonDataWithModel(jsonString?.toData(), model: classes)
    }

    /** Encode json from model. */
    public func encodeJsonDataWithModel(anyObject: AnyObject?) -> NSData? {
//        __autoreleasing NSError *error = nil
//        __autoreleasing NSData *data = [NSJSONSerialization dataWithJSONObject:object
//            options:NSJSONWritingPrettyPrinted
//            error:&error]
//        
//        if (!error) {
//            __autoreleasing NSString *result = [data toString]
//            return result
//        }
        return nil
    }
    public func encodeJsonStringWithModel(anyObject: AnyObject?) -> String? {
        return nil
    }
    

    // MARK: Class's private methods
    private func convertDataToModel(decodedJson: AnyObject) -> AnyObject? {
        if let array = decodedJson as? NSMutableArray {
            return buildCollectionForModel(array)
        }
        else if let info = decodedJson as? NSMutableDictionary {
            // Convert other case to camel case
            if shouldConvertToCamelCase {
                convertToCamelCase(info)
            }

            // Find best matched model
            let (model, properties) = findModel(info)

            // Map data with model
            if model != nil && properties != nil {
                return injectDataIntoModel(info, model: model!, propertyList: properties! as! [FwiProperty])
            }
            else {
                return buildDictionaryForModel(info)
            }
        }
        else {
            return decodedJson
        }
    }

    /** Build array from a sequence of model. */
    private func buildCollectionForModel(info: NSMutableArray) -> NSArray? {
        info.enumerateObjectsWithOptions(NSEnumerationOptions.Reverse) { (object: AnyObject!, idx: Int, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
            if let data = object as? NSMutableDictionary {
                // Convert other case to camel case
                if self.shouldConvertToCamelCase {
                    self.convertToCamelCase(data)
                }

                // Find best matched model
                let (model, properties) = self.findModel(data)

                // Map data with model
                if model != nil && properties != nil {
                    if let item: AnyObject = self.injectDataIntoModel(data, model: model!, propertyList: properties! as! [FwiProperty]) {
                        info.replaceObjectAtIndex(idx, withObject: item)
                    }
                }
            }
        }
        return info
    }
    /** Build dictionary from a sequence of model. */
    private func buildDictionaryForModel(info: NSMutableDictionary) -> NSDictionary? {
        for (key, object) in info {
            if let data = object as? NSDictionary {
                let (model, properties) = self.findModel(data)

                if model != nil && properties != nil {
                    if let item: AnyObject = self.injectDataIntoModel(data, model: model!, propertyList: properties! as! [FwiProperty]) {
                        info.setValue(item, forKey: key as! String)
                    }
                }
            }
        }
        return info
    }

    private func convertToCamelCase(info: NSMutableDictionary) {
        for (key, object) in info {
            if let string = key as? String {
                var builder = NSMutableString(string: string)
                var isModified = false
                var index = 0

                for (idx, chr) in enumerate(string) {
                    if chr == "_" {
                        var range = NSMakeRange(index, 1)
                        builder.replaceCharactersInRange(range, withString: "")

                        var subString = builder.substringWithRange(range)
                        builder.replaceCharactersInRange(range, withString: subString.uppercaseString)

                        isModified = true
                        index--
                    }
                    index++
                }

                // Only update key if it had been modified
                if isModified {
                    info.setObject(object, forKey: builder)
                    info.removeObjectForKey(key)
                }
            }
        }
    }

    /** Find the best matched of provided model. */
    private func findModel(info: NSDictionary) -> (NSObject.Type?, NSArray?) {
        var matched: Float = 0.0
        var aClass: NSObject.Type? = nil
        var propertyList: NSArray? = nil

        for (className, properties) in propertiesList {
            var passCount: Float = 0.0

            for property in properties {
                /* Condition validation: Skip readonly property */
                if property.isReadonly {
                    passCount++
                    continue
                }

                var value: AnyObject? = info[property.name]
                if property.canAssignValue(value) {
                    passCount++
                }
            }

            // Calculate percentage
            var percentage = passCount / Float(properties.count)
            if percentage > matched {
                if let clazz = classList[className] as? NSObject.Type {
                    aClass = clazz
                }
                propertyList = propertiesList[className]
                matched = percentage
            }

            // Stop if matched = 1
            if matched == 1 {
                break
            }
        }
        return (aClass, propertyList)
    }

    /** Inject information into model. */
    private func injectDataIntoModel(info: NSDictionary, model aClass: NSObject.Type, propertyList properties: [FwiProperty]) -> AnyObject? {
        var instance = aClass()
        
        for p in properties {
            /* Condition validation: Skip readonly property or weak object */
            if p.isReadonly || (p.isObject && p.isWeak) {
                continue
            }

            /* Condition validation: Validate nullable value */
            var value: AnyObject? = info[p.name]
            if value == nil || value is NSNull {
                continue
            }

            // Try to match value type with property type
            if p.isObject && p.isCollection && (value?.isKindOfClass(NSArray) == true || value?.isKindOfClass(NSDictionary) == true) {
                convertDataToModel(value!)
            }
            else if p.isObject && !p.isCollection && value?.isKindOfClass(NSDictionary) == true {
                value = convertDataToModel(value!)
            }

            // Try to convert string to primitive
            if let numberString = value as? String {
                if p.isPrimitive {
                    value = numberFormat.numberFromString(numberString)
                }
            }

            // Assign value to property
            if p.canAssignValue(value) {
                instance.setValue(value, forKey: p.name)
            }
            else {
                // Ignore the case
            }
        }
        return instance
    }
}
