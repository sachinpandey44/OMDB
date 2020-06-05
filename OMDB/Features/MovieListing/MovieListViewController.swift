//
//  AppDelegate.swift
//  OMDB
//
//  Created by Sachindra on 04/06/20.
//  Copyright © 2020 Sachindra Pandey. All rights reserved.
//


import Foundation
import UIKit
import CoreGraphics

class MovieListViewController: BaseCollectionViewController {
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    private let movieListCellIdentifier = "MovieListViewCell"
    private var dataManager: MovieListDataManager!
    private var searchText: String = "Marvel"
        
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        dataManager = MovieListDataManager(delegate: self)
        activityIndicator.startAnimating()
        dataManager.fetchData(self.searchText)
    }
    
//MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailsController = segue.destination as? MovieDetailsViewController,
            let selectedIndex = self.collectionView.indexPathsForSelectedItems?.first else {
            return
        }
        detailsController.dataManager = MovieDetailsDataManager(movie: dataManager.getMoviesSearchResults[selectedIndex.row], delegate: detailsController)
    }
    
    func showAlertWithMessage(message: String = "Something went wrong.") {
        let alert = UIAlertController(title: "OMDB", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default , handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: - UICollectionViewDatasource
extension MovieListViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataManager.getMoviesSearchResults.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: movieListCellIdentifier, for: indexPath) as! MovieListViewCell
        cell.accessibilityIdentifier = "\(dataManager.getMoviesSearchResults[indexPath.row].id)"
        let currentMovie = dataManager.getMoviesSearchResults[indexPath.row]
        cell.movieTitle.text = currentMovie.title
        cell.imageView.image = nil
        if let backdropImageURL = URL(string: dataManager.getMoviesSearchResults[indexPath.row].posterPath) {
            let movieImageSize = cell.imageView.bounds.size
            let scale = collectionView.traitCollection.displayScale
            self.downloadImage(atURL: backdropImageURL, forSize: movieImageSize, scale: scale) { (image) in
                if let image = image {
                    DispatchQueue.main.async {
                        cell.imageView.image = image
                    }
                }
            }
        }
        return cell
    }
}

extension MovieListViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let backdropImageURL = URL(string: dataManager.getMoviesSearchResults[indexPath.row].posterPath) {
                let scale = collectionView.traitCollection.displayScale
                self.downloadImage(atURL: backdropImageURL, forSize: collectionViewItemSize, scale: scale) { (image) in
                    return
                }
            }
        }
    }
}

//MARK: - UISearchBarDelegate
extension MovieListViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.activityIndicator.isHidden = false
        self.activityIndicator.frame = self.view.frame
        self.activityIndicator.startAnimating()

        if let searchText = searchBar.text {
            self.searchText = searchText
            dataManager.resetPageCount()
            dataManager.fetchData(self.searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    print("searchBarCancelButtonClicked:\(searchBar)")
        searchBar.text = nil
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
    }
}


//MARK: - UICollectionViewDelegate
extension MovieListViewController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(MovieListHeaderView.self)", for: indexPath) as? MovieListHeaderView else {
                fatalError("Invalid view type")
            }

            return headerView
        }
        assert(false, "Invalid header element type")
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == dataManager.getMoviesSearchResults.count - 1 ) { //it's your last cell
           //Load more data & reload your collection view
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
            }
            dataManager.fetchData(self.searchText)
         }
    }
}

extension MovieListViewController: MovieListDataManagerProtocol {
    func showErrorOnUI(error: Error?) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.showAlertWithMessage(message: "Unable to fetch list of movies")
        }
    }
    
    func reloadUI() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.collectionView.reloadData()
        }
    }
    
}
