//
//  Lesson.swift
//  VocabularyTrainer
//
//  Created by Antonov, Pavel on 9/9/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//

import Foundation

final class Lesson {
    
    let name: String
    let questionTitle: String
    let answerTitle: String
    var exercises: [Exercise] = [] {
        didSet {
            
        }
    }
    
    init(name: String, firstLine: String) {
        self.name = name
        let titles = firstLine.components(separatedBy: ";")
        self.questionTitle = titles.first ?? "Question"
        let answrTitles = titles.dropFirst()
        self.answerTitle = answrTitles.first ?? "Answer"
    }
    
    func addExercise(exercise: Exercise) {
        exercises.append(exercise)
    }
    
    func successfullyFinished() -> Bool {
        guard exercises.count > 0 else {
            return false
        }
        return exercises.count == exercises.filter{ $0.count >= 4 }.count
    }
    
    func getStringCopy() -> [String] {
        let arr = ["\(questionTitle);\(answerTitle);Count"]
        let strExercises = exercises.compactMap { "\($0.question);\($0.correctAnswer);\($0.count)"}
        return arr + strExercises
    }
}
