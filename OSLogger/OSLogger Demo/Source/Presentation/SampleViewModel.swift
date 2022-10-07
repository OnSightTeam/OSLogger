//
//  SampleViewModel.swift
//  Sample
//

import Foundation
import UIKit
import OSLogger

class SampleViewModel: NSObject {
    
    // MARK: - Public properties -
    
    var addLogDetail: ((TestLogType) -> Void)?
    
    
    // MARK: - Private properties -
    
    private lazy var content: [SampleItem] = {
        return [
            SampleItem(title: "Standard log", type: .default),
            SampleItem(title: "Info log", type: .info),
            SampleItem(title: "Debug log", type: .debug),
            SampleItem(title: "Warning log", type: .warning),
            SampleItem(title: "Error log", type: .error),
            SampleItem(title: "Fault log", type: .fault),
            SampleItem(title: "Add custom log", type: .customLog),
            SampleItem(title: "Add custom log with category", type: .customCategoryLog)
        ]
    }()
    
    private var logger: LoggerTool?
    
    // MARK: - Init methods -

    override init() {
        super.init()
        self.setupLoggerTool(with: .debug)
    }
    
    
    // MARK: - Public methods -
    
    func addCustomLog(message: String, category: String = "") {
        logger?.detailedLog(message: message, type: .info, category: category)
    }
    
    
	/// The method reset logger tool instance and creates new one.
	///
    /// > Important: If test device system lower than iOS 15 logs may lost
    ///
	/// - Parameter type: The new logger config type
    ///
    func changeLoggerConfig(type: LoggerConfigType) {
        setupLoggerTool(with: type)
    }

    
    // MARK: - Action methods -

    @IBAction func didClickClear(_ sender: UIBarButtonItem) {
        do {
            try self.logger?.clear()
        } catch let err {
            print("Occurs error during removing logs: \(err)")
        }
    }
    
    // MARK: - Internal methods -
    func setupLoggerTool(with type: LoggerConfigType) {
		switch type {
			case .`default`:
				logger = LoggerTool(configuration: .default)
			case .debug:
				logger = LoggerTool(configuration: .debugConfig)
		}
    }
}

extension SampleViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        content.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "LogCellID")
        
        var cellContent = cell.defaultContentConfiguration()
        
        cellContent.text = content[indexPath.row].title
        
        cell.contentConfiguration = cellContent
        
        return cell
    }
}

extension SampleViewModel: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = content[indexPath.row]
        
        switch item.type {
            
        case .default:
            logger?.log(message: "Default log message")
        case .customLog,
             .customCategoryLog:
            addLogDetail?(item.type)
        case .info:
            logger?.info(message: "Info log", category: nil)
        case .debug:
            logger?.debug(message: "Debug log", category: nil)
        case .warning:
            logger?.warn(message: "Warning log", category: "warning")
        case .error:
            logger?.error(message: "Error log", category: "error")
        case .fault:
            logger?.fault(message: "Fault error log", category: "fault")
        }
    }
}
