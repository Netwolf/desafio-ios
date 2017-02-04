//
//  PullRequestService.swift
//  CodeChallenge
//
//  Created by Fabricio Oliveira on 2/3/17.
//  Copyright © 2017 Fabricio Oliveira. All rights reserved.
//

import Foundation
import ObjectMapper

struct PullRequestService {
    
    static func findPullRequestsWith(repository: Repository, viewCallback: @escaping (Result<[PullRequest]>) -> Void) {
        guard let nameRep = repository.name else {
            viewCallback(Result.error("Error reading the repository."))
            return
        }
        
        guard let loginUser = repository.owner?.login else {
            viewCallback(Result.error("Error reading the repository."))
            return
        }
        
        RestShip.resource(MainRouter.pullRequests(loginUser, nameRep))
            .method(.GET).parameterEncoding(.json)
            .request({ callback in
                switch callback{
                case .success(let JSONString):
                    guard let pullRequests = Mapper<PullRequest>().mapArray(JSONString: JSONString) else {
                        viewCallback(Result.error("Error reading the pullRequests."))
                        return
                    }
                    viewCallback(Result.success(pullRequests))
                    break
                case .error(let error):
                    viewCallback(Result.error(error))
                    break
                }
            })
    }
}

