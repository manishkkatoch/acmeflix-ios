//
//  Resource.swift
//  Acmeflix
//
//  Created by Manish Katoch on 04/08/19.
//  Copyright © 2019 Manish Katoch. All rights reserved.
//

import Foundation

typealias LinkAvailableHandler = (Link) -> Void
typealias LinkUnAvailableHandler = () -> Void

protocol RestResource: Decodable {
    associatedtype modelType where modelType : Decodable
    var item: modelType? {get}
    var links: Array<Link> { get }
}

extension RestResource {
    
    func hasCapability(for linkName: String) -> Bool {
        return links.contains { $0.rel == linkName }
    }
    
    func getRelation(forRel linkItem: String) -> Link? {
        return links.filter { $0.rel == linkItem }.first
    }
    
    func capabilityMap(forRel: String,_ onAvailable: LinkAvailableHandler? = nil,_ onUnavailable: LinkUnAvailableHandler? = nil) {
        if let link = self.getRelation(forRel: forRel) {
            onAvailable?(link)
        } else {
            onUnavailable?()
        }
    }
}

struct Resource<T>: RestResource  where T : Decodable {
    typealias modelType = T
    
    let item : T?
    var links: Array<Link> = Array<Link>()
    
    enum CodingKeys: String, CodingKey {
        case links = "_links"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        links = try values.decode([Link].self, forKey: .links)
        item = try T.init(from: decoder)
    }
}



