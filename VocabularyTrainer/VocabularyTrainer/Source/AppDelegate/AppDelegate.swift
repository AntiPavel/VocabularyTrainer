//
//  AppDelegate.swift
//  VocabularyTrainer
//
//  Created by Antonov, Pavel on 9/8/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//

import UIKit
import Foundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let viewController = LessonsListViewController(viewModel:
            LessonListViewModel(fileController: FileController()))
        let navigationController = UINavigationController(rootViewController: viewController)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }

}

