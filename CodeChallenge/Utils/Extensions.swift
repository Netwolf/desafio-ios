//
//  Extensions.swift
//  CodeChallenge
//
//  Created by Fabricio Oliveira on 12/15/16.
//  Copyright © 2016 Fabricio Oliveira. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

extension String {
    /**
     Transform string in a dictionary.
     @return A dictionary representation for the current string.
     */
    func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    /**
     @return Check if the current string is not blanked.
     */
    func isBlank() -> Bool {
        let trimmed = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return trimmed.isEmpty
    }
}

