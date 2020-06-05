//
//  OMDBServiceTests.swift
//  OMDBTests
//
//  Created by Sachindra on 05/06/20.
//  Copyright © 2020 Sachindra Pandey. All rights reserved.
//

import XCTest
@testable import OMDB

extension XCTestExpectation {
    static let expectationTimeout = 15.0
    
    static func fulfill(with fulfilledDescription: String, from expectations: [XCTestExpectation]) {
        for testExpectation in expectations {
            if testExpectation.expectationDescription == fulfilledDescription {
                testExpectation.fulfill()
            }
        }
    }
}

class OMDBServiceTests: XCTestCase {

    var omdbService: OMDBService!
    var expectations = [XCTestExpectation]()
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        omdbService = OMDBService()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetMoviesForSearchText() {
        print(#function)
        // This is an example of a functional test case.
        self.expectations.append(expectation(description:"testGetMoviesForSearchText()"))
        omdbService.getMoviesForSearchText("Avengers") { (movies, error) in
            if error != nil {
                XCTFail("Fail")
            }
            guard let movies = movies else {
                XCTFail("Fail")
                return
            }
            print(movies)
            for movie in movies {
                print(movie.id)
            }
            XCTestExpectation.fulfill(with: #function, from: self.expectations)
        }
        wait(for: self.expectations, timeout: XCTestExpectation.expectationTimeout)
    }

    func testGetMovieDetails() {
        print(#function)
        // This is an example of a functional test case.
        self.expectations.append(expectation(description:"testGetMovieDetails()"))
        omdbService.getMovieDetails(movieId: "tt4154664", completion: { (movie, error) in
            if error != nil {
                XCTFail("Fail")
            }
            guard let movie = movie else {
                XCTFail("Fail")
                return
            }
            XCTAssertEqual("tt4154664", movie.id)
            XCTestExpectation.fulfill(with: #function, from: self.expectations)
        })
        wait(for: self.expectations, timeout: XCTestExpectation.expectationTimeout)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
