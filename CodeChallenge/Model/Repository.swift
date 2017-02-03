//
//  Repository.swift
//  CodeChallenge
//
//  Created by Fabricio Oliveira on 02/02/17.
//  Copyright © 2016 Fabricio Oliveira. All rights reserved.
//


import Foundation
import ObjectMapper

class Repository: Mappable {
    
    var id: Int?
    var name: String?
    var fullName: String?
    var owner: Owner?
    var isPrivate: Bool?
    var url: URL?
    var description: String?
    var watchersCount: Double?
    var forksCount: Double = 0.0
    var starsCount: Double = 0.0
    var openIssues: Double = 0.0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        fullName <- map["full_name"]
        owner <- map["owner"]
        isPrivate <- map["private"]
        url <- map["url"]
        description <- map["description"]
        starsCount <- map["stargazers_count"]
        forksCount <- map["forks_count"]
        watchersCount <- map["watchers_count"]
        openIssues <- map["open_issues_count"]
    }

}
