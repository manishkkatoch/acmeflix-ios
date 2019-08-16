//
//  Root.swift
//  Acmeflix
//
//  Created by Manish Katoch on 08/08/19.
//  Copyright © 2019 Manish Katoch. All rights reserved.
//

import Foundation

class Root: Decodable {}

extension Resource where T:Root {
    func hasLibrary() -> Bool {
        return self.hasCapability(for: "library")
    }
    func getLibraryLink() -> Link? {
        return self.getRelation(forRel: "library")
    }
    func getCartLink() -> Link? {
        return self.getRelation(forRel: "cart")
    }
    
    func library(onAvailable: LinkAvailableHandler? = nil, onUnavailable: LinkUnAvailableHandler? = nil){
        capabilityMap(forRel: "library", onAvailable, onUnavailable)
    }
    
    func cart(onAvailable: LinkAvailableHandler? = nil, onUnavailable: LinkUnAvailableHandler? = nil){
        capabilityMap(forRel: "cart", onAvailable, onUnavailable)
    }
}
