//
//  HouseProductsUITests.swift
//  HouseProductsUITests
//
//  Created by Pran Kishore on 25/07/18.
//  Copyright © 2018 Sample Projects. All rights reserved.
//

import XCTest

class HouseProductsUITests: XCTestCase {
    
    var application : XCUIApplication!
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        application = XCUIApplication()
        application.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let startButton = application.buttons["Start"]
        XCTAssert(startButton.exists)
        startButton.tap()
        
        //TODO: Create a method to wait for spinner to disappear.
        sleep(5) // Wait for item to load
        
        //Like 3 items
        let thumbUpBlackButton = application.buttons["thumb up black"]
        XCTAssert(thumbUpBlackButton.exists)
        for _ in 1...3 {
            thumbUpBlackButton.tap()
            sleep(1) // Need to pause between button taps
        }
        
        //Dislike 7 items
        let thumbDownBlackButton = application.buttons["thumb down black"]
        XCTAssert(thumbDownBlackButton.exists)
        for _ in 1...7 {
            thumbDownBlackButton.tap()
            sleep(1) // Need to pause between button taps
        }
        
        //Tap the alert button
        application.alerts["House Product"].buttons["OK"].tap()
        
        //Move to review screen
        application.buttons["Review"].tap()
        
        //Switch to different Views
        let listButton = application.buttons["List View"]
        XCTAssert(listButton.exists)
        listButton.tap()
        
        let gridButton = application.buttons["Grid View"]
        XCTAssert(gridButton.exists)
        gridButton.tap()
        
        //User should be able to navigate back
        application.navigationBars["Review"].buttons["Select"].tap()
        application.navigationBars["Select"].buttons["Home"].tap()
        
        //Reached back again
        let button = application.buttons["Start"]
        XCTAssert(button.exists)
    }
}
