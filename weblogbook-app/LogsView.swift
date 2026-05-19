import SwiftUI

struct LogsView: View {
    @State private var logs: [LogEntry] = []
    @State private var error: Error?
    private let service = LogbookService()

    var body: some View {
        NavigationStack {
            List(logs) { entry in
                NavigationLink(destination: LogDetailView(entry: entry)) {
                    LogEntryCard(entry: entry)
                }
                .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
            }
            .listStyle(.plain)
            .overlay {
                if logs.isEmpty && error == nil {
                    ContentUnavailableView("No logs", systemImage: "book.closed")
                }
            }
            .refreshable { await load() }
            .alert("Failed to load logs", isPresented: Binding(
                get: { error != nil },
                set: { if !$0 { error = nil } }
            )) {
                Button("Retry") { Task { await load() } }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text(error?.localizedDescription ?? "")
            }
            .navigationTitle("Logs")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .task { await load() }
    }

    private func load() async {
        do {
            logs = try await service.fetchLogs()
            error = nil
        } catch {
            self.error = error
        }
    }
}

#Preview {
    LogsView()
}
