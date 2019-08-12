//
//  FileController.swift
//  VocabularyTrainer
//
//  Created by Antonov, Pavel on 9/13/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//

import Foundation

final class FileController {
    
    private var ext: String
    private let fileManager = FileManager.default
    private let documentsURL: URL
    
    var exercises: AnyIterator<Exercise>!
    
    init (ext: String = DefaultConfiguration.ext) {
        self.ext = ext
        do {
            documentsURL = try fileManager.url(for: .documentDirectory,
                                               in: .userDomainMask,
                                               appropriateFor: nil,
                                               create: false)
        } catch {
            fatalError("Can't get Documents directory url, error: \(error.localizedDescription)")
        }
        
        if isFirstRun() {
            initialSetup()
        }
    }
    
    private func initialSetup() {
        UserDefaults.standard.set(true, forKey: "wasPrevioslyStarted")
        copyLessonFilesToDocuments()
    }
    
    private func isFirstRun() -> Bool {
        return !UserDefaults.standard.bool(forKey: "wasPrevioslyStarted")
    }
    
    func  copyLessonFilesToDocuments() {
        guard let resourcePath = Bundle.main.resourcePath else { return }
        let filesURL = URL(fileURLWithPath: resourcePath)
        
        do {
            let bundleContents = try fileManager.contentsOfDirectory(at: filesURL,
                                                                     includingPropertiesForKeys: nil,
                                                                     options: [.skipsHiddenFiles,
                                                                               .skipsSubdirectoryDescendants,
                                                                               .skipsPackageDescendants])
            
            try bundleContents.forEach { currentPath in
                
                if currentPath.pathExtension.lowercased() == ext.lowercased() {
                    let documentFileURL = documentsURL.appendingPathComponent(currentPath.lastPathComponent)
                    try fileManager.copyItem(at: currentPath, to: documentFileURL)
                }
            }
            
        } catch {
            fatalError("Can't copy lesson files, error: \(error.localizedDescription)")
        }
    }
    
    func getFileNames() -> [String]? {
        
        do {
            let directoryContents = try fileManager.contentsOfDirectory(at: documentsURL,
                                                                        includingPropertiesForKeys: nil,
                                                                        options: [.skipsHiddenFiles,
                                                                                  .skipsSubdirectoryDescendants,
                                                                                  .skipsPackageDescendants])
            return directoryContents
                .filter{ $0.pathExtension.lowercased() == ext.lowercased() }
                .compactMap{ $0.deletingPathExtension().lastPathComponent }
            
        } catch {
            fatalError("Can't get lesson files, error: \(error.localizedDescription)")
        }
    }
}
