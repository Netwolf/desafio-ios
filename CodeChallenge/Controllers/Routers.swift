//
//  Routers.swift
//  CodeChallenge
//
//  Created by Fabricio Oliveira on 10/25/16.
//  Copyright © 2016 Fabricio Oliveira. All rights reserved.
//

import Foundation

enum MainRouter: RestShipResource {
    case repositories
    var name: String {
        switch self {
        case .repositories: return "/search/repositories"
        }
    }
}
