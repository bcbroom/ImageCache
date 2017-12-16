//
//  ImageCache.swift
//  ImageCachePlaying
//
//  Created by Brian Broom on 12/16/17.
//  Copyright © 2017 Brian Broom. All rights reserved.
//

#if os(OSX)
    import Cocoa
    typealias Image = NSImage
#elseif os(iOS)
    import UIKit
    typealias Image = UIImage
#endif

class ImageCache {
    
    private let cache = NSCache<NSString, Image>()
    private var maxCount = 5
    
    init() {
        print("Cache initialized")
    }
    
    func fetchImage(fromURL: String, completion: @escaping (_ image: Image?) -> ()) {
        
        if let image = cache.object(forKey: fromURL as NSString) {
            print("Cache hit for \(fromURL)")
            completion(image)
            return
        }
        
        downloadImage(fromURL: fromURL, completion: completion)
    }
    
    func clearAll() {
        cache.removeAllObjects()
    }
    
    private func downloadImage(fromURL: String, completion: @escaping (_ image: Image?) -> ()) {
        guard let url = URL(string: fromURL) else {
            print("\(fromURL) is not a valid URL")
            DispatchQueue.main.async {
                completion(nil)
            }
            return
        }
        
        print("Downloading image from \(fromURL)")
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let data = data,
                let image = Image(data: data) {
                self.cache.setObject(image, forKey: fromURL as NSString)
                DispatchQueue.main.async {
                    completion(image)
                }
                return
            }
            
            print("Could not download image from \(fromURL)")
            DispatchQueue.main.async {
                completion(nil)
            }
        }
        task.resume()
    }
    
}
