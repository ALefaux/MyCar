//
//  Helper.swift
//  My Car
//
//  Created by Axel Lefaux on 11/03/2018.
//  Copyright © 2018 ITomorrow. All rights reserved.
//

import Foundation

class Helper {
    static let instance = Helper()
    
    func stringIsNulOrEmpty(string: String?) -> Bool {
        return string == nil || string == ""
    }
}
