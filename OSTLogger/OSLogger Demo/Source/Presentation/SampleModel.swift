//
//  SampleModel.swift
//  Sample
//
//  Created by admin on 31.05.2022.
//

import Foundation

struct SampleItem {
    let title: String
    let type: TestLogType
}

enum TestLogType {
case `default`, info, debug, warning, error, fault, customLog, customCategoryLog
}

enum LogDetailType: Int {
case message = 0, category
}

enum LoggerConfigType {
    case `default`, debug
}
