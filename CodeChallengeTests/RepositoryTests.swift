//
//  RepositoryTests.swift
//  CodeChallenge
//
//  Created by Fabricio Oliveira on 2/4/17.
//  Copyright © 2017 Fabricio Oliveira. All rights reserved.
//

import Foundation

import XCTest
import ObjectMapper

@testable import CodeChallenge

class RepositoryTests: XCTestCase {
    
    func testRepositoryInstance() {
        let dictionary = ["full_name": "Full name repository" as AnyObject,
                          "name": "Testing" as AnyObject,
                          "forks_count": 10.0 as AnyObject,
                          "description": "Testing description" as AnyObject,
                          "owner": ["login": "login" as AnyObject,
                                    "avatar_url": "https://avatars.githubusercontent.com/u/1269832?v=3" as AnyObject] as AnyObject]
        guard let repository = Mapper<Repository>().map(JSON: dictionary) else {
            return
        }
        XCTAssertEqual(repository.fullName, "Full name repository")
        XCTAssertEqual(repository.name, "Testing")
        XCTAssertEqual(repository.description!, "Testing description")
        XCTAssertEqual(repository.forksCount, 10.0)
        XCTAssertNotNil(repository.owner)
    }
    
    func testRepositoryInstanceWithoutOwner() {
        let dictionary = ["full_name": "Full name repository" as AnyObject,
                          "name": "Testing" as AnyObject,
                          "forks_count": 10.0 as AnyObject,
                          "description": "Testing description" as AnyObject]
        guard let repository = Mapper<Repository>().map(JSON: dictionary) else {
            return
        }
        XCTAssertEqual(repository.fullName, "Full name repository")
        XCTAssertEqual(repository.name, "Testing")
        XCTAssertEqual(repository.description!, "Testing description")
        XCTAssertEqual(repository.forksCount, 10.0)
        XCTAssertNotNil(repository.owner)
    }
}

