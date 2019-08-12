//
//  Exercise.swift
//  VocabularyTrainer
//
//  Created by Antonov, Pavel on 9/9/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//

import Foundation

struct Exercise {
    
    var count: Int = 0
    var question: String
    var correctAnswer: String
    
    init?(line: String) {
        let lineArr = line.components(separatedBy: ";")
        guard let question = lineArr.first else { return nil }
        let answerArr = lineArr.dropFirst()
        guard let answer = answerArr.first else { return nil }
        let countArr = answerArr.dropFirst()
        guard let countStr = countArr.first, let count = Int(countStr) else { return nil }
        self.question = question
        self.correctAnswer = answer
        self.count = count
    }
    
    mutating func checkAndUpdateCount(answer: String) -> Bool {
        let result = answer.lowercased() == correctAnswer.lowercased()
        count = result ? count + 1 : count - 1
        return result
    }
}
