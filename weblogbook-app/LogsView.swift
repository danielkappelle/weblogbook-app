import SwiftUI

struct LogsView: View {
    @Environment(AppState.self) private var appState
    @Environment(SettingsStore.self) private var settings
    @State private var logs: [LogEntry] = []
    @State private var error: Error?

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
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            appState.isMenuOpen = true
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .task {
            logs = LogCache.load() ?? []
            await load()
        }
    }

    private func load() async {
        do {
            let fetched = try await LogbookService(settings: settings).fetchLogs()
            logs = fetched
            LogCache.save(fetched)
            error = nil
        } catch {
            self.error = error
        }
    }
}

#Preview {
    LogsView()
        .environment(AppState())
        .environment(SettingsStore())
}
