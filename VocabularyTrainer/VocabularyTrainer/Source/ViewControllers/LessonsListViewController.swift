//
//  LessonsListViewController.swift
//  VocabularyTrainer
//
//  Created by Antonov, Pavel on 9/9/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//

import UIKit

class LessonsListViewController: UIViewController {
    
    var viewModel: LessonListViewModel!
    
    required init(viewModel: LessonListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }
    
    private lazy var tableView: UITableView = { [unowned self] in
        $0.delegate = self
        $0.dataSource = self
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(LessonListTableViewCell.self,
                    forCellReuseIdentifier: LessonListTableViewCell.className)
        $0.showsVerticalScrollIndicator = false
        $0.rowHeight = UITableViewAutomaticDimension
        $0.bounces = true
        $0.backgroundColor = .white
        return $0
        }(UITableView(frame: .zero, style: .plain))
    
    private func showAlertController(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "error_title".localized, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok_title".localized, style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func showLessonViewController(lesson: String) {
        DispatchQueue.main.async {
            let lessonViewController = LessonViewController(viewModel: LessonViewModel(name:lesson))
            self.present(lessonViewController, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension LessonsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.lessonNames.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LessonListTableViewCell.className,
                                                       for: indexPath) as? LessonListTableViewCell
            else { fatalError("unknown cell type") }
        cell.lesson = viewModel.lessonNames[indexPath.row]
        return cell
    }
}

extension LessonsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let lesson = viewModel.lessonNames[indexPath.row] else {
//            showAlertController(message: "open_lesson_error".localized)
//            return
//        }
        showLessonViewController(lesson: viewModel.lessonNames[indexPath.row])
    }
}

