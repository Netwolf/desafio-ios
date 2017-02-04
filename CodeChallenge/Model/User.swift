//
//  User.swift
//  CodeChallenge
//
//  Created by Fabricio Oliveira on 2/3/17.
//  Copyright © 2017 Fabricio Oliveira. All rights reserved.
//

import Foundation
import ObjectMapper

class User: Mappable {
    
    var login: String?
    var id: Float?
    var avatarUrl: String?
    var url: String?

    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        login <- map["login"]
        avatarUrl <- map["avatar_url"]
        url <- map["html_url"]
    }
}
