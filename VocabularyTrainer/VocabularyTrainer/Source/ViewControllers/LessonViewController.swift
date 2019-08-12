//
//  LessonViewController.swift
//  VocabularyTrainer
//
//  Created by Antonov, Pavel on 9/10/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//

import UIKit
import Foundation

class LessonViewController: UIViewController {
    
    var viewModel: LessonViewModel!
    
    required init(viewModel: LessonViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    private lazy var lessonTitle: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    private lazy var questionTitle: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.italicSystemFont(ofSize: 16)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    private lazy var answerTitle: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.italicSystemFont(ofSize: 16)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    private lazy var question: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    private lazy var correctAnswer: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.isHidden = true
        return $0
    }(UILabel())
    
    private lazy var answerTextField: UITextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textAlignment = .center
        $0.placeholder = "answer_placeholder".localized
        $0.backgroundColor = .white
        $0.autocorrectionType = .no
        $0.becomeFirstResponder()
        return $0
    }(UITextField())
    
    private lazy var actionButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .blue
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 5
        $0.setTitle("continue_action".localized, for: .normal)
        $0.addTarget(self, action: #selector(action), for: .touchUpInside)
        return $0
    }(UIButton())
    
    private lazy var backButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(named: "backButton"), for: .normal)
        $0.addTarget(self, action: #selector(close), for: .touchUpInside)
        return $0
    }(UIButton())
    
    private lazy var resultImage: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = UIViewContentMode.scaleAspectFit
        $0.image = Images.correct.rawValue
        return $0
    }(UIImageView())
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(displayP3Red: 180/256, green: 190/256, blue: 210/256, alpha: 1)
        addSubViews()
        addConstraints()
        configure()
    }

    private func addSubViews() {
        view.addSubview(lessonTitle)
        view.addSubview(actionButton)
        view.addSubview(backButton)
        view.addSubview(questionTitle)
        view.addSubview(question)
        view.addSubview(correctAnswer)
        view.addSubview(answerTitle)
        view.addSubview(answerTextField)
        view.addSubview(resultImage)
    }
    
    private func addConstraints() {

        lessonTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        lessonTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        lessonTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        
        questionTitle.topAnchor.constraint(greaterThanOrEqualTo: lessonTitle.bottomAnchor, constant: 40).isActive = true
        questionTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        questionTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        
        question.topAnchor.constraint(equalTo: questionTitle.bottomAnchor, constant: 10).isActive = true
        question.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        question.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        
        answerTitle.topAnchor.constraint(greaterThanOrEqualTo: question.bottomAnchor, constant: 40).isActive = true
        answerTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        answerTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        
        answerTextField.topAnchor.constraint(equalTo: answerTitle.bottomAnchor, constant: 10).isActive = true
        answerTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        
        resultImage.centerYAnchor.constraint(equalTo: answerTextField.centerYAnchor).isActive = true
        resultImage.leadingAnchor.constraint(equalTo: answerTextField.trailingAnchor, constant: 10).isActive = true
        resultImage.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: -10).isActive = true
        resultImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        correctAnswer.topAnchor.constraint(equalTo: answerTextField.bottomAnchor, constant: 15).isActive = true
        correctAnswer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        correctAnswer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        
        actionButton.topAnchor.constraint(equalTo: correctAnswer.bottomAnchor, constant: 30).isActive = true
        actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        actionButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        actionButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        actionButton.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -224).isActive = true
        let bottomConstraint = actionButton.bottomAnchor.constraint(greaterThanOrEqualTo: view.bottomAnchor, constant: -15)
        bottomConstraint.priority = UILayoutPriority(rawValue: 999)
        bottomConstraint.isActive = true
        
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    private func lessonDoneConfiguration() {
        resultImage.removeFromSuperview()
        answerTextField.removeFromSuperview()
        answerTitle.removeFromSuperview()
        
        correctAnswer.topAnchor.constraint(equalTo: question.bottomAnchor, constant: 15).isActive = true
        correctAnswer.topAnchor.constraint(equalTo: question.bottomAnchor, constant: 15).isActive = true
    }
    
    private func configure() {
        
        lessonTitle.text = viewModel.title
        questionTitle.text = viewModel.questionTitle + ":"
        question.text = viewModel.question
        answerTitle.text = viewModel.answerTitle + ":"
        answerTextField.isHidden = !viewModel.showQuestionTextField
        actionButton.isHidden = viewModel.buttonState == .none ? true : false
        actionButton.setTitle(viewModel.buttonState.buttonTitle, for: .normal)
        switch viewModel.exerciseResult {
        case .none: resultImage.isHidden = true
            correctAnswer.isHidden = true
        case .right: resultImage.isHidden = false
            resultImage.image = Images.correct.rawValue
            correctAnswer.isHidden = true
        case .wrong: resultImage.isHidden = false
            correctAnswer.isHidden = false
            resultImage.image = Images.incorrect.rawValue
            correctAnswer.text = viewModel.correctAnswerText
        }
    }
    
    @objc private func action() {
        switch viewModel.buttonState {
        case .cont:
            viewModel.userAction(userAnswer: answerTextField.text ?? "")
            configure()
        case .next:
            viewModel.userAction(userAnswer: answerTextField.text ?? "")
            answerTextField.text = nil
            if !viewModel.showLessonResult {
                configure()
            } else {
                lessonDoneConfiguration()
                actionButton.setTitle(viewModel.buttonState.buttonTitle, for: .normal)
                lessonTitle.text = viewModel.title
                questionTitle.text = viewModel.lessonResult.resultText
                if viewModel.lessonResult == .end {
                    let correct = String(viewModel.correctAnswerCounter)
                    let wrong = String(viewModel.exerciseCounter - viewModel.correctAnswerCounter)
                    question.text = "correct_count".localized(correct)
                    correctAnswer.text = "wrong_count".localized(wrong)
                } else {
                    question.text = nil
                    correctAnswer.text = nil
                }
            }
        case .restart:
            viewModel.userAction(userAnswer: answerTextField.text ?? "")
            view.subviews.forEach { $0.removeFromSuperview() }
            addSubViews()
            addConstraints()
            configure()
        case .none:
            viewModel.userAction(userAnswer: answerTextField.text ?? "")

        }
    }
    
    @objc private func close() {
        viewModel.close()
       self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

enum Images {
    case correct
    case incorrect
}

extension Images: RawRepresentable {
    typealias RawValue = UIImage
    
    init?(rawValue: RawValue) {
        switch rawValue {
        case #imageLiteral(resourceName: "correct.png"): self = .correct
        case #imageLiteral(resourceName: "incorrect.png"): self = .incorrect
        default: return nil
        }
    }
    
    var rawValue: RawValue {
        switch self {
        case .correct: return #imageLiteral(resourceName: "correct.png")
        case .incorrect: return #imageLiteral(resourceName: "incorrect.png")
        }
    }
}

extension UIView {
    func removeAllConstraints() {
        var view: UIView? = self
        while let currentView = view {
            currentView.removeConstraints(currentView.constraints.filter {
                return $0.firstItem as? UIView == self || $0.secondItem as? UIView == self
            })
            view = view?.superview
        }
    }
}
