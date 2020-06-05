//
//  AppDelegate.swift
//  OMDB
//
//  Created by Sachindra on 04/06/20.
//  Copyright © 2020 Sachindra Pandey. All rights reserved.
//

import Foundation

protocol OMDBServiceProtocol {
    var currentTask: URLSessionDataTask? {get set}
    func getMoviesForSearchText(_ search: String, page: Int, completion: @escaping(_ response: [OMDBMovie]?, _ error: Error?) -> Void)
    func getMovieDetails(movieId: String, completion: @escaping(_ response: OMDBMovie?, _ error: Error?) -> Void)
}

class OMDBService: OMDBServiceProtocol {
    var currentTask: URLSessionDataTask? = nil
    let apiKey = "b9bd48a6"
    
    func getMoviesForSearchText(_ search: String, page: Int = 1, completion: @escaping ([OMDBMovie]?, Error?) -> Void) {
        let urlString = "\(OMDBConstants.baseURL)/?apikey=\(apiKey)&s=\(search)&type=movie&page=\(page)"
        guard let url = URL(string: urlString) else {
            completion(nil, OMDBServicesError.invalidURL)
            return
        }
        getMovies(url: url) { (movies, error) in
            completion(movies, error)
        }
    }
    
    func getMovieDetails(movieId: String, completion: @escaping (OMDBMovie?, Error?) -> Void) {
        //http://www.omdbapi.com/?apikey=b9bd48a6&i=tt4154664
        
        let urlString = "\(OMDBConstants.baseURL)/?apikey=\(apiKey)&i=\(movieId)"
        guard let url = URL(string: urlString) else {
            completion(nil, OMDBServicesError.invalidURL)
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let _ = response as? HTTPURLResponse, let data = data else {
                completion(nil, OMDBServicesError.invalidAPIResponse)
                return
            }
            do {
                guard let resultsDictionary = try JSONSerialization.jsonObject(with: data) as? [String: AnyObject],
                    let response = resultsDictionary["Response"] as? String, response == "True" else {
                    completion(nil, OMDBServicesError.invalidAPIResponse)
                    return
                }
                if let movie = OMDBMovie(dictionary: resultsDictionary) {
                    completion(movie, nil)
                    return
                }
                completion(nil, OMDBServicesError.invalidAPIResponse)
            } catch {
                completion(nil, error)
                return
            }
        }.resume()
    }
    
    fileprivate func getMovies(url: URL, completion: @escaping ([OMDBMovie]?, Error?) -> Void) {
        let dataTask =
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let _ = response as? HTTPURLResponse, let data = data else {
                completion(nil, OMDBServicesError.invalidAPIResponse)
                return
            }
            
            do {
                guard let resultsDictionary = try JSONSerialization.jsonObject(with: data) as? [String: AnyObject],
                    let response = resultsDictionary["Response"] as? String, response == "True",
                    let movies = resultsDictionary["Search"] as? [[String: AnyObject]] else {
                    completion(nil, OMDBServicesError.invalidAPIResponse)
                    return
                }
                let movieObjects: [OMDBMovie] = movies.compactMap { movie in
                    if let movie = OMDBMovie(dictionary: movie) {
                        return movie
                    }
                    return nil
                }
                print(movieObjects)
                completion(movieObjects, nil)
                
            } catch {
                completion(nil, error)
                return
            }
        }
        self.currentTask = dataTask
        dataTask.resume()
    }
}
