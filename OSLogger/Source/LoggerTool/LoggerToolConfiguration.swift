//
//  LoggerToolConfiguration.swift
//  OSLogger
//

import Foundation


/// The logger tool configuration
///
/// The configuration used for enable and disable main features in ``OSLogger`` framework.
/// Configuration is necessary parameter of initialisation of ``LoggerTool``
/// Init method parameter used ``default`` config.
///
/// > Important: Configuration used as on-demand dependencies and can't be changed after framework instance initialised.
///
/// Developer may use one of predefined configuration.
/// There is three option: ``default``, ``debugConfig``
///
/// Configuration | Description
/// --- | ---
/// `default` | The configuration used for remote logging only.
/// `debugConfig` | The enables all main features of framework
/// `localConfig` | The enables local logging features only. Remote logging doesn't work on this config
///
///
/// Configuration usage example:
/// ```swift
/// LoggerTool(configuration: .debugConfig)
/// ```
public struct LoggerToolConfiguration {
    
    /// The attbibute enable local logger.
    /// Framework logs to the device console and logger storage: inMemory or onDisk
	/// Collected data may be used in logs view
    let allowLoggerStorage: Bool
    
    /// Attribute used for registering shake gesture notification.
    /// Shake gesture presents display collected logs list components
    let displayCollectedLogs: Bool
}

public extension LoggerToolConfiguration {
    
    /// Predefined configuration used by default in init method of ``LoggerTool``
    /// Configuration enabled remote logging only.
    static let `default` = LoggerToolConfiguration(allowLoggerStorage: false,
                                                   displayCollectedLogs: false)
    
    /// Configuration activates all main features in ``OSLogger`` framework
    /// Configuration can be used by developer team.
    /// Configuration will be disabled in release version.
    static let debugConfig = LoggerToolConfiguration(allowLoggerStorage: true,
                                                     displayCollectedLogs: true)
}
