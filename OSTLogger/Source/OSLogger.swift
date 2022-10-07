//
//  OSTLogger.swift
//  OSTLogger
//

import Foundation

/// Logger tool interface
///
/// Protocol declares public logger framework methods
///
/// Simple log message:
/// ```swift
/// logger.info(message: "Log message")
/// ```
///
/// Message in specific log category
/// ```swift
/// logger.error(message: "Error message", category: "http-requests")
/// ```
public protocol OSTLogger {
    
    /// Default log message with `info` type and with empty category value.
    ///
    /// Use this method for simple log case.
    ///
    /// - Parameter message: The fully formatted message for the entry.
    func log(message: String)
    
    /// Most custom log method. Method customized log type and category.
    ///
    /// Type unified all log messages and also used for system logs as level. Types enum ``LogType``.
    /// The category string identifies a particular component or module.
    ///
    /// - Parameters:
    ///   - message: The fully formatted message for the entry.
    ///   - type: The log unified level.
    ///   - category: The log category name.
    func detailedLog(message: String, type: LogType, category: String?)
    
    /// The INFO type log message and with optional category value.
    ///
    /// Standard informative log. Use it for events, actions, navigations, etc.
    ///
    /// - Parameters:
    ///   - message: The fully formatted message for the entry.
    ///   - category: The log category name.
    func info(message: String, category: String?)
    
    /// The DEBUG type log message and with optional category value.
    ///
    /// Use this method to write messages with the ``LogType`` log level to the in-memory log store only.
    ///
    /// - Parameters:
    ///   - message: The fully formatted message for the entry.
    ///   - category: The log category name.
    func debug(message: String, category: String?)
    
    
    /// Writes information about a warning to the log.
    ///
    /// Use this method to log important information what needs more attention than in `info`.
    ///
    /// - Parameters:
    ///   - message: The fully formatted message for the entry.
    ///   - category: The log category name.
    func warn(message: String, category: String?)
    
    /// Writes information about an error to the log.
    ///
    /// Use this method to log error is seen during flow execution.
    /// All errors are displayed in popups or returns from the server to the user.
    /// Do not use it for errors caused flow blocker.
    ///
    /// - Parameters:
    ///   - message: The fully formatted message for the entry.
    ///   - category: The log category name.
    func error(message: String, category: String?)
    
    
    /// Writes a message to the log about a bug that occurs when your app executes.
    ///
    /// Essential bug in SDK.
    /// This type of log is used when blockers in SDK flow.
    ///
    /// - Parameters:
    ///   - message: The fully formatted message for the entry.
    ///   - category: The log category name.
    func fault(message: String, category: String?)
    
    
    /// Remove all persisted log information in memory or from the disk.
    ///
    /// Important to use this method before starting new identification session
    /// otherwise log messages can be mixed up and do not display clear picture of processes
    /// The method may throw `FileSystem` remove file error.
    func clear() throws
}
