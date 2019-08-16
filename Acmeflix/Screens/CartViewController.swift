//
//  CartViewController.swift
//  Acmeflix
//
//  Created by Manish Katoch on 09/08/19.
//  Copyright © 2019 Manish Katoch. All rights reserved.
//

import Foundation
import UIKit

@objc protocol TapRecognizer {
    @objc func tap(_ sender:AnyObject)
}

class CartViewController: UIViewController {
    
    var cart: Resource<Cart>?
    var cartLink: Link?
    private let reuseIdentifier = "CartCell"
    
    @IBOutlet weak var cartCollectionView: UICollectionView! {
        didSet {
            self.cartCollectionView.dataSource = self
            self.cartCollectionView.delegate = self
        }
    }
    @IBOutlet weak var cartInfoLabel: InfoLabel!
    
    private let httpClient = RestfulClient.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "CART"
        update()
    }
    
    func update() {
        if let cart = cartLink {
           httpClient.request(cart, cartLoaded, cartLoadFailure)
        }
        
        let count = cart?.item?.count ?? 0
        cartInfoLabel.text = "You have \(count) titles in the cart waiting for you!"
        self.cartCollectionView.reloadData()
    }
    
    private func cartLoaded(_ cartResource: Resource<Cart>?) {
        cart = cartResource
        let count = cart?.item?.count ?? 0
        cartInfoLabel.text = "You have \(count) titles in the cart waiting for you!"
        self.cartCollectionView.reloadData()
    }
    
    private func cartLoadFailure(_ status: HttpResponseCode){
        createOkAlert(title: "Oops!", message: "cart is unavailable. Please try again later.", on: self)
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension CartViewController : TapRecognizer {
    @objc func tap(_ sender:AnyObject){
        let index = sender.view.tag
        if let deleteLink = cart?.item?.items[index].getDeleteLink() {
            httpClient.request(deleteLink, { (cart: Resource<Cart>?) in
                self.cart = cart
                createOkAlert(title: "Done", message: "We have removed the title from your cart.", on: self)
                self.update()
            }) { (status) in
                createOkAlert(title: "Oops", message: "Failed to remove the title from your cart.Please try again later.", on: self)
            }
        }
    }
}

extension CartViewController : UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CartCell

        if let cartResource = self.cart,
            let items = cartResource.item?.items,
            let movieItem = items[indexPath.row].item {
            cell.update(forCartItem: movieItem, on: self, forIndex: indexPath.row)

        }
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cart?.item?.count ?? 0
    }
    
}

extension CartViewController : UICollectionViewDelegateFlowLayout {
    var itemsPerRow: CGFloat {
        get { return 1 }
    }
    
    var sectionInsets: UIEdgeInsets {
        get {
            return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = view.frame.width
        let widthPerItem = (availableWidth / itemsPerRow)
        
        return CGSize(width: widthPerItem, height: 150)
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
}
