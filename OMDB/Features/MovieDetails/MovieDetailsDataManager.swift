//
//  AppDelegate.swift
//  OMDB
//
//  Created by Sachindra on 04/06/20.
//  Copyright © 2020 Sachindra Pandey. All rights reserved.
//

import Foundation
protocol MovieDetailsDataManagerProtocol {
    func showErrorOnUI(error: Error?)
    func reloadMovieInformation()
}

class MovieDetailsDataManager {
    private var service = OMDBService()
    private var delegate: MovieDetailsDataManagerProtocol!
    var currentMovie: OMDBMovie! {
        didSet {
            delegate.reloadMovieInformation()
        }
    }
    
    required init(movie: OMDBMovie, delegate: MovieDetailsDataManagerProtocol) {
        self.delegate = delegate
        self.currentMovie = movie
    }
        
    func updateCurrentMovie(movie: OMDBMovie) {
        self.currentMovie = movie
        fetchData()
    }
    
    func fetchData() {
        service.getMovieDetails(movieId: currentMovie.id) {[weak self] (movie, error) in
            guard let movie = movie else {
                self?.delegate.showErrorOnUI(error: error)
                return
            }
            self?.currentMovie = movie
        }
    }
}
