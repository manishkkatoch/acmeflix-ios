//
//  Movie.swift
//  Acmeflix
//
//  Created by Manish Katoch on 08/08/19.
//  Copyright © 2019 Manish Katoch. All rights reserved.
//

import Foundation

class Movie : Decodable {
    let name: String
    let year: Int
    let director: String
    let id: String
    let synopsis: String?
    let rating: Double?
}


extension Resource where T : Movie {
    func hasPoster() -> Bool {
        return self.hasCapability(for: "poster")
    }
    
    func getPosterLink() -> Link? {
        return self.getRelation(forRel: "poster")
    }
    
    func detailLink() -> Link? {
        return self.getRelation(forRel: "self")
    }
    
    func canBeRented() -> Bool {
        return self.hasCapability(for: "rent")
    }
    
    func canBeRated() -> Bool {
        return self.hasCapability(for: "rate")
    }
    
    func getRatingLink() -> Link? {
        return self.getRelation(forRel: "rate")
    }
    
    func getAddToCartLink() -> Link? {
        return self.getRelation(forRel: "rent")
    }
    
    func rating(onAvailable: LinkAvailableHandler? = nil, onUnavailable: LinkUnAvailableHandler? = nil){
        capabilityMap(forRel: "rate", onAvailable, onUnavailable)
    }
    
    func rent(onAvailable: LinkAvailableHandler? = nil, onUnavailable: LinkUnAvailableHandler? = nil){
        capabilityMap(forRel: "rent", onAvailable, onUnavailable)
    }
    
    func poster(onAvailable: LinkAvailableHandler? = nil, onUnavailable: LinkUnAvailableHandler? = nil){
        capabilityMap(forRel: "poster", onAvailable, onUnavailable)
    }
    
}
