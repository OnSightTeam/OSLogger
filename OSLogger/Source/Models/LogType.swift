//
//  LogType.swift
//  Logger
//

import Foundation


/// Log type enumeration.
/// Enum contains string values.
///
/// Type defines type of the logged object.
/// Based on type log can be filtered in device console or logs view.
///
public enum LogType: String, Codable, CaseIterable {
	
	/// Type defines for infromative log message.
	/// It shouldn't be used for the important information.
	///
    case info = "INFO"
	
	/// Type defines for information important only during development time.
	///
    case debug = "DEBUG"
	
	/// Type defines for important message but not critical.
	///
    case warn = "WARNING"
	
	/// Type defines for critical message but not fatal.
	/// All errors must be marked by `.error` type.
	///
    case error = "ERROR"
	
	/// Type defines for the most critical information.
	/// If code may cause crash or unexpected behavior message must be marked by this type.
    case fault = "FAULT"
}
