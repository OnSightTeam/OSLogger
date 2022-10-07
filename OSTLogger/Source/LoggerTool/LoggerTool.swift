//
//  LoggerTool.swift
//  OSTLogger
//
//  Created by OnSightTeam on 04.10.2022.
//

import Foundation
import UIKit


/// The logger tool main class.
///
/// The class conforms OSTLogger protocol.
/// Class instance used for the posting logs
/// Class instance initiates with two parameters: session and configuration ``LoggerToolConfiguration``.
///
/// Short (default) form:
/// ```swift
/// LoggerTool()
/// ```
///
/// Custom configuration ``LoggerToolConfiguration``:
/// ```swift
/// LoggerTool(configuration: .localConfig)
/// ```
///
/// By default logger tool initialised with `default` configuration.
/// This configuration supports remote logging only.
///
public final class LoggerTool: OSTLogger {
    
    // MARK: - Private properties -
    private var configuration: LoggerToolConfiguration
    
    // MARK: - Initialization -
    
    /// Creates a logger that writes to the default subsystem, local storage and remote cloud.
    ///
    ///  Method has one mandatory parameter is session and one optional is configuration ``LoggerToolConfiguration``.
    ///
    /// - Parameters:
    ///   - configuration: - The logger tool configuration. Used default value `.default` ``LoggerToolConfiguration``
    public init(configuration: LoggerToolConfiguration = .default) {
        self.configuration = configuration
        
		if #available(iOS 13.0, *), configuration.displayCollectedLogs {
           self.registerShakeHandler()
        }
    }
    
    // MARK: - Logger public functions -
    
    public func log(message: String) {
        detailedLog(message: message, type: .info, category: "debugging")
    }
    
    public func detailedLog(message: String, type: LogType, category: String?) {
        let log = Log(message: message, type: type, category: category ?? "debugging")
        
        publishLog(log: log)
    }
    
    public func info(message: String, category: String?) {
        detailedLog(message: message, type: .info, category: category)
    }
    
    public func debug(message: String, category: String?) {
        detailedLog(message: message, type: .debug, category: category)
    }
    
    public func warn(message: String, category: String?) {
        detailedLog(message: message, type: .warn, category: category)
    }
    
    public func error(message: String, category: String?) {
        detailedLog(message: message, type: .error, category: category)
    }
    
    public func fault(message: String, category: String?) {
        detailedLog(message: message, type: .fault, category: category)
    }
    
    public func clear() throws {
        LoggerStorage.shared.removeAllLogs()
    }
    
	//MARK: - Memory management methods -
	
    deinit {
		if configuration.displayCollectedLogs {
			NotificationCenter.default.removeObserver(self)
		}
    }
}

private extension LoggerTool {
	
	private func publishLog(log: Log) {
		
		if self.configuration.allowLoggerStorage {
			LoggerStorage.shared.addLog(detail: log)
		} else {
			print(log.message)
		}
	}
	
	
	/// Subscription on the "Shake" gesture to trigger display collected logs view.
	/// Logs view works only on iOS 13+.
	///
	/// > Important: If used iOS version lower than 15 displayed logs loaded only from current app session,
	/// if 15+ then all collected logs from current and previous app sessions.
	///
	@available(iOS 13.0, *)
	private func registerShakeHandler() {
		NotificationCenter.default.addObserver(self,
											   selector: #selector(presentLogsView),
											   name: UIDevice.deviceDidShakeNotification,
											   object: nil)
	}
	
	@objc private func presentLogsView() {
		if #available(iOS 13.0, *) {
			guard
				let controller = UIApplication.shared.topMostViewController(),
				!(controller is LogViewerController)
			else {
				return
			}
			
			let viewer: LogViewerController = .init()
			
			controller.present(viewer, animated: true)
		}
	}
}
