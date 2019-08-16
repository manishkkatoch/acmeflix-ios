//
//  Library.swift
//  Acmeflix
//
//  Created by Manish Katoch on 08/08/19.
//  Copyright © 2019 Manish Katoch. All rights reserved.
//

import Foundation


class Library : Decodable {
    let count: Int
    let movies: Array<Resource<Movie>>
}

extension Resource where T: Library {
    func getMovies() -> Array<Resource<Movie>> {
        return self.item?.movies ?? []
    }
}
