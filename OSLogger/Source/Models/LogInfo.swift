//
//  LogInfo.swift
//  Logger
//

import Foundation
import UIKit

public struct Log: Codable {
    public let message: String
    public let type: LogType
    public let category: String
}

extension Log {
    
    var toDictionary: [String: Any] {
        return [
        "message": message,
        "type": type.rawValue,
        "category": category
        ]
    }
}

extension Log {
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
