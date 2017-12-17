//
//  ViewController.swift
//  ImageCachePlaying
//
//  Created by Brian Broom on 12/15/17.
//  Copyright © 2017 Brian Broom. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    var imageIndex = 1
    let cache = ImageCache(capacity: 3)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadImage()
    }
    
    func loadImage() {
        let urlString = "https://lorempixel.com/460/460/abstract/\(imageIndex)/"
        cache.fetchImage(fromURL: urlString) { image in
            if let image = image {
                self.imageView.image = image
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        cache.clearAll()
    }

    @IBAction func nextImageButtonTapped(_ sender: Any) {
        imageIndex += 1
        if imageIndex > 4 {
            imageIndex = 1
        }
        loadImage()
    }
    
    @IBAction func prevImageButtonTapped(_ sender: Any) {
        imageIndex -= 1
        if imageIndex < 1 {
            imageIndex = 4
        }
        loadImage()
    }
    
    @IBAction func clearCacheButtonTapped(_ sender: Any) {
        cache.clearAll()
    }
    
}

