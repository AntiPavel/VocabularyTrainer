//
//  LessonListViewModel.swift
//  VocabularyTrainer
//
//  Created by Antonov, Pavel on 9/9/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//

import Foundation

final class LessonListViewModel {
    
    private var fileController: FileController
    
    private (set) lazy var lessonNames = [String]()
        
    init (fileController: FileController) {
        self.fileController = fileController
        getLessonNames()
    }
    
    private func getLessonNames() {
        guard let names = fileController.getFileNames() else { return }
        lessonNames = names
    }

}
