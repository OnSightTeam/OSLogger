//
//  LoggerStorage.swift
//  Logger
//
//  Created by OnSightTeam on 04.10.2022.
//  Copyright © 2022 OnSightTeam. All rights reserved.
//

import Foundation
import os.log
import OSLog
import UIKit

let subsystem = "com.onsightteam.logger"


@available(iOS 15.0, *)
private extension OSLogEntryLog {
    
    var color: UIColor {
        switch level {
        case .info: return .gray
        case .notice: return .yellow
        case .error: return .orange
        case .fault: return .red
        default:
            return .lightGray
        }
    }
}

/// @author Nikolay Chaban
///
/// Logger storage class.
/// Depends on the used iOS system on device logger posted data into `os.log` framework or to the `OSLog`
///
/// `shared` instance of the LoggerStorage used `.inMemory` storage.
///
/// Init method has required parameter of the ``Storage`` object.
///
/// ```swift
/// let storage = LoggerStorage(storage: Storage.filename(""
///
class LoggerStorage {
    
    // MARK: - Public attributes -
    static let shared = LoggerStorage(storage: .inMemory)
    
    
    // MARK: - Internal -
    private let storage: Storage<LogEntry>
    
    
    // MARK: - Init methods -
    
    init(storage: Storage<LogEntry>) {
        self.storage = storage
    }
    
    
    // MARK: - Public methods -

    func addLog(detail: Log) {
        if #available(iOS 15.0, *) {
            postToLogger(detail: detail)
        } else {
            postToOSLog(detail: detail)
        }
    }
    
    func obtainLogs() -> [LogEntry] {
        
        if #available(iOS 15.0, *) {
            return obtainLogsFromConsole()
        } else {
            return obtainLogsFromStorage()
        }
    }
    
    func removeAllLogs() {
        do {
            try storage.removeAllData()
        } catch let err {
            print("Occurs error on removing log data operation: \(err)")
        }
    }
}

private extension LoggerStorage {
    
    @available(iOS 15.0, *)
    private func postToLogger(detail: Log) {
        let logger: Logger = Logger(subsystem: subsystem, category: detail.category)
        
        switch detail.type {
        case .info:
            logger.notice("\(detail.message)")
        case .debug:
            logger.debug("\(detail.message)")
        case .warn:
            logger.warning("\(detail.message)")
        case .error:
            logger.error("\(detail.message)")
        case .fault:
            logger.fault("\(detail.message)")
        }
    }
    
    private func postToOSLog(detail: Log) {
        let logger = OSLog(subsystem: subsystem, category: detail.category)
        
        switch detail.type {
        case .info:
            os_log("%s", log: logger, type: .info, detail.message)
        case .debug:
            os_log("%s", log: logger, type: .debug, detail.message)
        case .warn:
            os_log("%s - warning", log: logger, type: .default, detail.message)
        case .error:
            os_log("%s", log: logger, type: .error, detail.message)
        case .fault:
            os_log("%s", log: logger, type: .fault, detail.message)
        }
        
        let logEntry = LogEntry(date: Date().toString(),
                                category: detail.category,
                                message: detail.message,
                                color: detail.color)
        
        do {
            try storage.save(logEntry)
        } catch let err {
            print("Store log entry data error: \(err)")
        }
    }
}

private extension LoggerStorage {
    
    @available(iOS 15, *)
    private func obtainLogsFromConsole() -> [LogEntry] {
        do {
            let logStorage = try OSLogStore(scope: .currentProcessIdentifier)
            
            let position = logStorage.position(date: Date().addingTimeInterval(-86400))
            let entries = try logStorage.getEntries(at: position)
                .compactMap { $0 as? OSLogEntryLog }
                .filter { $0.subsystem.starts(with: subsystem) }
                .map {
                    LogEntry(date: $0.date.toString(),
                             category: $0.category,
                             message: $0.composedMessage,
                             color: $0.color)
                }
            
            return entries
        } catch {
            print("Error with initializing log store object")
        }
        
        return []
    }
    
    private func obtainLogsFromStorage() -> [LogEntry] {
        do {
            guard let entries = try storage.load() else { return [] }
            
            return entries
        } catch let err {
            print("Load logs data error: \(err)")
        }
        
        return []
    }
}
