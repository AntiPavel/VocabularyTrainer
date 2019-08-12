//
//  TextFile.swift
//  VocabularyTrainer
//
//  Created by Antonov, Pavel on 9/8/18.
//  Copyright © 2018 Pavel Antonov. All rights reserved.
//
// maden from original: https://github.com/nvzqz/FileKit/blob/develop/Sources/TextFile.swift

import Foundation

open class TextFile {
    
    open var encoding: String.Encoding = String.Encoding.utf8
    open var url: URL
    
    public init(url: URL) {
        self.url = url
    }
    
    /// Writes a string to a text file using the file's encoding.
    ///
    /// - Parameter data: The string to be written to the text file.
    /// - Parameter useAuxiliaryFile: If `true`, the data is written to an
    ///                               auxiliary file that is then renamed to the
    ///                               file. If `false`, the data is written to
    ///                               the file directly.
    ///
    /// - Throws: Error
    ///
    open func write(_ data: String, atomically useAuxiliaryFile: Bool) throws {
        do {
            try data.write(to: url, atomically: useAuxiliaryFile, encoding: encoding)
        } catch {
            throw error
        }
    }
    
}

// MARK: Line Reader
extension TextFile {
    
    /// Provide a reader to read line by line.
    ///
    /// - Parameter delimiter: the line delimiter (default: \n)
    /// - Parameter chunkSize: size of buffer (default: 4096)
    ///
    /// - Returns: the `TextFileStreamReader`
    ///
    public func streamReader(_ delimiter: String? = nil,
                             chunkSize: Int = 4096) -> TextFileStreamReader? {
        return TextFileStreamReader(url: self.url,
                                    delimiter: delimiter,
                                    encoding: encoding,
                                    chunkSize: chunkSize)
    }
}

/// A class to read `TextFile` line by line.
open class TextFileStreamReader {
    
    /// The text encoding.
    open var encoding: String.Encoding
    
    var delimData: Data!
    var fileHandle: FileHandle?
    
    /// The chunk size when reading.
    public let chunkSize: Int
    
    /// Tells if the position is at the end of file.
    open var atEOF: Bool = false
    
    var buffer: Data!
    
    // MARK: - Initialization
    /// - Parameter path:      the file path
    /// - Parameter delimiter: the line delimiter (default: \n)
    /// - Parameter encoding: file encoding (default: .utf8)
    /// - Parameter chunkSize: size of buffer (default: 4096)
    public init?(url: URL,
                 delimiter: String?,
                 encoding: String.Encoding = .utf8,
                 chunkSize: Int = 4096) {
        self.chunkSize = chunkSize
        self.buffer = Data(capacity: chunkSize)
        self.encoding = encoding
        guard let handle = try? FileHandle(forReadingFrom: url)  else { return nil }
        self.fileHandle = handle
        let delimeter = delimiter?.data(using: encoding) ?? getLineDelimiter(handle: handle)
        guard let delimData = delimeter else { return nil }
        self.delimData = delimData
    }
    
    // MARK: - Deinitialization
    deinit {
        self.close()
    }
    
    // MARK: - public methods
    open var offset: UInt64 {
        return fileHandle?.offsetInFile ?? 0
    }
    
    open func seek(toFileOffset offset: UInt64) {
        fileHandle?.seek(toFileOffset: offset)
    }
    
    /// Close the underlying file. No reading must be done after calling this method.
    open func close() {
        fileHandle?.closeFile()
        fileHandle = nil
    }
    
    /// Return true if file handle closed.
    open var isClosed: Bool {
        return fileHandle == nil
    }
    
    /// - Returns: The next line, or nil on EOF.
    open func nextLine() -> String? {
        if atEOF {
            return nil
        }
        
        // Read data chunks from file until a line delimiter is found.
        var range = buffer.range(of: delimData, options: [], in: 0..<buffer.count)
        while range == nil {
            guard let tmpData = fileHandle?.readData(ofLength: chunkSize), !tmpData.isEmpty else {
                // EOF or read error.
                atEOF = true
                if !buffer.isEmpty {
                    // Buffer contains last line in file (not terminated by delimiter).
                    let line = String(data: buffer, encoding: encoding)
                    
                    buffer.count = 0
                    return line
                }
                // No more lines.
                return nil
            }
            buffer.append(tmpData)
            range = buffer.range(of: delimData, options: [], in: 0..<buffer.count)
        }
        
        // Convert complete line (excluding the delimiter) to a string.
        let line = String(data: buffer.subdata(in: 0..<range!.lowerBound), encoding: encoding)
        
        // Remove line (and the delimiter) from the buffer.
        let cleaningRange: Range<Data.Index> = 0..<range!.upperBound
        buffer.replaceSubrange(cleaningRange, with: Data())
        
        return line
    }
    
    /// Start reading from the beginning of file.
    open func rewind() {
        fileHandle?.seek(toFileOffset: 0)
        buffer.count = 0
        atEOF = false
    }
    
    open func restart() {
        rewind()
        delimData = getLineDelimiter(handle: fileHandle) ?? "\n".data(using: encoding)
    }
    
    private func getLineDelimiter(handle: FileHandle?) -> Data? {
        guard let data = handle?.readData(ofLength: chunkSize) else { fatalError("Can't read data") }
        rewind()
        let delimDataArr = DefaultConfiguration.delimeters.compactMap { $0.data(using: encoding) }
        
        for delimData in delimDataArr {
            if data.range(of: delimData) != nil {
                return delimData
            }
        }
        return nil
    }
    
    private func isContainDelimeter(data: Data, delimeter: String) -> Bool {
        guard let delimData = delimeter.data(using: encoding) else { return false }
        return data.range(of: delimData) != nil
    }
}

/// A class to read or write `TextFile`.
open class TextFileStream {
    
    /// The text encoding.
    open var encoding: String.Encoding
    
    var delimData: Data
    var fileHandle: FileHandle?
    
    // MARK: - Initialization
    public init(fileHandle: FileHandle,
                delimiter: Data,
                encoding: String.Encoding = .utf8) {
        self.encoding = encoding
        self.fileHandle = fileHandle
        self.delimData = delimiter
    }
    
    // MARK: - Deinitialization
    deinit {
        self.close()
    }
    
    // MARK: - public methods
    open var offset: UInt64 {
        return fileHandle?.offsetInFile ?? 0
    }
    
    open func seek(toFileOffset offset: UInt64) {
        fileHandle?.seek(toFileOffset: offset)
    }
    
    /// Close the underlying file. No reading must be done after calling this method.
    open func close() {
        fileHandle?.closeFile()
        fileHandle = nil
    }
    
    /// Return true if file handle closed.
    open var isClosed: Bool {
        return fileHandle == nil
    }
}

// MARK: Line Writer
/// A class to write a `TextFile` line by line.
open class TextFileStreamWriter: TextFileStream {
    
    public let append: Bool
    
    // MARK: - Initialization
    /// - Parameter path:      the file path
    /// - Parameter delimiter: the line delimiter (default: \n)
    /// - Parameter encoding: file encoding (default: .utf8)
    /// - Parameter append: if true append at file end (default: false)
    /// - Parameter createIfNotExist: if true create file if not exist (default: true)
    public init?(url: URL,
                 delimiter: String = "\n",
                 encoding: String.Encoding = .utf8,
                 append: Bool = false,
                 createIfNotExist: Bool = true) {
        let isExist = FileManager.default.fileExists(atPath: url.path)
        if createIfNotExist && !isExist {
            
            guard FileManager.default.createFile(atPath: url.path,
                                                 contents: nil,
                                                 attributes: nil) else { return nil }
        }
        self.append = append
         guard let handle = try? FileHandle(forWritingTo: url) else { return nil }
        if append {
            handle.seekToEndOfFile()
        }
        guard let delimData = delimiter.data(using: encoding) else { return nil }
        super.init(fileHandle: handle, delimiter: delimData, encoding: encoding)
    }
    
    /// Write a new line in file
    /// - Parameter line:      the line
    /// - Parameter delim:     append the delimiter (default: true)
    ///
    /// - Returns: true if successfully.
    @discardableResult
    open func write(line: String, delim: Bool = true) -> Bool {
        if let handle = fileHandle, let data = line.data(using: self.encoding) {
            
            handle.write(data)
                
            if delim {
                handle.write(delimData)
            }
            return true
        }
        return false
    }
    
    /// Write a line delimiter.
    ///
    /// - Returns: true if successfully.
    open func writeDelimiter() -> Bool {
        if let handle = fileHandle {
            handle.write(delimData)
            return true
        }
        return false
    }
    
    /// Causes all in-memory data and attributes of the file represented by the receiver to be written to permanent storage.
    open func synchronize() {
        fileHandle?.synchronizeFile()
    }
}

extension TextFile {
    
    /// Provide a writer to write line by line.
    ///
    /// - Parameter delimiter: the line delimiter (default: \n)
    /// - Parameter append: if true append at file end (default: false)
    ///
    /// - Returns: the `TextFileStreamWriter`
    public func streamWriter(_ delimiter: String = "\r\n",
                             append: Bool = false) -> TextFileStreamWriter? {
        return TextFileStreamWriter(url: self.url,
                                    delimiter: delimiter,
                                    encoding: encoding,
                                    append: append)
    }
}
