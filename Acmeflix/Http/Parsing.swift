//
//  Parsing.swift
//  Acmeflix
//
//  Created by Manish Katoch on 04/08/19.
//  Copyright © 2019 Manish Katoch. All rights reserved.
//

import Foundation

func parse<T>(type: T.Type, data: Data) -> T? where T : Codable {
    let decoder = JSONDecoder()
    return try? decoder.decode(type, from: data)
}
