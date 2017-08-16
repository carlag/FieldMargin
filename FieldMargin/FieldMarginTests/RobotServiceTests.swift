//
//  FieldMarginTests.swift
//  FieldMarginTests
//
//  Created by Carla on 2017/08/13.
//  Copyright © 2017 Carla. All rights reserved.
//

import XCTest
@testable import FieldMargin

class RobotServiceTests: XCTestCase {
    
    let input = TestInput()
    var viewModel : RobotService?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testMoveCommands() {
        self.viewModel = RobotService(robot: TestInput.AllGood().robot, belt: TestInput.AllGood().belt, crates: TestInput.AllGood().crates, instructions: TestInput.AllGood().instructions)
        self.viewModel?.startRobot()
        
        let health = self.viewModel?.robot?.health
        let position = self.viewModel?.robot?.position
        let beltBags = self.viewModel?.belt?.bagCount

        assert(health == Health.StillFunctioning)
        assert(position == CGPoint(x: 1, y:-3))
        assert(beltBags == 2)
    }
    
    
    func testRobotDropsBagAtPositionOtherThanBelt() {
        viewModel = RobotService(robot: Robot(position:CGPoint(x:0, y:0)),
                                          belt: Belt(position: CGPoint(x:1, y:1)),
                                          crates: [Crate(position:CGPoint(x:0, y:0), quantity: 2)],
                                          instructions: [.D])
        self.viewModel?.robot?.bagCount = 1
        self.viewModel?.startRobot()
        
        let health = self.viewModel?.robot?.health
        
        assert(health == Health.ShortCircuited)
    }
    
    
    func testNoCrateAtPosition() {
        viewModel = RobotService(robot: Robot(position:CGPoint(x:0, y:0)),
                                          belt: Belt(position: CGPoint(x:1, y:0)),
                                          crates: [Crate(position:CGPoint(x:1,y:1), quantity: 0)],
                                          instructions: [.P])
        self.viewModel?.startRobot()
        
        let health = self.viewModel?.robot?.health
        
        assert(health == Health.ShortCircuited)
    }
    
    func testEmptyCrates() {
        viewModel = RobotService(robot: Robot(position:CGPoint(x:0, y:0)),
                                          belt: Belt(position: CGPoint(x:1, y:0)),
                                          crates: [Crate(position:CGPoint(x:0,y:0), quantity: 0)],
                                          instructions: [.P, .E, .D])
        self.viewModel?.startRobot()
        
        let health = self.viewModel?.robot?.health
        
        assert(health == Health.StillFunctioning)
    }
    
    func testRobotHasNoBagsToDrop() {
        viewModel = RobotService(robot: TestInput.RobotHasNoBagsToDrop().robot, belt: TestInput.RobotHasNoBagsToDrop().belt, crates: [], instructions: TestInput.RobotHasNoBagsToDrop().instructions)
        self.viewModel?.startRobot()
        
        let health = self.viewModel?.robot?.health

        assert(health == Health.StillFunctioning)
        
    }
    
}
