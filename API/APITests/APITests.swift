//
//  APITests.swift
//  APITests
//
//  Created by Николай Булдаков on 26.05.2021.
//

import XCTest
@testable import API
import CommonModels

class APITests: XCTestCase {

    var apiService: ApiService!

    override func setUpWithError() throws {
        apiService = KiwiApiService()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let expectation = XCTestExpectation(description: "Download flights")

        apiService.findFlights(for: Location(latitude: 55.8, longitude: 49)) { result in
            guard case let .success(flights) = result else {
                XCTFail("findFlights callback was called with a failure")

                expectation.fulfill()
                return
            }

            XCTAssertGreaterThan(flights.count, 0)
            expectation.fulfill()
        }
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

        wait(for: [expectation], timeout: 10.0)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
