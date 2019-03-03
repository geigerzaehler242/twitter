//
//  TwitterAPI.swift
//  twitter
//
//  Created by fernando marto on 2019-02-28.
//  Copyright © 2019 f. All rights reserved.
//

import Foundation
import Alamofire

final class TwitterAPI: NSObject {
    
    let ImageBaseURL = "https://image.tmdb.org/t/p/w600_and_h900_bestv2"
    let APIBaseURL = "https://api.themoviedb.org/3/search/movie?api_key=2a61185ef6a27f400fd92820ad9e8537&query="

    func getMovieAsync(theMovie: String, thePage: Int, theModel: Movies , _ completion: @escaping (Result<Movies>) -> Void) {
        
        let movie = APIBaseURL + theMovie + "&page=" + String(thePage)
        
        Alamofire.request(movie).responseJSON { response in
            
            if let json = response.result.value as? [String:Any] {
                
                theModel.theModel = json
                
                DispatchQueue.main.async {
                    completion(.success(theModel))
                }
            }
            else {
                DispatchQueue.main.async {
                    completion(.error(response.result.error!))
                }
            }
        } //alamofire
    }
}

