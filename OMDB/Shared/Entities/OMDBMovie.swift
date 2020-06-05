//
//  AppDelegate.swift
//  OMDB
//
//  Created by Sachindra on 04/06/20.
//  Copyright © 2020 Sachindra Pandey. All rights reserved.
//

import Foundation

protocol OMDBMovieProtocol: Equatable {
    var id: String { get set }
    var title: String { get set }
    var releaseDate: String { get set }
    var overview: String? { get set }
    var posterPath: String { get set }
    var director: String? { get set }
    var writer: String? { get set }
    var actors: String? { get set }
}

class OMDBMovie: OMDBMovieProtocol, Codable {
    var id: String
    var title: String
    var releaseDate: String
    var posterPath: String
    var overview: String?
    var director: String?
    var writer: String?
    var actors: String?

    init(id: String, title: String, releaseDate: String, posterPath: String) {
        self.id = id
        self.title = title
        self.releaseDate = releaseDate
        self.posterPath = posterPath
    }
    
    private enum CodingKeys: String, CodingKey {
        case id = "imdbID"
        case title = "Title"
        case releaseDate = "Year"
        case overview = "Plot"
        case posterPath = "Poster"
        case director = "Director"
        case writer = "Writer"
        case actors = "Actors"

    }
    
    init?(dictionary: [String : AnyObject]) {
        guard let ids = dictionary["imdbID"] as? String,
        let title = dictionary["Title"] as? String,
        let releaseDate = dictionary["Year"] as? String,
        let posterPath = dictionary["Poster"] as? String else {
            return nil
        }
        self.id = ids
        self.title = title
        self.releaseDate = releaseDate
        self.posterPath = posterPath

        if let overview = dictionary["Plot"] as? String {
            self.overview = overview
        }
        if let director = dictionary["Director"] as? String {
            self.director = director
        }
        if let writer = dictionary["Writer"] as? String {
            self.writer = writer
        }
        if let actors = dictionary["Actors"] as? String {
            self.actors = actors
        }
    }

    static func == (lhs: OMDBMovie, rhs: OMDBMovie) -> Bool {
        return lhs.id == rhs.id
    }
    
}

