//
//  twitterViewController.swift
//  twitterTests
//
//  Created by fernando marto on 2019-03-03.
//  Copyright © 2019 f. All rights reserved.
//

import XCTest
@testable import twitter

//var theTestMovies: TestMovies!

class twitterViewController: XCTestCase {

    var tableVC: ViewController!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        
        theMovies = Movies()
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        tableVC = storyboard.instantiateViewController(withIdentifier: "MovieViewController") as? ViewController
        
        _ = tableVC.view // Trigger view load and viewDidLoad()
        
        tableVC.currentMovie = "harry%20potter"
        tableVC.currentPage = 1
        tableVC.theTotalPages = 1
        
//        tableVC.getMovies() //default movie
        
        //get mock json file
        let bundle = Bundle(for: twitterViewController.self)
        let path = bundle.path(forResource: "MockMoviesJson", ofType: "txt")!
        let Mockresponse = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
        
        guard let data = Mockresponse.data(using: String.Encoding.utf8, allowLossyConversion: false) else {
            XCTFail("could not load mock json file")
            return
        }
        
        do {
            let mockJson = try JSONDecoder().decode(TestMovies.self, from: data)
            
            theMovies.theMovies = mockJson.results
            
        } catch {
           XCTFail("could not load mock json file")
        }
        
        tableVC.theMovies = theMovies //force mock data into model
        
        tableVC.moviesTableView.reloadData()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        tableVC = nil
    }
    
    func testTableViewFirstRow() {
        let tableView = tableVC?.moviesTableView
        let indexPath0 = IndexPath(item: 0, section: 0)
        
        XCTAssert(tableView?.numberOfRows(inSection: 0) == 2, "number of cells in tableview is wrong")
        
        if let cell0 = tableView?.cellForRow(at: indexPath0) as? MovieTableViewCell {
            XCTAssert(cell0.movieTitle.text == "Harry Potter")
        }
        else {
            XCTFail("could not match cell title")
        }
        
        let visibleRows = tableView?.indexPathsForVisibleRows
        XCTAssert(visibleRows != nil)
        XCTAssert((tableView?.indexPathsForVisibleRows?.contains(indexPath0))!)
        
        
    }
    

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
