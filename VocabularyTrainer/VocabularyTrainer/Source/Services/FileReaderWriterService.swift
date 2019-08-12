//
//  FileReaderWriterService.swift
//  VocabularyTrainer
//
//  Created by Antonov, Pavel on 9/8/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//

import Foundation

protocol Reader {
    
    var name: String { get }
    func nextLine() -> String?
    func restart()

}

protocol Writer {
    func write(lesson: [String])
}

typealias ReaderWriter = Writer & Reader

final class FileReaderWriterService: Reader, Writer {
    
    let name: String
    
    private var ext: String
    private let fileManager = FileManager.default
    private let documentsURL: URL
    private let streamReader: TextFileStreamReader
    private let streamWriter: TextFileStreamWriter
    
    init (name: String, ext: String = DefaultConfiguration.ext) {
        self.name = name
        self.ext = ext
        do {
            documentsURL = try fileManager.url(for: .documentDirectory,
                                                         in: .userDomainMask,
                                                         appropriateFor: nil,
                                                         create: false)
            
        } catch {
            fatalError("Can't get Documents directory url, error: \(error.localizedDescription)")
        }
        
        let fileURL = documentsURL.appendingPathComponent("\(name).\(ext)")
        guard let reader = TextFile(url: fileURL).streamReader() else { fatalError("Can't create file reader") }
        streamReader = reader
        guard let writer = TextFile(url: fileURL).streamWriter() else { fatalError("Can't create file writer") }
        streamWriter = writer
    }
    
    func nextLine() -> String? {
        return streamReader.nextLine()
    }
    
    func restart() {
       streamReader.restart()
    }
    
    func write(lesson: [String]) {
//        print("lesson: ", lesson)
        let str = lesson.joined(separator: "\r\n")
//        print("str: ", str)
//        print("......................")
        let fileURL = documentsURL.appendingPathComponent("\(name).\(ext)")
        guard let _ = try? str.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8) else { fatalError("writing error") }
//        streamWriter.
//        lesson.forEach { streamWriter.write(line: $0) }
//        do {
//            let string = try String(contentsOf: fileURL, encoding: String.Encoding.utf8)
//            print("new:_____________________")
//            print(string)
//            print("_____________________")
//        } catch {
//            fatalError("Can't read file: \(name), error: \(error.localizedDescription)")
//        }
    }

}
