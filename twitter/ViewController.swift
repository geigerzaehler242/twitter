//
//  ViewController.swift
//  twitter
//
//  Created by fernando marto on 2019-02-28.
//  Copyright © 2019 f. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ViewController: UIViewController {

    @IBOutlet weak var moviesTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    
    //to be used if hiding search bar in future
    private let maxHeaderHeight: CGFloat = 80;
    private let minHeaderHeight: CGFloat = 40;
    private var previousScrollOffset: CGFloat = 0;
    
    var movies: [Movie] = [] //create instance of the model
    
    var theTotalPages = 1
    var currentPage = 1
    var currentMovie = "harry%20potter"
    private var newPageState = PageState.InitialLoad
    
    enum PageState {
        
        case InitialLoad
        case FromPaginate
        case FromSearch
        case NeutralState
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //add pull to refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(getMovies), for: UIControl.Event.valueChanged)
        refreshControl.backgroundColor = UIColor(red:0.004, green:0.5, blue: 1.0, alpha: 0.75 )
        refreshControl.tintColor = UIColor.white
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing Movie Data", attributes: attributes)
        moviesTableView.refreshControl = refreshControl
        
        searchTextField.delegate = self
        
        searchTextField.keyboardType = UIKeyboardType.default
        
 //       getMovies(theMovieSearchString: "star%20wars", page: 1) //default movie
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        headerViewHeightConstraint.constant = self.maxHeaderHeight
    }
    
    @IBAction func jumpToTop(_ sender: Any) {
        scrollToFirstRow()
    }
    
    func scrollToFirstRow() {
        
        if moviesTableView.numberOfRows(inSection: 0) > 0 {
        
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: 0, section: 0)
                self.moviesTableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
    }
    
    @objc func getMovies() {
        
        activitySpinner.startAnimating()
        
        TwitterAPI().getMovieAsync(theMovie: currentMovie, thePage: currentPage) { [unowned self] (result) in
            
            switch result {

            case .success(let films):

                    self.theTotalPages = films.totalPages

                    if films.all.count > 0 {

                        if self.newPageState == PageState.FromPaginate { //adding new pages to existing movie

                            //scroll on to next page in tableview by adding new pages
                            self.movies.append(contentsOf: films.all)
                            
                        }
                        else if self.newPageState == PageState.FromSearch { //user intiated a search

                            self.movies.removeAll(keepingCapacity: false)
                            self.currentPage = 1

                            self.movies = films.all
                        }
                        else if self.newPageState == PageState.InitialLoad { //first time loaded

                            self.currentPage = 1
                            self.movies = films.all
                        }

                        DispatchQueue.main.async {
                            self.moviesTableView.reloadData()
                        }
                    }
                    else {
                        self.showNoMovieFoundAlert()
                    }
                
                
            case .error(let error):
                print(error.localizedDescription)
            } //switch
            
            DispatchQueue.main.async {
                self.moviesTableView.refreshControl?.endRefreshing()
                self.activitySpinner.stopAnimating()
            }
            self.newPageState = PageState.NeutralState
            
        }//twitter api
    }
    
    
    func showNoMovieFoundAlert() {
    
        // Create message
        let alertController = UIAlertController(title: "Error",
        message: "Cannot find any movies with that title",
        preferredStyle: .alert)
        
        // Ok Action
        let clearAction = UIAlertAction(title: "OK",
        style: .destructive,
        handler: { (action:UIAlertAction!) in
            print ("clear")
        })
        alertController.addAction(clearAction)
        
        // Present Alert
        self.present(alertController,
        animated: true,
        completion:nil)
    }
    
    
    //MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let theSenderIndexPath = sender as? IndexPath,
            let destinationVC = segue.destination as? MovieDetailViewController,
            let theSelectedCell = moviesTableView.cellForRow(at: theSenderIndexPath) as? MovieTableViewCell {
            
            //set values on new view that will be segue'd to
            if let theSelectedOverview = theSelectedCell.movieOverview.text {
                destinationVC.theMovieOverview = theSelectedOverview
            }
            else {
                destinationVC.theMovieOverview = ""
            }
            
            if let theSelectedImage = theSelectedCell.movieImage.image {
                destinationVC.theMovieImage = theSelectedImage
            }
            else {
                theSelectedCell.movieImage.image = UIImage(named: "whitebird")
            }
        }
    }

}


//Mark: - extensions

//extension to support image loading
extension UIImageView {

    func loadImageFromURL(_ url: URL, resize: Bool, defaultImage: String, desiredSize: CGSize, trim: Bool = false, forceFade: Bool = false)
    {
        
        let theFilter = AspectScaledToFillSizeFilter(size: desiredSize)
        // AspectScaledToFitSizeFilter(size: size) //AspectScaledToFillSizeWithRoundedCornersFilter(size: size, radius: 20.0)
        
        self.af.setImage(
            withURL: url,
            placeholderImage: UIImage( named: defaultImage),
            filter: theFilter,
            imageTransition: .crossDissolve(0.5)
            //  .curlDown(0.33) .curlUp(0.33) .flipFromBottom(0.33) .flipFromLeft(0.33) .flipFromRight(0.33) .flipFromTop(0.33)
        )
        
    }
}

//extension to handle search text field
extension ViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        performSearch(textField: textField)
        
        searchTextField.resignFirstResponder()
        return true
    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        //print("did begin editing")
//    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        performSearch(textField: textField)
    }
    
    func performSearch(textField: UITextField) {
        
        if let theSearchString = textField.text,
            let theSearchStringEncoded = theSearchString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            
            newPageState = PageState.FromSearch
            scrollToFirstRow()
            currentMovie = theSearchStringEncoded
            currentPage = 1
            getMovies()
        }
    }
    
}



//extension to render tableview

extension ViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.movies.count == 0 {
            return 0
        }
        else {
            return self.movies.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for:indexPath) as! MovieTableViewCell
        
                cell.movieTitle.text = self.movies[indexPath.row].originalTitle

                cell.movieOverview.text = self.movies[indexPath.row].overview
        
        if let thePosterPath = self.movies[indexPath.row].posterPath {
            
            let thePosterImageURLString = TwitterAPI().ImageBaseURL + thePosterPath
            
                cell.movieImage.loadImageFromURL(URL(string: thePosterImageURLString)!, resize: false, defaultImage: "whitebird", desiredSize: CGSize(width: 600.0, height: 900.0), trim: false, forceFade: false)
        }
        else {
                cell.movieImage.image = UIImage(named: "whitebird") //default image
        }
        
        //handle pagination to next page of movies if any other pages exist
        if indexPath.row == self.movies.count - 1 && currentPage < theTotalPages {
            
            newPageState = PageState.FromPaginate
            currentPage = currentPage + 1
            getMovies()
        }
        
        return cell
    }
    
}

extension ViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "showMovieDetail", sender: indexPath) //go show the movie details
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
}




