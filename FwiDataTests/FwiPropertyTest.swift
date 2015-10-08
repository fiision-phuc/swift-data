//  Project name: FwiData
//  File name   : FwiPropertyTest.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 12/5/14
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright (c) 2014 Monster Group. All rights reserved.
//  --------------------------------------------------------------

import UIKit
import XCTest
import FwiCore
import CoreLocation


class ParentModel: NSObject {
    
    var assignProperty: Int = 0
    var boolProperty: Bool = false
    
    var copyProperty: String?
    var retainProperty: NSString?
    var readonlyProperty: String? {
        return _readonlyProperty
    }
    
    var arrayProperty: [String]?
    var nssetProperty: NSSet?
    var nsarrayProperty: NSArray?

    var dictionaryProperty: [String: String]?
    var nsdictionaryProperty: NSDictionary?
    
    var dateProperty: NSDate?
    var locationProperty: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    var urlProperty: NSURL?
    
    var modelProperty: ParentModel?
    weak var weakModelProperty: ParentModel?
    
    var idProperty: AnyObject?
    
    private var _readonlyProperty: String?
}

class ChildModel: ParentModel {
    
    var stringProperty: String?
    var numberProperty: NSNumber?
}

class FwiPropertyTest: XCTestCase {
    
    
    // MARK: Class's properties
    var assignProperty: FwiProperty?
    var boolProperty: FwiProperty?
    
    var copyProperty: FwiProperty?
    var retainProperty: FwiProperty?
    var readonlyProperty: FwiProperty?
    
    var arrayProperty: FwiProperty?
    var nssetProperty: FwiProperty?
    var nsarrayProperty: FwiProperty?
    
    var dictionaryProperty: FwiProperty?
    var nsdictionaryProperty: FwiProperty?
    
    var dateProperty: FwiProperty?
    var locationProperty: FwiProperty?
    var urlProperty: FwiProperty?
    
    var modelProperty: FwiProperty?
    var weakModelProperty: FwiProperty?
    
    var idProperty: FwiProperty?
    
    
    // MARK: Setup
    override func setUp() {
        super.setUp()

        var properties = FwiProperty.propertiesWithClass(ParentModel)!
        for property in properties {
            if let p = property as? FwiProperty {
                if (p.name == "assignProperty") {
                    assignProperty = p
                } else if (p.name == "boolProperty") {
                    boolProperty = p
                } else if (p.name == "copyProperty") {
                    copyProperty = p
                } else if (p.name == "retainProperty") {
                    retainProperty = p
                } else if (p.name == "readonlyProperty") {
                    readonlyProperty = p
                } else if (p.name == "arrayProperty") {
                    arrayProperty = p
                } else if (p.name == "nssetProperty") {
                    nssetProperty = p
                } else if (p.name == "nsarrayProperty") {
                    nsarrayProperty = p
                } else if (p.name == "dictionaryProperty") {
                    dictionaryProperty = p
                } else if (p.name == "nsdictionaryProperty") {
                    nsdictionaryProperty = p
                } else if (p.name == "dateProperty") {
                    dateProperty = p
                } else if (p.name == "locationProperty") {
                    locationProperty = p
                } else if (p.name == "urlProperty") {
                    urlProperty = p
                } else if (p.name == "modelProperty") {
                    modelProperty = p
                } else if (p.name == "weakModelProperty") {
                    weakModelProperty = p
                } else if (p.name == "idProperty") {
                    idProperty = p
                }
            }
        }
    }
    
    
    // MARK: Tear Down
    override func tearDown() {
        super.tearDown()
    }

    
    // MARK: Test Cases
    func testCreation() {
        var defaultProperty = FwiProperty(property: nil)
        XCTAssertFalse(defaultProperty.isAssign, "Default property should return false.")
        XCTAssertFalse(defaultProperty.isCopy, "Default property should return false.")
        XCTAssertFalse(defaultProperty.isDynamic, "Default property should return false.")
        XCTAssertFalse(defaultProperty.isNonatomic, "Default property should return false.")
        XCTAssertFalse(defaultProperty.isReadonly, "Default property should return false.")
        XCTAssertFalse(defaultProperty.isRetain, "Default property should return false.")
        XCTAssertFalse(defaultProperty.isWeak, "Default property should return false.")
        XCTAssertFalse(defaultProperty.isWeakReference, "Default property should return false.")
        XCTAssertFalse(defaultProperty.isBlock, "Default property should return false.")
        XCTAssertFalse(defaultProperty.isCollection, "Default property should return false.")
        XCTAssertFalse(defaultProperty.isId, "Default property should return false.")
        XCTAssertFalse(defaultProperty.isObject, "Default property should return false.")
        XCTAssertFalse(defaultProperty.isPrimitive, "Default property should return false.")
        XCTAssertEqual(defaultProperty.name, "", "Default property's name should be empty, but found \(defaultProperty.name).")
        XCTAssertEqual(defaultProperty.ivarName, "", "Default property's ivarName should be empty, but found \(defaultProperty.ivarName).")
        XCTAssertNil(defaultProperty.propertyClass, "Default property should not have a propertyClass.")
        XCTAssertNil(defaultProperty.propertyType, "Default property should not have a propertyType.")
        XCTAssertNil(defaultProperty.typeEncoding, "Default property's Type Encoding should be nil, but found \(defaultProperty.typeEncoding)")
        XCTAssertNil(defaultProperty.typeOldEncoding, "Default property's Type Old Encoding should be nil, but found \(defaultProperty.typeEncoding)")
        
        
        XCTAssertNil(FwiProperty.propertiesWithClass(nil), "List should be nil.")
        
        var properties = FwiProperty.propertiesWithClass(ParentModel)
        XCTAssertNotNil(properties, "List must not be nil.")
        XCTAssertEqual(properties!.count, 16, "List must have 16, but found \(properties?.count)")
        
        properties = FwiProperty.propertiesWithClass(ChildModel)
        XCTAssertNotNil(properties, "List must not be nil.")
        XCTAssertEqual(properties!.count, 18, "List must have 18, but found \(properties?.count)")
    }
    
    func testAssignProperty() {
        XCTAssertTrue(assignProperty?.isAssign == true, "Setter semantics should be assign.")
        XCTAssertTrue(assignProperty?.isCopy == false, "Setter semantics should not be copied.")
        XCTAssertTrue(assignProperty?.isDynamic == false, "Setter semantics should not be dynamic.")
        XCTAssertTrue(assignProperty?.isNonatomic == true, "Setter semantics should be non-atomic.")
        XCTAssertTrue(assignProperty?.isReadonly == false, "Property should not be read-only.")
        XCTAssertTrue(assignProperty?.isRetain == false, "Property should not be retain.")
        XCTAssertTrue(assignProperty?.isWeak == false, "Property should not be weak.")
        XCTAssertTrue(assignProperty?.isBlock == false, "Property should not be block.")
        XCTAssertTrue(assignProperty?.isCollection == false, "Property should not be collection.")
        XCTAssertTrue(assignProperty?.isId == false, "Property should not be id.")
        XCTAssertTrue(assignProperty?.isObject == false, "Property should not be object.")
        XCTAssertTrue(assignProperty?.isPrimitive == true, "Property should be primitive.")
        XCTAssertEqual(assignProperty!.name, "assignProperty", "Name should be assignProperty, but found \(assignProperty?.name).")
        XCTAssertEqual(assignProperty!.ivarName, "assignProperty", "ivarName should be assignProperty, but found \(assignProperty?.ivarName).")
        XCTAssertNil(assignProperty?.propertyClass, "Property should not have a propertyClass.")
        XCTAssertTrue(assignProperty?.typeEncoding == "l", "Type encoding should be l, but found \(assignProperty?.typeEncoding).")
        
        XCTAssertTrue(boolProperty?.isAssign == true, "Setter semantics should be assign.")
        XCTAssertTrue(boolProperty?.isCopy == false, "Setter semantics should not be copied.")
        XCTAssertTrue(boolProperty?.isDynamic == false, "Setter semantics should not be dynamic.")
        XCTAssertTrue(boolProperty?.isNonatomic == true, "Setter semantics should be non-atomic.")
        XCTAssertTrue(boolProperty?.isReadonly == false, "Property should not be read-only.")
        XCTAssertTrue(boolProperty?.isRetain == false, "Property should not be retain.")
        XCTAssertTrue(boolProperty?.isWeak == false, "Property should not be weak.")
        XCTAssertTrue(boolProperty?.isBlock == false, "Property should not be block.")
        XCTAssertTrue(boolProperty?.isCollection == false, "Property should not be collection.")
        XCTAssertTrue(boolProperty?.isId == false, "Property should not be id.")
        XCTAssertTrue(boolProperty?.isObject == false, "Property should not be object.")
        XCTAssertTrue(boolProperty?.isPrimitive == true, "Property should be primitive.")
        XCTAssertEqual(boolProperty!.name, "boolProperty", "Name should be boolProperty, but found \(boolProperty?.name).")
        XCTAssertEqual(boolProperty!.ivarName, "boolProperty", "ivarName should be boolProperty, but found \(boolProperty?.ivarName).")
        XCTAssertNil(boolProperty?.propertyClass, "Property should not have a propertyClass.")
        XCTAssertTrue(boolProperty?.typeEncoding == "B", "Type encoding should be B, but found \(boolProperty?.typeEncoding).")
    }
    
    func testRetainProperty() {
        XCTAssertTrue(retainProperty?.isAssign == false, "Setter semantics should not be assign.")
        XCTAssertTrue(retainProperty?.isCopy == false, "Setter semantics should not be copied.")
        XCTAssertTrue(retainProperty?.isDynamic == false, "Setter semantics should not be dynamic.")
        XCTAssertTrue(retainProperty?.isNonatomic == true, "Setter semantics should be non-atomic.")
        XCTAssertTrue(retainProperty?.isReadonly == false, "Retain property should not be read-only.")
        XCTAssertTrue(retainProperty?.isRetain == true, "Retain property should be retain.")
        XCTAssertTrue(retainProperty?.isWeak == false, "Retain property should not be weak.")
        XCTAssertTrue(retainProperty?.isBlock == false, "Retain property should not be block.")
        XCTAssertTrue(retainProperty?.isCollection == false, "Retain property should not be collection.")
        XCTAssertTrue(retainProperty?.isId == false, "Retain property should not be id.")
        XCTAssertTrue(retainProperty?.isObject == true, "Retain property should be object.")
        XCTAssertTrue(retainProperty?.isPrimitive == false, "Retain property should not be primitive.")
        XCTAssertEqual(retainProperty!.name, "retainProperty", "Name should be retainProperty, but found \(retainProperty?.name).")
        XCTAssertEqual(retainProperty!.ivarName, "retainProperty", "ivarName should be retainProperty, but found \(retainProperty?.ivarName).")
        XCTAssertNotNil(retainProperty?.propertyClass, "Retain property should have a propertyClass.")
        XCTAssertEqual(NSStringFromClass(retainProperty!.propertyClass!), "NSString", "Class should be NSString, but found \(retainProperty?.propertyClass).")
        XCTAssertTrue(retainProperty?.typeEncoding == "@\"NSString\"", "Type encoding should be @\"NSString\", but found \(retainProperty?.typeEncoding).")
    }
    
    func testReadonlyProperty() {
        XCTAssertTrue(readonlyProperty?.isAssign == true, "Setter semantics should be assign.")
        XCTAssertTrue(readonlyProperty?.isCopy == false, "Setter semantics should not be copied.")
        XCTAssertTrue(readonlyProperty?.isDynamic == false, "Setter semantics should not be dynamic.")
        XCTAssertTrue(readonlyProperty?.isNonatomic == true, "Setter semantics should be non-atomic.")
        XCTAssertTrue(readonlyProperty?.isReadonly == true, "Readonly property should be read-only.")
        XCTAssertTrue(readonlyProperty?.isRetain == false, "Readonly property should not be retain.")
        XCTAssertTrue(readonlyProperty?.isWeak == true, "Readonly property should be weak.")
        XCTAssertTrue(readonlyProperty?.isBlock == false, "Readonly property should not be block.")
        XCTAssertTrue(readonlyProperty?.isCollection == false, "Readonly property should not be collection.")
        XCTAssertTrue(readonlyProperty?.isId == true, "Readonly property should be id.")
        XCTAssertTrue(readonlyProperty?.isObject == true, "Readonly property should be object.")
        XCTAssertTrue(readonlyProperty?.isPrimitive == false, "Readonly property should not be primitive.")
        XCTAssertEqual(readonlyProperty!.name, "readonlyProperty", "Name should be readonlyProperty, but found \(readonlyProperty?.name).")
        XCTAssertEqual(readonlyProperty!.ivarName, "", "Readonly property should not have ivarName.")
        XCTAssertNil(readonlyProperty?.propertyClass, "Readonly property should not have a propertyClass.")
        XCTAssertTrue(readonlyProperty?.typeEncoding == "@", "Type encoding should be @, but found \(readonlyProperty?.typeEncoding)")
    }
    
    func testNSSetProperty() {
        XCTAssertTrue(nssetProperty?.isAssign == false, "Setter semantics should not be assign.")
        XCTAssertTrue(nssetProperty?.isCopy == false, "Setter semantics should not be copied.")
        XCTAssertTrue(nssetProperty?.isDynamic == false, "Setter semantics should not be dynamic.")
        XCTAssertTrue(nssetProperty?.isNonatomic == true, "Setter semantics should be non-atomic.")
        XCTAssertTrue(nssetProperty?.isReadonly == false, "NSSet property should not be read-only.")
        XCTAssertTrue(nssetProperty?.isRetain == true, "NSSet property should be retain.")
        XCTAssertTrue(nssetProperty?.isWeak == false, "NSSet property should not be weak.")
        XCTAssertTrue(nssetProperty?.isBlock == false, "NSSet property should not be block.")
        XCTAssertTrue(nssetProperty?.isCollection == true, "NSSet property should be collection.")
        XCTAssertTrue(nssetProperty?.isId == false, "NSSet property should not be id.")
        XCTAssertTrue(nssetProperty?.isObject == true, "NSSet property should be object.")
        XCTAssertTrue(nssetProperty?.isPrimitive == false, "NSSet property should not be primitive.")
        XCTAssertEqual(nssetProperty!.name, "nssetProperty", "Name should be nssetProperty, but found \(nssetProperty?.name).")
        XCTAssertEqual(nssetProperty!.ivarName, "nssetProperty", "ivarName should be nssetProperty, but found \(nssetProperty?.ivarName).")
        XCTAssertNotNil(nssetProperty?.propertyClass, "NSSet property should have a propertyClass.")
        XCTAssertEqual(NSStringFromClass(nssetProperty!.propertyClass!), "NSSet", "Class should be NSSet, but found \(nssetProperty?.propertyClass)")
        XCTAssertTrue(nssetProperty?.typeEncoding == "@\"NSSet\"", "Type encoding should be @\"NSSet\", but found \(nssetProperty?.typeEncoding)")
    }
    
    func testNSArrayProperty() {
        XCTAssertTrue(nsarrayProperty?.isAssign == false, "Setter semantics should not be assign.")
        XCTAssertTrue(nsarrayProperty?.isCopy == false, "Setter semantics should not be copied.")
        XCTAssertTrue(nsarrayProperty?.isDynamic == false, "Setter semantics should not be dynamic.")
        XCTAssertTrue(nsarrayProperty?.isNonatomic == true, "Setter semantics should be non-atomic.")
        XCTAssertTrue(nsarrayProperty?.isReadonly == false, "NSArray property should not be read-only.")
        XCTAssertTrue(nsarrayProperty?.isRetain == true, "NSArray property should be retain.")
        XCTAssertTrue(nsarrayProperty?.isWeak == false, "NSArray property should not be weak.")
        XCTAssertTrue(nsarrayProperty?.isBlock == false, "NSArray property should not be block.")
        XCTAssertTrue(nsarrayProperty?.isCollection == true, "NSArray property should be collection.")
        XCTAssertTrue(nsarrayProperty?.isId == false, "NSArray property should not be id.")
        XCTAssertTrue(nsarrayProperty?.isObject == true, "NSArray property should be object.")
        XCTAssertTrue(nsarrayProperty?.isPrimitive == false, "NSArray property should not be primitive.")
        XCTAssertEqual(nsarrayProperty!.name, "nsarrayProperty", "Name should be nsarrayProperty, but found \(nsarrayProperty?.name).")
        XCTAssertEqual(nsarrayProperty!.ivarName, "nsarrayProperty", "ivarName should be nsarrayProperty, but found \(nsarrayProperty?.ivarName).")
        XCTAssertNotNil(nsarrayProperty?.propertyClass, "NSArray property should have a propertyClass.")
        XCTAssertEqual(NSStringFromClass(nsarrayProperty!.propertyClass!), "NSArray", "Class should be NSArray, but found \(nsarrayProperty?.propertyClass)")
        XCTAssertTrue(nsarrayProperty?.typeEncoding == "@\"NSArray\"", "Type encoding should be @\"NSArray\", but found \(nsarrayProperty?.typeEncoding)")
    }
    
    func testNSDictionaryProperty() {
        XCTAssertTrue(nsdictionaryProperty?.isAssign == false, "Setter semantics should not be assign.")
        XCTAssertTrue(nsdictionaryProperty?.isCopy == false, "Setter semantics should not be copied.")
        XCTAssertTrue(nsdictionaryProperty?.isDynamic == false, "Setter semantics should not be dynamic.")
        XCTAssertTrue(nsdictionaryProperty?.isNonatomic == true, "Setter semantics should be non-atomic.")
        XCTAssertTrue(nsdictionaryProperty?.isReadonly == false, "NSDictionary property should not be read-only.")
        XCTAssertTrue(nsdictionaryProperty?.isRetain == true, "NSDictionary property should be retain.")
        XCTAssertTrue(nsdictionaryProperty?.isWeak == false, "NSDictionary property should not be weak.")
        XCTAssertTrue(nsdictionaryProperty?.isBlock == false, "NSDictionary property should not be block.")
        XCTAssertTrue(nsdictionaryProperty?.isCollection == true, "NSDictionary property should be collection.")
        XCTAssertTrue(nsdictionaryProperty?.isId == false, "NSDictionary property should not be id.")
        XCTAssertTrue(nsdictionaryProperty?.isObject == true, "NSDictionary property should be object.")
        XCTAssertTrue(nsdictionaryProperty?.isPrimitive == false, "NSDictionary property should not be primitive.")
        XCTAssertEqual(nsdictionaryProperty!.name, "nsdictionaryProperty", "Name should be nsdictionaryProperty, but found \(nsdictionaryProperty?.name).")
        XCTAssertEqual(nsdictionaryProperty!.ivarName, "nsdictionaryProperty", "ivarName should be nsdictionaryProperty, but found \(nsdictionaryProperty?.ivarName).")
        XCTAssertNotNil(nsdictionaryProperty?.propertyClass, "NSDictionary property should have a propertyClass.")
        XCTAssertEqual(NSStringFromClass(nsdictionaryProperty!.propertyClass!), "NSDictionary", "Class should be NSDictionary, but found \(nsdictionaryProperty?.propertyClass)")
        XCTAssertTrue(nsdictionaryProperty?.typeEncoding == "@\"NSDictionary\"", "Type encoding should be @\"NSDictionary\", but found \(nsdictionaryProperty?.typeEncoding)")
    }
    
    func testLocationProperty() { // Structure type, not yet supported.
        XCTAssertTrue(locationProperty?.isAssign == true, "Setter semantics should be assign.")
        XCTAssertTrue(locationProperty?.isCopy == false, "Setter semantics should not be copied.")
        XCTAssertTrue(locationProperty?.isDynamic == false, "Setter semantics should not be dynamic.")
        XCTAssertTrue(locationProperty?.isNonatomic == true, "Setter semantics should be non-atomic.")
        XCTAssertTrue(locationProperty?.isReadonly == false, "NSDictionary property should not be read-only.")
        XCTAssertTrue(locationProperty?.isRetain == false, "Location property should not be retain.")
        XCTAssertTrue(locationProperty?.isWeak == false, "Location property should not be weak.")
        XCTAssertTrue(locationProperty?.isBlock == false, "Location property should not be block.")
        XCTAssertTrue(locationProperty?.isCollection == false, "Location property should be collection.")
        XCTAssertTrue(locationProperty?.isId == false, "Location property should not be id.")
        XCTAssertTrue(locationProperty?.isObject == false, "Location property should be object.")
        XCTAssertTrue(locationProperty?.isPrimitive == false, "Location property should not be primitive.")
        XCTAssertEqual(locationProperty!.name, "locationProperty", "Name should be locationProperty, but found \(locationProperty?.name).")
        XCTAssertEqual(locationProperty!.ivarName, "locationProperty", "ivarName should be locationProperty, but found \(locationProperty?.ivarName).")
        XCTAssertNil(locationProperty?.propertyClass, "Location property should not have a propertyClass.")
        XCTAssertTrue(locationProperty?.typeEncoding == "{?=dd}", "Type encoding should be {?=dd}, but found \(locationProperty?.typeEncoding)")
    }
    
    
    
    
    func testSwiftStringProperty() { // Swift String is not yet detected.
        XCTAssertTrue(copyProperty?.isAssign == false, "Setter semantics should not be assign.")
        XCTAssertTrue(copyProperty?.isCopy == true, "Setter semantics should be copied.")                                  // ???
        XCTAssertTrue(copyProperty?.isDynamic == false, "Setter semantics should not be dynamic.")
        XCTAssertTrue(copyProperty?.isNonatomic == true, "Setter semantics should be non-atomic.")
        XCTAssertTrue(copyProperty?.isReadonly == false, "Swift string property should not be read-only.")
        XCTAssertTrue(copyProperty?.isRetain == false, "Swift string property should not be retain.")
        XCTAssertTrue(copyProperty?.isWeak == false, "Swift string property should not be weak.")
        XCTAssertTrue(copyProperty?.isBlock == false, "Swift string property should not be block.")
        XCTAssertTrue(copyProperty?.isCollection == false, "Swift string property should not be collection.")
        XCTAssertTrue(copyProperty?.isId == true, "Swift string property should be id.")
        XCTAssertTrue(copyProperty?.isObject == true, "Swift string property should be object.")
        XCTAssertTrue(copyProperty?.isPrimitive == false, "Swift string property should not be primitive.")
        XCTAssertEqual(copyProperty!.name, "copyProperty", "Name should be copyProperty, but found \(copyProperty?.name).")
        XCTAssertEqual(copyProperty!.ivarName, "copyProperty", "ivarName should be copyProperty, but found \(copyProperty?.ivarName).")
        XCTAssertNil(copyProperty?.propertyClass, "Swift string property should not have a propertyClass.")
        XCTAssertTrue(copyProperty?.typeEncoding == "@", "Type encoding should be @, but found \(copyProperty?.typeEncoding)")
    }
    
    func testSwiftArrayProperty() { // Swift Array is not yet detected.
        XCTAssertTrue(arrayProperty?.isAssign == false, "Setter semantics should not be assign.")
        XCTAssertTrue(arrayProperty?.isCopy == true, "Setter semantics should be copied.")                                 // ???
        XCTAssertTrue(arrayProperty?.isDynamic == false, "Setter semantics should not be dynamic.")
        XCTAssertTrue(arrayProperty?.isNonatomic == true, "Setter semantics should be non-atomic.")
        XCTAssertTrue(arrayProperty?.isReadonly == false, "Swift array property should not be read-only.")
        XCTAssertTrue(arrayProperty?.isRetain == false, "Swift array property should not be retain.")
        XCTAssertTrue(arrayProperty?.isWeak == false, "Swift array property should not be weak.")
        XCTAssertTrue(arrayProperty?.isBlock == false, "Swift array property should not be block.")
        XCTAssertTrue(arrayProperty?.isCollection == false, "Swift array property should be collection.")                  // ???
        XCTAssertTrue(arrayProperty?.isId == true, "Swift array property should not be id.")
        XCTAssertTrue(arrayProperty?.isObject == true, "Swift array property should be object.")
        XCTAssertTrue(arrayProperty?.isPrimitive == false, "Swift array property should not be primitive.")
        XCTAssertEqual(arrayProperty!.name, "arrayProperty", "Name should be arrayProperty, but found \(arrayProperty?.name).")
        XCTAssertEqual(arrayProperty!.ivarName, "arrayProperty", "ivarName should be arrayProperty, but found \(arrayProperty?.ivarName).")
        XCTAssertNil(arrayProperty?.propertyClass, "Swift array property should not have a propertyClass.")
        XCTAssertTrue(arrayProperty?.typeEncoding == "@", "Type encoding should be @, but found \(arrayProperty?.typeEncoding)")
    }
    
    func testSwiftDictionaryProperty() { // Swift Dictionary is not yet detected.
        XCTAssertTrue(dictionaryProperty?.isAssign == false, "Setter semantics should not be assign.")
        XCTAssertTrue(dictionaryProperty?.isCopy == true, "Setter semantics should be copied.")                            // ???
        XCTAssertTrue(dictionaryProperty?.isDynamic == false, "Setter semantics should not be dynamic.")
        XCTAssertTrue(dictionaryProperty?.isNonatomic == true, "Setter semantics should be non-atomic.")
        XCTAssertTrue(dictionaryProperty?.isReadonly == false, "Swift dictionary property should not be read-only.")
        XCTAssertTrue(dictionaryProperty?.isRetain == false, "Swift dictionary property should not be retain.")
        XCTAssertTrue(dictionaryProperty?.isWeak == false, "Swift dictionary property should not be weak.")
        XCTAssertTrue(dictionaryProperty?.isBlock == false, "Swift dictionary property should not be block.")
        XCTAssertTrue(dictionaryProperty?.isCollection == false, "Swift dictionary property should be collection.")        // ???
        XCTAssertTrue(dictionaryProperty?.isId == true, "Swift dictionary property should not be id.")
        XCTAssertTrue(dictionaryProperty?.isObject == true, "Swift dictionary property should be object.")
        XCTAssertTrue(dictionaryProperty?.isPrimitive == false, "Swift dictionary property should not be primitive.")
        XCTAssertEqual(dictionaryProperty!.name, "dictionaryProperty", "Name should be dictionaryProperty, but found \(dictionaryProperty?.name).")
        XCTAssertEqual(dictionaryProperty!.ivarName, "dictionaryProperty", "ivarName should be dictionaryProperty, but found \(dictionaryProperty?.ivarName).")
        XCTAssertNil(dictionaryProperty?.propertyClass, "Swift dictionary property should not have a propertyClass.")
        XCTAssertTrue(dictionaryProperty?.typeEncoding == "@", "Type encoding should be @, but found \(dictionaryProperty?.typeEncoding)")
    }
    
    
    
    
    func testIntCanAcceptNSNumber() {
        var number = NSNumber(int: 8)
        XCTAssertTrue(assignProperty?.canAssignValue(number) == true, "Assign property should be able to accept NSNumber.")
    }
    
    func testBoolCanAcceptNSNumber() {
        var number = NSNumber(int: 1)
        XCTAssertTrue(boolProperty?.canAssignValue(number) == true, "Bool property should be able to accept NSNumber.")
    }
    
    func testBoolCanAcceptNSNumberWithBool() {
        var number = NSNumber(bool: true)
        XCTAssertTrue(boolProperty?.canAssignValue(number) == true, "Bool property should be able to accept NSNumber.")
    }
    
    func testStringCanAcceptString() {
        XCTAssertTrue(copyProperty?.canAssignValue("") == true, "String property should be able to accept String.")
        XCTAssertTrue(retainProperty?.canAssignValue("") == true, "NSString property should be able to accept String.")
    }
    
    func testStringCannotAcceptNumber() {
//        XCTAssertTrue(copyProperty?.canAssignValue(NSNumber(int: 8)) == false, "String property should not be able to accept NSNumber.")
        XCTAssertTrue(retainProperty?.canAssignValue(NSNumber(int: 8)) == false, "NSString property should not be able to accept NSNumber.")
    }

    func testIntCannotAcceptString() {
        XCTAssertTrue(assignProperty?.canAssignValue("") == false, "Assign property should not be able to accept String.")
    }
}
