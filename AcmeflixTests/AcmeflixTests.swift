//
//  AcmeflixTests.swift
//  AcmeflixTests
//
//  Created by Manish Katoch on 02/08/19.
//  Copyright © 2019 Manish Katoch. All rights reserved.
//

@testable import Acmeflix
import XCTest

class AcmeflixTests: XCTestCase {
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLinkParsingWithMethod() {
        let jsonString = "{\"url\":\"link\",\"method\":\"PUT\"}"
        let link = parse(type: Link.self, data: Data.init(jsonString.utf8))
        XCTAssertNotNil(link)
    }
    
    func testLinkParsingWithNoMethod() {
        let jsonString = "{\"url\":\"link\"}"
        let link = parse(type: Link.self, data: Data.init(jsonString.utf8))
        XCTAssertNotNil(link)
    }
}
