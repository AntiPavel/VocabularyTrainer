//
//  LessonListTableViewCell.swift
//  VocabularyTrainer
//
//  Created by Antonov, Pavel on 9/10/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//

import UIKit

final class LessonListTableViewCell: UITableViewCell {
    
    private lazy var lessonTitle: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addSubViews()
        addConstraints()
    }
    
    private func addSubViews() {
        contentView.addSubview(lessonTitle)

    }
    
    private func addConstraints() {
        
        lessonTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        lessonTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        lessonTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        lessonTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15).isActive = true

    }
    
    var lesson: String? {
        didSet {
            lessonTitle.text = lesson
        }
    }
    
    override func prepareForReuse() {
        lesson = nil
    }
}
