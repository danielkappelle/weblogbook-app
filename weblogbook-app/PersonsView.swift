import SwiftUI

struct PersonsView: View {
    @Environment(AppState.self) private var appState
    @Environment(SettingsStore.self) private var settings
    @State private var persons: [Person] = []
    @State private var error: Error?

    var body: some View {
        NavigationStack {
            List(persons) { person in
                VStack(alignment: .leading, spacing: 2) {
                    Text(person.fullName)
                    if !person.email.isEmpty {
                        Text(person.email)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .listStyle(.plain)
            .overlay {
                if persons.isEmpty && error == nil {
                    ContentUnavailableView("No persons", systemImage: "person.2")
                }
            }
            .refreshable { await load() }
            .alert("Failed to load persons", isPresented: Binding(
                get: { error != nil },
                set: { if !$0 { error = nil } }
            )) {
                Button("Retry") { Task { await load() } }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text(error?.localizedDescription ?? "")
            }
            .navigationTitle("Persons")
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
            }
        }
        .task { await load() }
    }

    private func load() async {
        do {
            persons = try await LogbookService(settings: settings).fetchPersons()
            error = nil
        } catch {
            self.error = error
        }
    }
}

#Preview {
    PersonsView()
        .environment(AppState())
        .environment(SettingsStore())
}
