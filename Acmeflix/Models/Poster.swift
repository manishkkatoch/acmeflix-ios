//
//  Poster.swift
//  Acmeflix
//
//  Created by Manish Katoch on 10/08/19.
//  Copyright © 2019 Manish Katoch. All rights reserved.
//

import Foundation
import UIKit

struct Poster {
    
    var image: UIImage?
    
    init(image: UIImage?) {
        self.image = image
    }
    
    init(fromData data: Data) {
        image = UIImage(data: data) ?? Poster.unavailablePoster().image
    }
    
    static func unavailablePoster() -> Poster {
         return Poster(image: UIImage.init(named: "no_poster"))
    }
}
