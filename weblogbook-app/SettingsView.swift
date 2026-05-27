import SwiftUI

struct SettingsView: View {
    @Environment(AppState.self) private var appState
    @Environment(SettingsStore.self) private var settings

    @State private var password = ""
    @State private var isConnecting = false
    @State private var connectError: String?

    var body: some View {
        @Bindable var settings = settings
        NavigationStack {
            List {
                Section("Server") {
                    TextField("https://your-server.com/api/", text: $settings.apiBaseURL)
                        .keyboardType(.URL)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                }

                Section("Account") {
                    Toggle("Requires authentication", isOn: $settings.requiresAuth)

                    if settings.requiresAuth {
                        TextField("Username", text: $settings.username)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)

                        SecureField("Password", text: $password)
                    }

                    Button {
                        Task { await connect() }
                    } label: {
                        HStack {
                            Text("Connect")
                            Spacer()
                            if isConnecting { ProgressView() }
                        }
                    }
                    .disabled(isConnecting
                        || settings.apiBaseURL.isEmpty
                        || (settings.requiresAuth && (settings.username.isEmpty || password.isEmpty)))

                    if let error = connectError {
                        Text(error)
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                }

                if settings.isConnected {
                    Section {
                        HStack {
                            Text("Status")
                            Spacer()
                            Text("Connected")
                                .foregroundStyle(.secondary)
                        }
                        if !settings.apiVersion.isEmpty {
                            HStack {
                                Text("Version")
                                Spacer()
                                Text(settings.apiVersion)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        Button("Disconnect", role: .destructive) {
                            settings.disconnect()
                        }
                    }
                }
            }
            .navigationTitle("Settings")
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
    }

    private func connect() async {
        isConnecting = true
        connectError = nil
        defer { isConnecting = false }

        do {
            let svc = LogbookService(settings: settings)
            if settings.requiresAuth {
                let token = try await svc.login(username: settings.username, password: password)
                settings.accessToken = token
                password = ""
            }
            let serverSettings = try await svc.fetchServerSettings()
            settings.ownerName     = serverSettings.ownerName
            settings.licenseNumber = serverSettings.licenseNumber
            settings.apiVersion    = (try? await svc.fetchVersion()) ?? ""
            settings.isConnected   = true
        } catch {
            connectError           = error.localizedDescription
            settings.ownerName     = ""
            settings.licenseNumber = ""
            settings.isConnected   = false
        }
    }
}

#Preview {
    SettingsView()
        .environment(AppState())
        .environment(SettingsStore())
}
