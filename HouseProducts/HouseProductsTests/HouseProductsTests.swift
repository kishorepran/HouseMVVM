//
//  HouseProductsTests.swift
//  HouseProductsTests
//
//  Created by Pran Kishore on 25/07/18.
//  Copyright © 2018 Sample Projects. All rights reserved.
//

import XCTest
@testable import HouseProducts

class HouseProductsTests: XCTestCase {
    
    let expectation = XCTestExpectation(description: "Download Item Data")
    let viewModel = HPViewModel()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testViewModel() {
        // Create an expectation for a download task.
        
        viewModel.delegate = self
        viewModel.getProductsList()
        // Wait until the expectation is fulfilled, with a timeout of 10 seconds.
        wait(for: [expectation], timeout: 10.0)
    }
    
}

extension HouseProductsTests : ViewModelDelegate {
    
    func viewModelDidUpdate(sender : HPViewModel) {
        guard let items = viewModel.products else {
            XCTFail("No products")
            return
        }
        //For now we have static URL have products
        XCTAssert(viewModel.totalItems >= 10)
        
        //Like first 4 products
        for index in 0...3 {
            let item = items[index]
            item.choice = .liked
        }
        
        //Unlike next 4 products
        for index in 4...7 {
            let item = items[index]
            item.choice = .unliked
        }
        
        //Assert All assumptions
        XCTAssert(viewModel.totalLikedItems == 4)
        XCTAssert(viewModel.isAllItemsReviewed == false)
        expectation.fulfill()
        viewModel.delegate = nil
    }
    
    func viewModelUpdateFailed(error: HPError) {
        //Progress
        XCTFail(error.localizedMessage)
    }
}
