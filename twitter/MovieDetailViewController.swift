//
//  MovieDetailViewController.swift
//  twitter
//
//  Created by fernando marto on 2019-03-02.
//  Copyright © 2019 f. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieOverView: UITextView!
    
    
    var theMovieImage = UIImage()
    
    var theMovieOverview = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        movieOverView.text = theMovieOverview
        movieImage.image = theMovieImage
        
        
        UIView.animate(withDuration: 0.0, delay: 0.5, usingSpringWithDamping: 0.25, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            let scale = CGAffineTransform(scaleX: 0.25, y: 0.25)
            //let rotate = CGAffineTransform(rotationAngle: 360)
            self.movieImage.transform = scale //rotate.concatenating(scale)
        }, completion: { (finished: Bool) in

            UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.25, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {

                let scale = CGAffineTransform(scaleX: 1, y: 1)
                //let rotate = CGAffineTransform(rotationAngle: 0)
                self.movieImage.transform = scale //rotate.concatenating(scale)

            }, completion: nil)
        })
        
        
        
    }
    
    @IBAction func returnToMovies(_ sender: Any) {
    
    dismiss(animated: true, completion: nil)
    
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
