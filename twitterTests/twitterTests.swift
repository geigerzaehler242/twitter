//
//  twitterTests.swift
//  twitterTests
//
//  Created by fernando marto on 2019-02-28.
//  Copyright © 2019 f. All rights reserved.
//

import XCTest
@testable import twitter

//var theMovies: Movies!

class twitterTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
//        theMovies = Movies()
    
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
 //       theMovies = nil
    }

    func testAPI() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    
        let promise = expectation(description: "model update failed")
        
        let currentMovie = "harry%20potter" //has 20 movies and 2 pages!
        let currentPage = 1
        
        TwitterAPI().getMovieAsync(theMovie: currentMovie, thePage: currentPage) { (response) in
            
            switch response {
                
            case .success(let movieDictionary):
            
                if let thePageCount = movieDictionary.totalPages as? Int,
                    let theMoviesModel = movieDictionary.all as? [Movie] {
                    
                    if theMoviesModel.count == 20  && thePageCount ==  2 {
                        promise.fulfill()
                    }
                    else {
                        XCTFail("model load failed")
                    }
                }
                
            case .error(let error):
                
                XCTFail("Error: \(error.localizedDescription)")
                return
            } //switch
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
