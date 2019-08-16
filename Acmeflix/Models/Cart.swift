//
//  Cart.swift
//  Acmeflix
//
//  Created by Manish Katoch on 09/08/19.
//  Copyright © 2019 Manish Katoch. All rights reserved.
//

import Foundation

class CartItem: Decodable {
    let name: String
    let year: Int
    let director: String
    let id: String
}

extension Resource where T : CartItem {
    func getDeleteLink() -> Link? {
        return self.getRelation(forRel: "delete")
    }
}


class Cart: Decodable {
    let count: Int?
    let items: Array<Resource<CartItem>>
}
