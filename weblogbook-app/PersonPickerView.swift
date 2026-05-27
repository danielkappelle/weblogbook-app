import SwiftUI

struct PersonPickerView: View {
    @Environment(SettingsStore.self) private var settings
    @Environment(\.dismiss) private var dismiss

    let onAdd: (Person, String) -> Void

    @State private var allPersons: [Person] = []
    @State private var searchText = ""
    @State private var selectedPerson: Person?
    @State private var role = ""
    @State private var showingNewPerson = false

    private var filteredPersons: [Person] {
        guard !searchText.isEmpty else { return allPersons }
        return allPersons.filter { $0.fullName.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        NavigationStack {
            if let person = selectedPerson {
                roleEntryView(for: person)
            } else {
                personListView
            }
        }
        .task {
            allPersons = (try? await LogbookService(settings: settings).fetchPersons()) ?? []
        }
        .sheet(isPresented: $showingNewPerson) {
            NewPersonView(onSuccess: {
                Task {
                    allPersons = (try? await LogbookService(settings: settings).fetchPersons()) ?? []
                }
            })
            .environment(settings)
        }
    }

    private var personListView: some View {
        List {
            ForEach(filteredPersons) { person in
                Button {
                    selectedPerson = person
                    role = ""
                } label: {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(person.fullName)
                            .foregroundStyle(.primary)
                        if !person.email.isEmpty {
                            Text(person.email)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .listStyle(.plain)
        .searchable(text: $searchText, prompt: "Search persons")
        .overlay {
            if allPersons.isEmpty {
                ContentUnavailableView("No persons", systemImage: "person.2")
            }
        }
        .navigationTitle("Add person")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") { dismiss() }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("New person") { showingNewPerson = true }
            }
        }
    }

    @ViewBuilder
    private func roleEntryView(for person: Person) -> some View {
        Form {
            Section("Person") {
                Text(person.fullName)
            }
            Section("Role") {
                TextField("e.g. PIC, Co-pilot", text: $role)
                    .autocorrectionDisabled()
            }
        }
        .navigationTitle("Set role")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Back") { selectedPerson = nil }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add") {
                    onAdd(person, role)
                    dismiss()
                }
                .disabled(role.isEmpty)
            }
        }
    }
}

#Preview {
    PersonPickerView(onAdd: { _, _ in })
        .environment(SettingsStore())
}
