//
//  LogEntry.swift
//  OSTLogger
//
//  Created by OnSightTeam on 04.10.2022.
//

import Foundation
import UIKit

/// Custom log color struct
///
struct LogColor: Codable {
    var red: CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0, alpha: CGFloat = 0.0
    
    var uiColor: UIColor {
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    init(uiColor: UIColor) {
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    }
}

/// Stored log entry information is presented in Log entry objects.
///
struct LogEntry: Identifiable {
	
	/// unique log id
	///
    var id = UUID()
	
	/// posted log date
	///
    let date: String
	
	/// Posted log specific category
	///
    let category: String
	
	/// Posted log message.
	///
    let message: String
	
	/// Posted log color.
	/// It's optional value and maybe defined based on the log type
	/// 
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
