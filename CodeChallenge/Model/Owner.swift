//
//  Owner.swift
//  CodeChallenge
//
//  Created by Fabricio Oliveira on 2/2/17.
//  Copyright © 2017 Fabricio Oliveira. All rights reserved.
//

import Foundation
import ObjectMapper

class Owner: Mappable {
    
    var login: String?
    var id: Int?
    var avatarUrl: String?
    var url: String?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        login <- map["login"]
        id <- map["id"]
        avatarUrl <- map["avatar_url"]
        url <- map["html_url"]
    }
}
