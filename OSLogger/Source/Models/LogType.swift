//
//  LogType.swift
//  Logger
//

import Foundation

// TODO: - add documentation -
public enum LogType: String, Codable, CaseIterable {
    case info = "INFO"
    case debug = "DEBUG"
    case warn = "WARNING"
    case error = "ERROR"
    case fault = "FAULT"
}
