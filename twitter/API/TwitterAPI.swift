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


    func getMovieAsync(theMovie: String, thePage: Int, _ completion: @escaping (Result<Films>) -> Void) {

        let movieURL = APIBaseURL + theMovie + "&page=" + String(thePage)

        AF.request(movieURL).validate().responseDecodable(of: Films.self) { (response) in

            guard let films = response.value else {
                
                DispatchQueue.main.async {
                    completion(.error(response.error!))
                }
                return
            }
            
            DispatchQueue.main.async {
                
                completion(.success(films))
            }

        } //alamofire
    }
    
    
}

