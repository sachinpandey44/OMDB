//
//  AppDelegate.swift
//  OMDB
//
//  Created by Sachindra on 04/06/20.
//  Copyright © 2020 Sachindra Pandey. All rights reserved.
//
import UIKit
import CoreImage

extension UIViewController {
    func downloadImage(atURL imageURL: URL, forSize pointSize: CGSize, scale: CGFloat, completion : @escaping (UIImage?) -> Void){
        DispatchQueue.global(qos: .userInteractive).async {
            let imageSourceOptions = [kCGImageSourceShouldCache: true] as CFDictionary
            guard let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, imageSourceOptions) else {
                completion(nil)
                return
            }
            
            let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
            let downloadSampledOptions = [kCGImageSourceCreateThumbnailFromImageAlways: true,
                                          kCGImageSourceShouldCacheImmediately: true,
                                          kCGImageSourceCreateThumbnailWithTransform: true,
                                          kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels] as CFDictionary
            guard let downloadedSampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downloadSampledOptions) else {
                completion(nil)
                return
            }
            completion(UIImage(cgImage: downloadedSampledImage))
        }
    }
}
