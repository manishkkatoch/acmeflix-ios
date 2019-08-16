//
//  Link.swift
//  Acmeflix
//
//  Created by Manish Katoch on 02/08/19.
//  Copyright © 2019 Manish Katoch. All rights reserved.
//

import Foundation

struct Link : Decodable, Equatable {
    
    let url: String
    let rel: String
    let method: HttpMethod
    let bodyJson: [String: DecodableValueType]?
    
    enum CodingKeys: String,CodingKey {
        case url = "href"
        case rel, method
        case bodyJson = "parameters"
    }
    
    init(from decoder:Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.url = try container.decode(String.self, forKey: .url)
        self.rel = try container.decode(String.self, forKey: .rel)
        self.bodyJson = try? container.decode([String:DecodableValueType].self, forKey: .bodyJson)
        
        if let methodUnwrapped = try container.decodeIfPresent(String.self, forKey: .method) {
            self.method = HttpMethod(rawValue: methodUnwrapped) ?? HttpMethod.GET
        } else {
            self.method = HttpMethod.GET
        }
    }
    
    init(withUrl url: String) {
        self.url = url
        self.method = HttpMethod.GET
        self.rel = "self"
        self.bodyJson = nil
    }
    
    static func == (lhs: Link, rhs: Link) -> Bool {
        return lhs.url == rhs.url && lhs.rel == rhs.rel && lhs.method == rhs.method
    }
}	
