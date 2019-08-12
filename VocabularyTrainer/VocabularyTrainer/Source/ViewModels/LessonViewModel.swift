//
//  LessonViewModel.swift
//  VocabularyTrainer
//
//  Created by Antonov, Pavel on 9/10/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//

import Foundation

final class LessonViewModel {
    
    enum ExerciseResult {
        case right, wrong, none
    }
    
    enum LessonResult: String {
        case end
        case done
        
        var resultText: String {
            switch self {
            case .end:
                return "lesson_end".localized
            case .done:
                return "lesson_done".localized
            }
        }
    }
    
    enum ButtonState: String {
        case cont // can't use the continue word 'cause it has been reserved by the system
        case next
        case restart
        case none
        
        var buttonTitle: String {
            switch self {
            case .cont:
                return "continue_action".localized
            case .next:
                return "next_action".localized
            case .restart:
                return "restart_action".localized
            case .none:
                return "close_action".localized
            }
        }
    }
    
    var showLessonResult: Bool = false
    var showQuestionTextField: Bool = true
    var buttonState: ButtonState = .cont
    var exerciseResult: ExerciseResult = .none
    var title: String  { return "title_lesson".localized(lesson.name) }
    var questionTitle: String { return lesson.questionTitle }
    var question: String? { return exercise?.question }
    var answerTitle: String { return lesson.answerTitle }
    var correctAnswerText: String { return "correct_answer".localized(exercise?.correctAnswer ?? "") }
    var lessonResult: LessonResult { return lesson.successfullyFinished() ? .done : .end }
    var exerciseCounter: Int = 0
    var correctAnswerCounter: Int = 0
    
    private var service: ReaderWriter
    private var lesson: Lesson!
    private var exercise: Exercise? {
        didSet {
            guard let newExercise = exercise else { return }
            guard newExercise.count < 4 else {
                lesson.addExercise(exercise: newExercise)
                getNextLine()
                return
            }
            showQuestion()
        }
    }
    
    init (name: String) {
        service = FileReaderWriterService(name:name)
        start()
    }
    
    private func start() {
        service.restart()
        guard let firstLine = service.nextLine() else { fatalError("Can't read first line") }
        lesson = Lesson(name: service.name, firstLine: firstLine)
        getNextLine()
    }
    
    private func getNextLine() {
        guard let nextLine = service.nextLine()  else {
            lessonDone()
            return
        }
        guard let exercise = Exercise(line: nextLine) else {
            getNextLine()
            return
        }
        self.exercise = exercise
    }
    
    func userAction(userAnswer: String) {

        switch buttonState {
        case .cont:
            guard var strongExercise = exercise else { return }
            exerciseResult = strongExercise.checkAndUpdateCount(answer: userAnswer) ? .right : .wrong
            lesson.addExercise(exercise: strongExercise)
            exerciseCounter += 1
            correctAnswerCounter = exerciseResult == .right ? correctAnswerCounter + 1 : correctAnswerCounter
            showResult()
        case .next:
            getNextLine()
        case .restart:
            restart()
        case .none:
            break
        }
    }
    
    private func lessonDone() {
        showQuestionTextField = false
        showLessonResult = true
        exerciseResult = .none
        buttonState = .restart
    }
    
    private func showQuestion() {
        showQuestionTextField = true
        showLessonResult = false
        exerciseResult = .none
        buttonState = .cont
    }
    
    private func showResult() {
        showQuestionTextField = true
        showLessonResult = false
        buttonState = .next
    }

    private func restart() {
        exerciseCounter = 0
        correctAnswerCounter = 0
        if !lesson.successfullyFinished() {
           // DispatchQueue.global().async {
                self.saveLesson()
               // DispatchQueue.main.async {[weak self] in
                    self.lesson.exercises = []
                    self.start()
              //  }
           // }
        }
    }
    
    func close() {
      //  DispatchQueue.global().async {
            self.saveLesson()
     //  }
    }
    
    private func saveLesson() {
        guard let nextLine = self.service.nextLine()  else {
             service.write(lesson: lesson.getStringCopy())
            return
        }
        if let exercise = Exercise(line: nextLine) {
            self.lesson.addExercise(exercise: exercise)
        }
        self.saveLesson()
    }
}

