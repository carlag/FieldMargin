//
//  ValidationServiceTests.swift
//  FieldMargin
//
//  Created by Carla on 2017/08/16.
//  Copyright © 2017 Carla. All rights reserved.
//

import Foundation



import XCTest
@testable import FieldMargin

class ValidationServiceTests: XCTestCase {
    
    let input = TestInput()
    var validationService : ValidationService?
    
    override func setUp() {
        super.setUp()
        self.validationService = ValidationService()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInvalidCrateString1() {
        let (valid, _) = (self.validationService?.validateCrates(text: "()"))!
        assert(!valid)
    }
    
    func testInvalidCrateString2() {
        let (valid, _) = (self.validationService?.validateCrates(text: "(123)"))!
        assert(!valid)
    }
    
    func testInvalidCrateString3() {
        let (valid, _) = (self.validationService?.validateCrates(text: "(1,1)"))!
        assert(!valid)
    }
    
    func testInvalidCrateString4() {
        let (valid, _) = (self.validationService?.validateCrates(text: "(1,2,3)"))!
        assert(valid)
    }
}
