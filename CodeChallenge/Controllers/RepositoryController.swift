//
//  MovieController.swift
//  CodeChallenge
//
//  Created by Fabricio Oliveira on 12/14/16.
//  Copyright © 2016 Fabricio Oliveira. All rights reserved.
//

import Foundation
import SVProgressHUD

protocol DelegateRepository {
    func repositoriesFoundWithSuccess(repositories:[Repository])
    func repositoriesNotFoundWith(error: String)
}

class RepositoryController: NSObject {
    static var sharedInstance = RepositoryController()
    var delegate: DelegateRepository?
    
    func findRepositories(page: Int) {
        let params = ["page": page as AnyObject,
                      "q": "language:Java" as AnyObject,
                      "sort": "stars" as AnyObject] as [String : AnyObject]
        SVProgressHUD.show(withStatus: "Loading")
        RepositoryService.findRepositories(params: params) { result in
            switch result {
            case .success(let repositories):
                self.delegate?.repositoriesFoundWithSuccess(repositories: repositories)
                break
            case .error(let error):
                self.delegate?.repositoriesNotFoundWith(error: error)
                break
            }
            SVProgressHUD.dismiss()
        }
    }
}

