//
//  ImageCaching.swift
//  Acmeflix
//
//  Created by Manish Katoch on 07/08/19.
//  Copyright © 2019 Manish Katoch. All rights reserved.
//

import Foundation
import UIKit

class PosterCache {
    
    private var cache: Dictionary<String, Poster>
    static let shared = PosterCache()
    
    private init(){
        cache = Dictionary<String, Poster>()
    }
    
    func addToCache(forKey key: String, poster: Poster) {
        cache[key] = poster
    }
    
    func get(forKey key: String) -> Poster {
        return cache[key] ?? Poster.unavailablePoster()
    }
}
