//
//  NSObjectExtensions.swift
//  VocabularyTrainer
//
//  Created by Antonov, Pavel on 9/10/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//

import Foundation

public extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}
