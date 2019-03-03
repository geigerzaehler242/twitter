//
//  Movies.swift
//  twitter
//
//  Created by fernando marto on 2019-03-03.
//  Copyright © 2019 f. All rights reserved.
//

import Foundation

final class Movies: NSObject {
    
    var theModel : [String:Any] = [:]
    var theMovies : [ [String:Any] ] = []
}

//mock data model for unit testing
final class TestMovies: NSObject, Codable {

    var total_pages : Int
    var results : [ [String:String] ]
}
