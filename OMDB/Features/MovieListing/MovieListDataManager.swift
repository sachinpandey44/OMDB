//
//  AppDelegate.swift
//  OMDB
//
//  Created by Sachindra on 04/06/20.
//  Copyright © 2020 Sachindra Pandey. All rights reserved.
//

import UIKit
import Foundation

protocol MovieListDataManagerProtocol {
    func showErrorOnUI(error: Error?)
    func reloadUI()
}

class MovieListDataManager {
    private var page = 1
    private var service = OMDBService()
    private var delegate: MovieListDataManagerProtocol!
    var getMoviesSearchResults: [OMDBMovie] = [] {
        didSet {
            delegate.reloadUI()
        }
    }
    
    required init(delegate: MovieListDataManagerProtocol) {
        self.delegate = delegate
    }
    
    func resetPageCount() {
        page = 1
        getMoviesSearchResults.removeAll()
    }
    
    func fetchData(_ search: String) {
        //service.currentTask?.cancel()
        DispatchQueue.global().async {
            self.service.getMoviesForSearchText(search, page: self.page) {[weak self] (movies, error) in
                guard let movies = movies else {
                    self?.delegate.showErrorOnUI(error: error)
                    return
                }
                self?.page += 1
                self?.getMoviesSearchResults.append(contentsOf: movies)
            }
        }
    }
}


