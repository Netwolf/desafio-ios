//
//  PullRequest.swift
//  CodeChallenge
//
//  Created by Fabricio Oliveira on 2/3/17.
//  Copyright © 2017 Fabricio Oliveira. All rights reserved.
//



import Foundation
import ObjectMapper

enum StatePullRequest: String {
    case closed = "closed"
    case open = "open"
}

class PullRequest: Mappable {

    var url: String?
    var id: Int?
    var diffUrl: String?
    var patchUrl: String?
    var issueUrl: String?
    var htmlUrl: String?
    var number: Double?
    var state: String = "closed"
    var locked: Bool?
    var title: String?
    var user: User?
    var body: String?
    var createdAt: String?
    var updatedAt: String?
    var closedAt: String?
    var mergedAt: String?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    var statePullRequest: StatePullRequest {
        return StatePullRequest(rawValue: state) ?? .closed
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        diffUrl <- map["diff_url"]
        url <- map["url"]
        patchUrl <- map["patch_url"]
        htmlUrl <- map["html_url"]
        issueUrl <- map["issue_url"]
        number <- map["number"]
        state <- map["state"]
        locked <- map["locked"]
        title <- map["title"]
        user <- map["user"]
        body <- map["body"]
        createdAt <- map["created_at"]
        updatedAt <- map["updated_at"]
        closedAt <- map["closed_at"]
        mergedAt <- map["merged_at"]
    }
}
