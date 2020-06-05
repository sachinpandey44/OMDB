//
//  AppDelegate.swift
//  OMDB
//
//  Created by Sachindra on 04/06/20.
//  Copyright © 2020 Sachindra Pandey. All rights reserved.
//

import Foundation

enum OMDBServicesError: Swift.Error {
    case invalidURL
    case invalidAPIResponse
    case genericAPIFailure
}

class OMDBConstants: NSObject {
    static let baseURL = "http://www.omdbapi.com"
    
    enum ImageSize: String {
        case small = "w200"
        case medium = "w500"
        case original = "original"
    }
}
