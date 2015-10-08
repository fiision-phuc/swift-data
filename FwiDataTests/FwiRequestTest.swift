//  Project name: FwiData
//  File name   : FwiRequestTest.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 1/26/15
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright (c) 2015 Monster Group. All rights reserved.
//  --------------------------------------------------------------

import UIKit
import XCTest


class FwiRequestTest: XCTestCase {

    
    // MARK: Setup
    override func setUp() {
        super.setUp()
    }
    
    
    // MARK: Tear Down
    override func tearDown() {
        super.tearDown()
    }

    
    // MARK: Test Cases
    func testExample() {
        var request = FwiRequest()
        request.prepare()
        XCTAssert(true, "Pass")
    }
}
