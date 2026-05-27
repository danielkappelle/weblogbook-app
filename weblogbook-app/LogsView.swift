import SwiftUI

struct LogsView: View {
    @Environment(AppState.self) private var appState
    @Environment(SettingsStore.self) private var settings
    @State private var logs: [LogEntry] = []
    @State private var navigationPath: [LogEntry] = []
    @State private var error: Error?
    @State private var offline = false
    @State private var showingNewLog = false

    var body: some View {
        NavigationStack(path: $navigationPath) {
            List(logs) { entry in
                NavigationLink(value: entry) {
                    LogEntryCard(entry: entry)
                }
                .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
            }
            .navigationDestination(for: LogEntry.self) { entry in
                LogDetailView(entry: entry)
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
                    Button { showingNewLog = true } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            if offline {
                HStack(spacing: 6) {
                    Image(systemName: "wifi.slash")
                    Text("You're offline – showing cached data")
                        .font(.footnote)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(.regularMaterial)
                .foregroundStyle(.secondary)
            }
        }
        .sheet(isPresented: $showingNewLog) {
            NewLogView(onSuccess: { uuid in
                Task {
                    await load()
                    if let entry = logs.first(where: { $0.id.uuidString.lowercased() == uuid.lowercased() }) {
                        navigationPath = [entry]
                    }
                }
            })
            .environment(settings)
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
            self.offline = false
        } catch LogbookServiceError.offline {
            self.offline = true
        }
        catch {
            self.error = error
        }
    }
}

#Preview {
    LogsView()
        .environment(AppState())
        .environment(SettingsStore())
}
