//
//  MovieViewController.swift
//  Acmeflix
//
//  Created by Manish Katoch on 08/08/19.
//  Copyright © 2019 Manish Katoch. All rights reserved.
//

import Foundation
import UIKit

class MovieViewController: AcmeflixViewController {
    
    @IBOutlet weak var contentView: UIVisualEffectView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var directorLabel: InfoLabel!
    @IBOutlet weak var yearLabel: InfoLabel!
    @IBOutlet weak var rentNowButton: AcmeButton!
    @IBOutlet weak var ratingControl: StarControlView!
    @IBOutlet weak var synopsisLabel: UILabel!
    
    private let httpClient = RestfulClient.shared
    private var cart: Resource<Cart>?
    var movie: Resource<Movie>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let movieResource = movie, let movieUnwrapped = movieResource.item {
            print(movieResource)
            title = movieUnwrapped.name.uppercased()
            posterImageView.image = PosterCache.shared.get(forKey: movieUnwrapped.id).image
            synopsisLabel.text = movieUnwrapped.synopsis
            directorLabel.text = movieUnwrapped.director
            yearLabel.text = String(movieUnwrapped.year)
            ratingControl.rating = movieUnwrapped.rating ?? 0
            
            movieResource.rent(onUnavailable: {
                self.rentNowButton.disabled = true
            })
            
            movieResource.rating(onAvailable: { (ratingLink) in
                self.ratingControl.didFinishTouchingCosmos = { value in
                    self.httpClient.request(ratingLink, withBody: ["rating": value], { (resource:Resource<Root>?) in
                            self.alert("Hurray!", message: "your ratings are with us now!")
                        }, { (statusCode) in
                            self.alert("Oops!", message: "unable to record your rating at this moment. Please try again later.")
                        })
                    
                    
                }
            }, onUnavailable: {
                self.ratingControl.didFinishTouchingCosmos = { value in
                    self.alert("Sorry!", message: "This title cannot be rated anymore.")
                    self.ratingControl.rating = movieUnwrapped.rating ?? 0
                }
            })
        } else {
            performSegue(withIdentifier: "onFailLoad", sender: nil)
        }
    }
    @IBAction func rentNowButtonClicked(_ sender: Any) {
        if rentNowButton.disabled {
            alert("Sorry!", message: "This title is unavailable for rent at this moment.")
        } else {
            if let movieUnwrapped = movie,
                let rentLink = movieUnwrapped.getAddToCartLink() {
                httpClient.request(rentLink, { (cart:Resource<Cart>?) in
                    self.cart = cart
                    self.performSegue(withIdentifier: "showCart", sender: nil)
                }) { (statusCode) in
                    self.alert("Oops!", message: "something went wrong adding this title to your cart. try again later")
                }
            }
        }
    }
    
    func showCart() {
        self.performSegue(withIdentifier: "showCart", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCart" {
            if let vc = segue.destination as? CartViewController {
                vc.cart = cart
            }
        }
    }
}

class AcmeflixViewController: UIViewController {
    
    func alert(_ title: String, message: String) {
        let alertView = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alertView.view.backgroundColor = .darkGray
        DispatchQueue.main.async {
            alertView.show(self, sender: nil)
            alertView.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertView, animated: true, completion: nil)
        }
    }
}
