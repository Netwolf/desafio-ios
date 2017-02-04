//
//  CodeChallengeTests.swift
//  CodeChallengeTests
//
//  Created by Fabricio Oliveira on 2/3/17.
//  Copyright © 2017 Fabricio Oliveira. All rights reserved.
//

import XCTest
import ObjectMapper

class CodeChallengeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testFilterArrayByProperty() {
        let dictionaryOne = ["title": "Title of Pull Request" as AnyObject,
                             "state": "closed" as AnyObject,
                             "html_url": "https://github.com/ReactiveX/RxJava/" as AnyObject,
                             "body": "body" as AnyObject,
                             "user": ["login": "login" as AnyObject,
                                      "avatar_url": "https://avatars.githubusercontent.com/u/1269832?v=3" as AnyObject] as AnyObject]
        guard let pullRequestOne = Mapper<PullRequest>().map(JSON: dictionaryOne) else {
            return
        }
        
        let dictionaryTwo = ["title": "Title of Pull Request" as AnyObject,
                             "state": "closed" as AnyObject,
                             "html_url": "https://github.com/ReactiveX/RxJava/" as AnyObject,
                             "body": "body" as AnyObject,
                             "user": ["login": "login" as AnyObject,
                                      "avatar_url": "https://avatars.githubusercontent.com/u/1269832?v=3" as AnyObject] as AnyObject]
        guard let pullRequestTwo = Mapper<PullRequest>().map(JSON: dictionaryTwo) else {
            return
        }
        
        let pullRequests = [pullRequestTwo, pullRequestOne]
        
        let text = "titlee"
        let arrayFiltered = pullRequests.filter({ pullRequest -> Bool in
            guard let title = pullRequest.title else {
                return true
            }
            return title.lowercased().contains(text.lowercased())
        })
        
        XCTAssertEqual(arrayFiltered.count, 0)
    }
    
    
    
    func testCalculateOpenAndClosedRequests() {
        let dictionaryOne = ["title": "Title of Pull Request" as AnyObject,
                             "state": "closed" as AnyObject,
                             "html_url": "https://github.com/ReactiveX/RxJava/" as AnyObject,
                             "body": "body" as AnyObject,
                             "user": ["login": "login" as AnyObject,
                                      "avatar_url": "https://avatars.githubusercontent.com/u/1269832?v=3" as AnyObject] as AnyObject]
        guard let pullRequestOne = Mapper<PullRequest>().map(JSON: dictionaryOne) else {
            return
        }
        
        let dictionaryTwo = ["title": "Title of Pull Request" as AnyObject,
                             "state": "closed" as AnyObject,
                             "html_url": "https://github.com/ReactiveX/RxJava/" as AnyObject,
                             "body": "body" as AnyObject,
                             "user": ["login": "login" as AnyObject,
                                      "avatar_url": "https://avatars.githubusercontent.com/u/1269832?v=3" as AnyObject] as AnyObject]
        guard let pullRequestTwo = Mapper<PullRequest>().map(JSON: dictionaryTwo) else {
            return
        }
        
        let pullRequests = [pullRequestTwo, pullRequestOne]
        var open = 0.0
        var closed = 0.0
        for request in pullRequests {
            if request.statePullRequest == .closed {
                closed += 1
            } else {
                open += 1
            }
        }
        XCTAssertEqual(open, 0)
        XCTAssertEqual(closed, 2)
    }
}
