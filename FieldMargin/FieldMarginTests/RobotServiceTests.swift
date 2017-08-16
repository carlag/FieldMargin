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
    var robotService : RobotService?
    
    override func setUp() {
        super.setUp()
        self.robotService = RobotService()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testMoveCommands() {
        self.robotService?.robot = TestInput.AllGood().robot
        self.robotService?.belt = TestInput.AllGood().belt
        self.robotService?.crates = TestInput.AllGood().crates
        self.robotService?.commands = TestInput.AllGood().instructions

        
        self.robotService?.startRobot()
        
        let health = self.robotService?.robot?.health
        let position = self.robotService?.robot?.position
        let beltBags = self.robotService?.belt?.bagCount

        assert(health == Health.StillFunctioning)
        assert(position == CGPoint(x: 1, y:-3))
        assert(beltBags == 1)
    }
    
    
    func testRobotDropsBagAtPositionOtherThanBelt() {
        self.robotService?.robot = Robot(position:CGPoint(x:0, y:0))
        self.robotService?.belt = Belt(position: CGPoint(x:1, y:1))
        self.robotService?.crates = [Crate(position:CGPoint(x:0, y:0), quantity: 2)]
        self.robotService?.commands = [.Drop]
     
        self.robotService?.robot?.bagCount = 1
        self.robotService?.startRobot()
        
        let health = self.robotService?.robot?.health
        
        assert(health == Health.ShortCircuited)
    }
    
    
    func testNoCrateAtPosition() {
        self.robotService?.robot = Robot(position:CGPoint(x:0, y:0))
        self.robotService?.belt = Belt(position: CGPoint(x:1, y:0))
        self.robotService?.crates = [Crate(position:CGPoint(x:1, y:1), quantity: 0)]
        self.robotService?.commands = [.Pickup]

        self.robotService?.startRobot()
        
        let health = self.robotService?.robot?.health
        
        assert(health == Health.ShortCircuited)
    }
    
    func testEmptyCrates() {
        
        self.robotService?.robot = Robot(position:CGPoint(x:0, y:0))
        self.robotService?.belt = Belt(position: CGPoint(x:1, y:0))
        self.robotService?.crates = [Crate(position:CGPoint(x:0, y:0), quantity: 0)]
        self.robotService?.commands = [.Pickup, .East, .Drop]

        self.robotService?.startRobot()
        
        let health = self.robotService?.robot?.health
        
        assert(health == Health.StillFunctioning)
    }
    
    func testRobotHasNoBagsToDrop() {
        self.robotService?.robot =  TestInput.RobotHasNoBagsToDrop().robot
        self.robotService?.belt = TestInput.RobotHasNoBagsToDrop().belt
        self.robotService?.crates = []
        self.robotService?.commands =  TestInput.RobotHasNoBagsToDrop().instructions

        self.robotService?.startRobot()
        
        let health = self.robotService?.robot?.health

        assert(health == Health.StillFunctioning)
        
    }
    
}
