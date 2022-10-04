//
//  LogEntry.swift
//  OSLogger
//
//  Created by OnSightTeam on 04.10.2022.
//

import Foundation
import UIKit

struct LogColor: Codable {
    var red: CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0, alpha: CGFloat = 0.0
    
    var uiColor: UIColor {
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    init(uiColor: UIColor) {
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    }
}

struct LogEntry: Identifiable {
    var id = UUID()
    let date: String
    let category: String
    let message: String
    let color: UIColor
}

extension LogEntry: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case date
        case category
        case message
        case color
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        date = try container.decode(String.self, forKey: .date)
        category = try container.decode(String.self, forKey: .category)
        message = try container.decode(String.self, forKey: .message)
        color = try container.decode(LogColor.self, forKey: .color).uiColor
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(date, forKey: .date)
        try container.encode(category, forKey: .category)
        try container.encode(message, forKey: .message)
        try container.encode(LogColor(uiColor: color), forKey: .color)
    }
}
