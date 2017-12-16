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
    
    private var imageTable = [String : Image]()
    private var imageList = [Image]()
    private let capacity: Int
    
    init(capacity: Int) {
        self.capacity = capacity
        print("Cache initialized")
    }
    
    func fetchImage(fromURL: String, completion: @escaping (_ image: Image?) -> ()) {
        
        if let image = imageTable[fromURL] {
            moveToFront(image)
            print("Cache hit for \(fromURL)")
            completion(image)
            return
        }
        
        downloadImage(fromURL: fromURL, completion: completion)
    }
    
    private func moveToFront(_ image: Image) {
        if let index = imageList.index(of: image) {
            imageList.remove(at: index)
            imageList.insert(image, at: 0)
        }
    }
    
    private func add(url: String, image: Image) {
        imageList.insert(image, at: 0)
        imageTable[url] = image
        
        trimExcessEntries()
    }
    
    private func trimExcessEntries() {
        while imageList.count > capacity {
            if let lastImage = imageList.last,
                let index = imageList.index(of: lastImage) {
                imageList.remove(at: index)
                
                var lastImageKey: String? = nil
                for key in imageTable.keys {
                    if imageTable[key] == lastImage {
                        lastImageKey = key
                        break
                    }
                }
                
                if let lastImageKey = lastImageKey {
                    imageTable.removeValue(forKey: lastImageKey)
                }
            }
        }
    }
    
    func clearAll() {
        imageTable.removeAll()
        imageList.removeAll()
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
                self.add(url: fromURL, image: image)
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
