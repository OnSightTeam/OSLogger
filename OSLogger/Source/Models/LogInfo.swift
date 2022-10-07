//
//  LogInfo.swift
//  Logger
//

import Foundation
import UIKit

/// @author Nikolay Chaban
///
/// Log struct.
/// Object contains posted log data.
/// Log object is codable.
///
public struct Log: Codable {
	
	/// Text message reported to the log.
    public let message: String
	
	/// ``LogType`` enum string value of the type log `.error`, `.info`, etc.
    public let type: LogType
	
	/// String parameter used for filtering posted logs by specific category. Example: "http-requests", "home-screen", etc.
    public let category: String
}

extension Log {
	
	/// Representation log object into dictionary.
	/// Maybe used for posting to th server API or saving to the `plist` файл.
	///
    var toDictionary: [String: Any] {
        return [
        "message": message,
        "type": type.rawValue,
        "category": category
        ]
    }
}

extension Log {
	
	/// UIColor value based on the log type
	///
	/// Default color `.lightGrey`
	///
    var color: UIColor {
        switch type {
        case .info: return .gray
        case .warn: return .yellow
        case .error: return .orange
        case .fault: return .red
        default:
            return .lightGray
        }
    }
}
