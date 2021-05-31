//
//  SuggestionsTests.swift
//  SuggestionsTests
//
//  Created by Николай Булдаков on 25.05.2021.
//

import XCTest
@testable import Suggestions

import API
import Storage
import CommonModels

class SuggestionsTests: XCTestCase {

    var suggestionService: SuggestionsService!
    var storage = Storage.createService(of: .runtime)
    var dateProvider = ChangeableDateProvider()

    class ChangeableDateProvider: DateProvider {
        var date: Date = Date()
    }

    override func setUpWithError() throws {
        suggestionService = DailySuggestionsService(
            storage: storage,
            dateProvider: dateProvider,
            api: API.createService(of: .mock),
            maxNumberOfSuggestions: 5
        )
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let expectation = XCTestExpectation(description: "get flight suggestions")
        suggestionService.getFlightSuggestions { flights in
            let storedSuggestion: DatedFlightSuggestion? = self.storage.getValue(
                for: DailySuggestionsService.flightSuggestionStorageKey
            )

            XCTAssertEqual(storedSuggestion?.suggestedFlights.map { $0.id } ?? [], [0, 1, 2, 3, 4].map { "\($0)" })
        }

        suggestionService.getFlightSuggestions { flights in
            let storedSuggestion: DatedFlightSuggestion? = self.storage.getValue(
                for: DailySuggestionsService.flightSuggestionStorageKey
            )

            XCTAssertEqual(storedSuggestion?.suggestedFlights.map { $0.id } ?? [], [0, 1, 2, 3, 4].map { "\($0)" })
        }

        dateProvider.date = Calendar.current.date(byAdding: DateComponents(day: 1), to: dateProvider.date)!

        suggestionService.getFlightSuggestions { flights in
            let storedSuggestion: DatedFlightSuggestion? = self.storage.getValue(
                for: DailySuggestionsService.flightSuggestionStorageKey
            )

            XCTAssertEqual(storedSuggestion?.suggestedFlights.map { $0.id } ?? [], [5, 6, 7, 8, 9].map { "\($0)" })
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
