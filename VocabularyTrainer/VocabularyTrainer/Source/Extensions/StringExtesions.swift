//
//  StringExtesions.swift
//  VocabularyTrainer
//
//  Created by Antonov, Pavel on 9/10/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//

import Foundation

extension String {
    
    public var localized: String {
        let string = NSLocalizedString(self, comment: "")
//        if string == self {
//            string = NSLocalizedString(self, bundle: Bundle(for: Environment.self), comment: "")
//        }
//        assert(string != self, "Translation for '\(self)' not found")
        return string
    }
    
    public func localized(_ args: CVarArg...) -> String {
        return String(format: self.localized, arguments: args)
    }
}
