//
//  LogViewer.swift
//  OSLogger
//

import SwiftUI

@available(iOS 13.0, *)
final class LogViewModel: ObservableObject {
    
    @Published var entries: [LogEntry] = []
    
    init() {
        entries = LoggerStorage.shared.obtainLogs()
    }
}

@available(iOS 13.0, *)
struct LogViewer: View {
    
    @ObservedObject var viewModel = LogViewModel()
    
    var body: some View {
        NavigationView {
            if #available(iOS 14.0, *) {
                List(viewModel.entries) { entry in
                    LogEntryRow(entry: entry)
                }
                .listStyle(PlainListStyle())
                .navigationTitle("Logs")
            } else {
                List(viewModel.entries) { entry in
                    LogEntryRow(entry: entry)
                }
                .listStyle(PlainListStyle())
                .navigationBarTitle(Text("Logs"))
            }
        }
    }
}

@available(iOS 13.0, *)
struct LogEntryRow: View {
    let entry: LogEntry
    
    var body: some View {
        HStack {
            Color(entry.color)
                .frame(width: 4)
            
            VStack(spacing: 12) {
                HStack {
                    Text(entry.date)
                    Spacer()
                    Text(entry.category)
                }
                .foregroundColor(Color.secondary)
                
                Text(entry.message)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.body)
            }
            .font(.caption)
        }
    }
}

@available(iOS 13.0, *)
class LogViewerController: UIHostingController<LogViewer> {
    init() {
        super.init(rootView: LogViewer())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
