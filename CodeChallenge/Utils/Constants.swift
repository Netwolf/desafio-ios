//
//  Constants.swift
//  CodeChallenge
//
//  Created by Fabricio Oliveira on 10/25/16.
//  Copyright © 2016 Fabricio Oliveira. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    
    struct Config {
        static let BaseURL = "https://api.github.com"
    }
    
    struct Layout {
        static let PlaceholderRepository = UIImage(named: "PlaceholderRepository")!
        static let PlaceholderPerson = UIImage(named: "PlaceholderPerson")!
        static let IMDBBlue = UIImage(named: "IMDBBlue")!
    }
    
    struct Cell {
        static let RepositoryCell = "RepositoryCell"
    }
    
    struct InternetStatus {
        static let ReachabilityChangedNotification = "ReachabilityChangedNotification"
        static let StatusChanged = "StatusChanged"
    }
    
    struct Segue {
      static let DetailRepositorySegue = "DetailRepositorySegue"
    }
    
    struct Color {
        static let ColorNavigation = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
    }
}
