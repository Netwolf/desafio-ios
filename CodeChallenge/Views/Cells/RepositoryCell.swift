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

class RepositoryCell: UITableViewCell {
    
    @IBOutlet weak var imageViewUser: UIImageView!
    @IBOutlet weak var labelNameRepository: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelLikes: UILabel!
    @IBOutlet weak var labelForks: UILabel!
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var labelFullName: UILabel!


    func configure(_ object: AnyObject) {
        let repository = object as! Repository
        labelNameRepository.text = repository.fullName
        labelDescription.text = repository.description
        labelForks.text = String(format:"%.0f", repository.forksCount)
        labelLikes.text = String(format:"%.0f", repository.starsCount)
        labelUserName.text = repository.owner?.login
        labelFullName.text = repository.owner?.login
    
        guard let avatarUrl = repository.owner?.avatarUrl else {
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

