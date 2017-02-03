//
//  ProductsService.swift
//  CodeChallenge
//
//  Created by Fabricio Oliveira on 10/25/16.
//  Copyright © 2016 Fabricio Oliveira. All rights reserved.
//


import Foundation
import ObjectMapper

struct RepositoryService {
    
    static func findRepositories(params: [String: AnyObject], viewCallback: @escaping (Result<[Repository]>) -> Void) {
        RestShip.resource(MainRouter.repositories).queryParams(params)
            .method(.GET).parameterEncoding(.url)
            .request({ callback in
                switch callback{
                case .success(let JSONString):
                    guard let dictionary = JSONString.convertToDictionary() else {
                        viewCallback(Result.error("Error reading the repositories."))
                        return
                    }
                    guard let items = dictionary["items"] as? [[String : Any]] else {
                        viewCallback(Result.error("Error reading the repositories."))
                        return
                    }
                    
                    guard let products = Mapper<Repository>().mapArray(JSONArray: items) else {
                        viewCallback(Result.error("Error reading the repositories."))
                        return
                    }
                    viewCallback(Result.success(products))
                    break
                case .error(let error):
                    viewCallback(Result.error(error))
                    break
                }
            })
    }
}

