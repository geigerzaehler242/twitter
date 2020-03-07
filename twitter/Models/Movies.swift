//
//  Movies.swift
//  twitter
//
//  Created by fernando marto on 2019-03-03.
//  Copyright © 2019 f. All rights reserved.
//

import Foundation

    struct Movie: Decodable {
        let popularity: Double
        let id: Int
        let video: Bool
        let voteCount: Int
        let voteAverage: Double
        let title: String
        let releaseDate: String
        let originalLanguage: String
        let originalTitle: String
        let genreIds: [Int]
        let backdropPath: String? //has escape characters
        let adult: Bool
        let overview: String
        let posterPath: String? //has escape characters
    
        enum CodingKeys: String, CodingKey {
            case popularity
            case id
            case video
            case voteCount = "vote_count"
            case voteAverage = "vote_average"
            case title
            case releaseDate = "release_date"
            case originalLanguage = "original_language"
            case originalTitle = "original_title"
            case genreIds = "genre_ids"
            case backdropPath = "backdrop_path"
            case adult
            case overview
            case posterPath = "poster_path"
        }
    }

    struct Films: Decodable {
        let page: Int
        let totalResults: Int
        let totalPages: Int
        let all: [Movie]
        
        enum CodingKeys: String, CodingKey {
            case page
            case totalResults = "total_results"
            case totalPages = "total_pages"
            case all = "results"
        }
    }



//final class Movies: NSObject {
//
//    var theModel : [String:Any] = [:]
//    var theMovies : [ [String:Any] ] = []
//
//}




//mock data model for unit testing
//final class TestMovies: NSObject, Codable {
//
//    var total_pages : Int
//    var results : [ [String:String] ]
//}



