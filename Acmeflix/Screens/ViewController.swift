//
//  ViewController.swift
//  Acmeflix
//
//  Created by Manish Katoch on 02/08/19.
//  Copyright © 2019 Manish Katoch. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController {
  
    private let reuseIdentifier = "MovieCell"
    private let httpClient = RestfulClient.shared
    
    private var movies: [Resource<Movie>] = []
    private var selectedMovie: Resource<Movie>?
    private var root: Resource<Root>?
    
    @IBOutlet weak var libraryCollectionView: UICollectionView! {
        didSet {
            self.libraryCollectionView.dataSource = self
            self.libraryCollectionView.delegate = self
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "ACMEFLIX" 
        
        let rootLink = Link(withUrl: "http://localhost:3000/")
        loadResource(rootLink, onSuccess: rootIsLoaded )
    }
    
    private func loadResource<T>(_ link: Link, onSuccess: @escaping onResourceDownloadSuccess<T>){
        httpClient.request(link, onSuccess, onResourceLoadFailure)
    }
    
    private func rootIsLoaded(_ resource: Resource<Root>?) {
        root = resource
        root?.library(onAvailable: { (link) in
            self.loadResource(link, onSuccess: self.libraryIsLoaded)
        }, onUnavailable: {
            self.onResourceLoadFailure(.EMPTY_RESOURCE)
        })
        
        root?.cart(onAvailable: { (link) in
            self.navigationItem.rightBarButtonItem =  UIBarButtonItem.init(title: "CART", style: .done, target: self, action: #selector(self.cartTapped(_:)))
        }, onUnavailable: {
            self.navigationItem.rightBarButtonItem = nil
        })
    }
    
    @objc private func cartTapped(_ sender: Any) {
        performSegue(withIdentifier: "showCart", sender: self)
    }
    
    private func libraryIsLoaded(_ resource: Resource<Library>?) {
        
        self.movies = resource?.getMovies() ?? []
        
        let syncDispatch = DispatchGroup()
        
        movies.forEach({ (movie) in
            if let poster = movie.getPosterLink(), let movieItem = movie.item {
                syncDispatch.enter()
                httpClient.requestRaw(poster) {(data, status) in
                    PosterCache.shared.addToCache(forKey: movieItem.id, poster: Poster(fromData: data))
                    syncDispatch.leave()
                }
            }
        })
        syncDispatch.notify(queue: .main) {
            self.libraryCollectionView.reloadData()
        }
        
    }

    private func onResourceLoadFailure(_ status: HttpResponseCode) {
        self.performSegue(withIdentifier: "onFailLoad", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "onMovieSelect" {
            if let vc = segue.destination as? MovieViewController, let movie = selectedMovie {
                vc.movie = movie
            }
        }
        else if segue.identifier == "showCart" {
            if let vc = segue.destination as? CartViewController, let cartLink = root?.getCartLink() {
                vc.cartLink = cartLink
            }
        }
    }
}


extension ViewController : UICollectionViewDataSource {

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MovieCell
        if let posterLink = self.movies[indexPath.row].item?.id {
            cell.posterImageView.image = PosterCache.shared.get(forKey: posterLink).image
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies.count
    }
    
}

extension ViewController : UICollectionViewDelegateFlowLayout {
    var itemsPerRow: CGFloat {
        get { return 3 }
    }
    
    var sectionInsets: UIEdgeInsets {
        get {
            return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = view.frame.width
        let widthPerItem = (availableWidth / itemsPerRow)
        
        return CGSize(width: widthPerItem, height: widthPerItem * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       let movieCellClicked = self.movies[indexPath.row]
        if let detailLink = movieCellClicked.detailLink() {
            loadResource(detailLink) { (movie: Resource<Movie>?) in
                self.selectedMovie = movie
                self.performSegue(withIdentifier: "onMovieSelect", sender: self)
            }
        }
    }
}

