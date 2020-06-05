//
//  AppDelegate.swift
//  OMDB
//
//  Created by Sachindra on 04/06/20.
//  Copyright © 2020 Sachindra Pandey. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MovieDetailsViewCell"

class MovieDetailsViewController: UITableViewController {
    var dataManager: MovieDetailsDataManager!
    @IBOutlet var moviePoster: UIImageView!
    @IBOutlet var moviePosterBackground: UIImageView!
    @IBOutlet var movieTitle: UILabel!
    @IBOutlet var releaseDate: UILabel!
    @IBOutlet var synopsis: UILabel!
    @IBOutlet var director: UITableViewCell!
    @IBOutlet var writer: UITableViewCell!
    @IBOutlet var actor: UITableViewCell!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
        reloadMovieInformation()
        dataManager.fetchData()
    }
}

extension MovieDetailsViewController: MovieDetailsDataManagerProtocol {
    func showErrorOnUI(error: Error?) {
        let alert = UIAlertController(title: "OMDB", message: error?.localizedDescription ?? "Something went wrong", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default , handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func reloadMovieInformation() {
        DispatchQueue.main.async {
            self.movieTitle.text = self.dataManager.currentMovie.title
            self.releaseDate.text = self.dataManager.currentMovie.releaseDate
            self.synopsis.text = self.dataManager.currentMovie.overview
            self.director.detailTextLabel?.text = self.dataManager.currentMovie.director
            self.writer.detailTextLabel?.text = self.dataManager.currentMovie.writer
            self.actor.detailTextLabel?.text = self.dataManager.currentMovie.actors
            self.tableView.reloadData()

            if let backdropImageURL = URL(string: self.dataManager.currentMovie.posterPath),
                let imagecell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) {
                let movieImageSize = imagecell.bounds.size
                let scale = self.tableView.traitCollection.displayScale
                self.downloadImage(atURL: backdropImageURL, forSize: movieImageSize, scale: scale) { (image) in
                    if let image = image {
                        DispatchQueue.main.async {
                            self.moviePoster.image = image
                            self.moviePosterBackground.image = image
                            
                            let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
                            let blurEffectView = UIVisualEffectView(effect: blurEffect)
                            blurEffectView.frame = self.moviePosterBackground.bounds
                            self.moviePosterBackground.addSubview(blurEffectView)

                        }
                    }
                }
            }
        }
    }
}
