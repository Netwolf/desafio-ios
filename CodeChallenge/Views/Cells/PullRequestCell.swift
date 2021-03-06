//
//  PullRequestCell.swift
//  CodeChallenge
//
//  Created by Fabricio Oliveira on 2/3/17.
//  Copyright © 2017 Fabricio Oliveira. All rights reserved.
//

//
//  MovieCell.swift
//  CodeChallenge
//
//  Created by Fabricio Oliveira on 10/25/16.
//  Copyright © 2016 Fabricio Oliveira. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class PullRequestCell: UITableViewCell {
    
    @IBOutlet weak var imageViewUser: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var labelFullName: UILabel!
    
    
    func configure(_ object: AnyObject) {
        let pullRequest = object as! PullRequest
        labelTitle.text = pullRequest.title
        labelDescription.text = pullRequest.body
        labelUserName.text = pullRequest.user?.login
        labelFullName.text = pullRequest.user?.login

        guard let avatarUrl = pullRequest.user?.avatarUrl else {
            imageViewUser.image = Constants.Layout.PlaceholderPerson
            return
        }
        
        guard let url = URL(string: avatarUrl) else {
            imageViewUser.image = Constants.Layout.PlaceholderPerson
            return
        }
        
        imageViewUser.af_setImage(withURL: url, placeholderImage: Constants.Layout.PlaceholderPerson, filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: UIImageView.ImageTransition.crossDissolve(0.5), runImageTransitionIfCached: false, completion: { (result) in
        })
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageViewUser.clipsToBounds = true
    }
}

