//
//  CollectionViewCells.swift
//  Acmeflix
//
//  Created by Manish Katoch on 10/08/19.
//  Copyright © 2019 Manish Katoch. All rights reserved.
//

import Foundation
import UIKit

class MovieCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
}

class CartCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieName: InfoLabel!
    @IBOutlet weak var movieYear: InfoLabel!
    @IBOutlet weak var trash: UIImageView!
    
    func update(forCartItem movieItem: CartItem, on: TapRecognizer, forIndex: Int) {
        let poster = PosterCache.shared.get(forKey: movieItem.id)
        self.posterImageView.image = poster.image
        self.movieName.text = movieItem.name
        self.movieYear.text = "(\(movieItem.year))"
        self.trash.isUserInteractionEnabled = true
        self.trash.tag = forIndex
        self.trash.addGestureRecognizer(UITapGestureRecognizer(target: on, action: #selector(on.tap(_:))))
    }
}
