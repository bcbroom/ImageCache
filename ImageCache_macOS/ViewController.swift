//
//  ViewController.swift
//  ImageCacheMac
//
//  Created by Brian Broom on 12/15/17.
//  Copyright © 2017 Brian Broom. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet var imageView: NSImageView!
    var imageIndex = 1
    let cache = ImageCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadImage()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func loadImage() {
        let urlString = "https://lorempixel.com/460/460/abstract/\(imageIndex)/"
        cache.fetchImage(fromURL: urlString) { image in
            if let image = image {
                self.imageView.image = image
            }
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        imageIndex += 1
        if imageIndex > 4 {
            imageIndex = 1
        }
        loadImage()
    }
    
    
    @IBAction func clearCacheButtonPressed(_ sender: Any) {
        cache.clearAll()
    }


}

