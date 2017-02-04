//
//  PullRequestController.swift
//  CodeChallenge
//
//  Created by Fabricio Oliveira on 2/3/17.
//  Copyright © 2017 Fabricio Oliveira. All rights reserved.
//

import Foundation
import SVProgressHUD

protocol DelegatePullRequest {
    func pullRequestFoundWithSuccess(pullRequests:[PullRequest])
    func pullRequestNotFoundWith(error: String)
    func totalOpenAndClosedRequests(open: Double, closed: Double)
}

class PullRequestController: NSObject {
    static var sharedInstance = PullRequestController()
    var delegate: DelegatePullRequest?
    
    func findPullRequestsBy(repository: Repository) {
        SVProgressHUD.show(withStatus: "Loading")
        PullRequestService.findPullRequestsWith(repository: repository) { result in
            switch result {
            case .success(let pullRequests):
                self.delegate?.pullRequestFoundWithSuccess(pullRequests: pullRequests)
                break
            case .error(let error):
                self.delegate?.pullRequestNotFoundWith(error: error)
                break
            }
            SVProgressHUD.dismiss()
        }
    }
    
    func openPullRequestPage(urlPage: String) {
        if let url = URL(string: urlPage) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],
                                          completionHandler: {
                                            (success) in
                })
            } else {
                _ = UIApplication.shared.openURL(url)
            }
        }
    }
    
    func calculateOpenAndClosedRequests(pullRequests: [PullRequest]) {
        var open = 0.0
        var closed = 0.0
        for request in pullRequests {
            if request.statePullRequest == .closed {
                closed += 1
            } else {
                open += 1
            }
        }
        delegate?.totalOpenAndClosedRequests(open: open, closed: closed)
    }
}
