//
//  Storage.swift
//  Logger
//

import Foundation

/// @author Nikolay Chaban
///
/// Logs storage with generic type
/// Implemented as struct for convenient initialization and use variables instead of methods.
///
/// <T> - generic type of the log entry struct.
/// Struct contains all required information of the log information.
///
struct Storage<T> {
	
	/// @author Nikolay Chaban
	///
	/// Property returns all stored logs.
	/// Property type: Array<T>
	///
    var load: () throws -> [T]?
	
	/// @author Nikolay Chaban
	///
	/// Property stored log object to the defined storage
	/// Process throws FileManager errors.
	///
    var save: (_ object: T) throws -> Void
	
	
	/// @author Nikolay Chaban
	///
	/// Property removed all stored logs
	/// Process throws FileManager errors.
	///
    var removeAllData: () throws -> Void
}

extension Storage {
	
	/// @author Nikolay Chaban
	///
	/// In memory log storage.
	///
	/// ```swift
	/// let storage: Storage<LogEntry> = .inMemory
	/// ```
	///
	/// > Important: All stored logs lost after the app termination. If logged records have to be exported use file storage solution.
	///
    static var inMemory: Self {
        var cache: [T]? = []
        return .init(
            load: { cache },
            save: { object in
                cache?.append(object)
            },
            removeAllData: { cache?.removeAll() }
        )
    }
}

extension Storage where T: Codable {
	
	/// @author Nikolay Chaban
	///
	/// Method initialized file storage.
	/// Required parameter is file name where all logs recorded.
	///
	/// Logs file stored in "Cache directory" from Library folder.
	///
	/// ```swift
	/// let fileStorage: Storage<LogEntry> = Storage.filename('logRecords.plist')
	/// ```
	///
	/// - Parameter filename: string file name
	/// - Returns: file storage object
    static func filename(_ filename: String) -> Self {
        let encoder: JSONEncoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        let decoder: JSONDecoder = JSONDecoder()
        
        let storageURL = storageURL(filename: filename)
        var content: [T]? = []
        
        return .init(
            load: {
                guard FileManager.default.fileExists(atPath: storageURL.path) else { return nil }
                let data = try Data(contentsOf: storageURL)
                return try decoder.decode([T].self, from: data)
            },
            save: { object in
                content?.append(object)
                try ensureDirectoryExists(storageURL: storageURL)
                let data = try encoder.encode(content)
                try data.write(to: storageURL)
            },
            removeAllData: {
                try FileManager.default.removeItem(at: storageURL)
                content?.removeAll()
            }
        )
    }
}

private extension Storage {
	
	private static func storageURL(filename: String) -> URL {
		return FileManager.cacheDirectoryURL.appendingPathComponent(filename)
	}
	
	private static func ensureDirectoryExists(storageURL: URL) throws {
		let dir = storageURL.deletingLastPathComponent()
		
		if !FileManager.default.fileExists(atPath: dir.path) {
			try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true, attributes: nil)
		}
	}
}
