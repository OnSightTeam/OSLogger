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

/// Constant of the logs subsystem in the device console.
///
let subsystem = "com.onsightteam.logger"

/// Log entry colors extension
///
/// `.color` property defines color of the view based on the log type.
/// Property used in display logs view or similar solutions.
///
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


/// Logger storage class.
/// Depends on the used iOS system on device logger posted data into `os.log` framework or to the `OSLog`
///
/// `shared` instance of the LoggerStorage used `.inMemory` storage.
///
/// Init method has required parameter of the ``Storage`` object.
///
/// ```swift
/// let storage = LoggerStorage(storage: Storage.filename("storage.plist")
///
/// storage.addLog(detail: Log(message: message, type: type, category: category ?? "debugging"))
/// ```
///
public final class LoggerStorage {
    
    // MARK: - Public attributes -
	
	/// Shared class instance with in memory storage type
	///
    static let shared = LoggerStorage(storage: .inMemory)
    
    
    // MARK: - Internal -
    private let storage: Storage<LogEntry>
    
    
    // MARK: - Init methods -
	
	/// Init method accepts of the storage with specific type ``Storage``
	///
	/// - Parameter storage: logs storage
	///
    init(storage: Storage<LogEntry>) {
        self.storage = storage
    }
    
    
    // MARK: - Public methods -
	
	/// Method posted log details to the Logger or os.log tool.
	/// Used framework based on the system version.
	///
	/// Accepted parameter is ``Log`` object.
	///
	/// - Parameter detail: log detail
	///
    func addLog(detail: Log) {
        if #available(iOS 15.0, *) {
            postToLogger(detail: detail)
        } else {
            postToOSLog(detail: detail)
        }
    }
	
	/// Method returns collected logs from the storage or device console.
	/// Logs storage depends on the used version.
	/// iOS 15+, all logs loads from the device console.
	/// iOS lower than 15 loads from storage `.inMemory` or `.fileStorage`
	///
	/// - Returns: array of the ``LogEntry`` objects.
	///
    func obtainLogs() -> [LogEntry] {
        
        if #available(iOS 15.0, *) {
            return obtainLogsFromConsole()
        } else {
            return obtainLogsFromStorage()
        }
    }
	
	/// Method deletes all collected logs.
	///
    func removeAllLogs() {
        do {
            try storage.removeAllData()
        } catch let err {
            print("#---- Occurs error on removing log data operation: \(err) ----#")
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
            print("#---- Store log entry data error: \(err) ----#")
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
            print("#---- Error with initializing log store object ----#")
        }
        
        return []
    }
    
    private func obtainLogsFromStorage() -> [LogEntry] {
        do {
            guard let entries = try storage.load() else { return [] }
            
            return entries
        } catch let err {
            print("#---- Load logs data error: \(err) ----#")
        }
        
        return []
    }
}
