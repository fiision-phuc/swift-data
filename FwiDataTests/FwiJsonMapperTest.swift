//  Project name: FwiData
//  File name   : FwiJsonMapperTest.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 12/6/14
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright (c) 2014 Monster Group. All rights reserved.
//  --------------------------------------------------------------

import UIKit
import XCTest


class SimpleModel : NSObject {

    override init() {
        super.init()
    }
    
    var name: NSString?
    var id: Int = 0
    var price: Double = 0
}

class DataDto : NSObject {


    // MARK: Class's constructors
    override init() {
        super.init()
    }


    // MARK: Class's properties
    var userData: NSDictionary?
    var feeds: NSArray?

    override var description: String {
        return "UserData: \(userData) \n Feeds:\(feeds)"
    }
}
class MessageDto : NSObject {


    // MARK: Class's constructors
    override init() {
        super.init()
    }


    // MARK: Class's properties
    var status: Int = 0
    var message: String?

    override var description: String {
        return "\(status) - \(message) \(data)"
    }
    var data: DataDto?
}



class FwiJsonMapperTest: XCTestCase {


    var json1 = ""
    var json2 = "[{\"id\":1,\"name\":\"A green door\",\"price\":12.50},{\"id\":1,\"name\":\"A green door\",\"price\":12.50},{\"id\":1,\"name\":\"A green door\",\"price\":12.50}]"
    var json3 = "[\"Some text here\",{\"id\":1,\"name\":\"A green door\",\"price\":12.50},{\"id\":1,\"name\":\"A green door\",\"price\":12.50},{\"id\":1,\"name\":\"A green door\",\"price\":12.50}]"
    var json4 = "{\"1\":{\"id\":1,\"name\":\"A green door\",\"price\":12.50},\"2\":{\"id\":1,\"name\":\"A green door\",\"price\":12.50},\"3\":{\"id\":1,\"name\":\"A green door\",\"price\":12.50}}"
    
    var jsonMapper: FwiJsonMapper?
    
    
    // MARK: Setup
    override func setUp() {
        super.setUp()

//        if let text = NSString(contentsOfURL: NSURL(string: "http://localhost:8080/resources/feed.txt")!, encoding: NSUTF8StringEncoding, error: nil) {
//            json1 = text
//        }
        if let text = NSString(contentsOfURL: NSURL(string: "http://community-test.gia.dev-vn.webonyx.local/ws/feeds/get")!, encoding: NSUTF8StringEncoding, error: nil) {
            json1 = text as String
        }
        jsonMapper = FwiJsonMapper()
    }
    
    
    // MARK: Tear Down
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    
    // MARK: Test Cases
    func testDecodeJsonWithModel() {
        var model: AnyObject? = jsonMapper?.decodeJsonStringWithModel(json1, model: [MessageDto.self, DataDto.self])
        if let m = model as? MessageDto {
            if let data = m.data {
                println("\(data)")
            }
//            if let data = m.data {
//                println("\(data.feeds)")
//            }
        }


//        XCTAssertNil(jsonMapper?.decodeJsonStringWithModel(json1, model: nil), "Mapper should return nil if jsonString is not defined.")
//        XCTAssertNil(jsonMapper?.decodeJsonStringWithModel (json1, model: nil), "Mapper should return nil if Model class is not defined.")
//        XCTAssertNil(jsonMapper?.decodeJsonStringWithModel("FwiData", model: SimpleModel.self), "Mapper should return nil if jsonString is invalid.")
//        XCTAssertNotNil(jsonMapper?.decodeJsonStringWithModel(json1, model: SimpleModel.self), "Mapper should return a defined model.")
    }
    
    func testCorrectnessOfDecodeJsonWithModelFunction() {
//        jsonMapper?.jsonString = json1
//        var model1: SimpleModel? = jsonMapper?.decodeJsonWithModel(json1, aClass: SimpleModel.self) as? SimpleModel
//        
//        XCTAssertNotNil(model1, "Model should not be nil.")
//        XCTAssertNotNil(model1?.name, "Model's name should not be nil.")
//        XCTAssertEqual(model1!.name!, "A green door", "Model's name should be A green door, but found \(model1?.name)")
//        XCTAssertEqual(model1!.id, 1, "Model's id should be 1, but found \(model1?.id)")
//        XCTAssertEqual(model1!.price, 12.50, "Model's id should be 12.50, but found \(model1?.price)")

        
//        jsonMapper?.jsonString = json2
//        var modelList: NSArray? = jsonMapper?.decodeJsonWithModel(SimpleModel) as? NSArray
//        XCTAssertNotNil(modelList, "Mapper should return a list of defined model.")
//        XCTAssertEqual(modelList!.count, 3, "List should have 3 items.")
//        XCTAssertEqual(modelList![0].name!, "A green door", "Model's name should be A green door, but found \(modelList?[0].name)")
//        XCTAssertEqual(modelList![0].id, 1, "Model's id should be 1, but found \(modelList?[0].id)")
//        XCTAssertEqual(modelList![0].price, 12.50, "Model's id should be 12.50, but found \(modelList?[0].price)")
//        
//        jsonMapper?.jsonString = json3
//        modelList = jsonMapper?.decodeJsonWithModel(SimpleModel) as? NSArray
//        XCTAssertNotNil(modelList, "Mapper should return a list of defined model.")
//        XCTAssertEqual(modelList!.count, 4, "List should have 3 items.")
//        XCTAssertEqual((modelList![0] as String), "Some text here", "First element should be Some text here, but found \(modelList![0])")
//        XCTAssertEqual(modelList![1].name!, "A green door", "Model's name should be A green door, but found \(modelList?[1].name)")
//        XCTAssertEqual(modelList![1].id, 1, "Model's id should be 1, but found \(modelList?[1].id)")
//        XCTAssertEqual(modelList![1].price, 12.50, "Model's id should be 12.50, but found \(modelList?[1].price)")
    }
}
