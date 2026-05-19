import SwiftUI

struct SettingsView: View {
    @Environment(AppState.self) private var appState
    @Environment(SettingsStore.self) private var settings

    @State private var password = ""
    @State private var isLoggingIn = false
    @State private var loginError: String?

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
                    TextField("Username", text: $settings.username)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)

                    SecureField("Password", text: $password)

                    Button {
                        Task { await login() }
                    } label: {
                        HStack {
                            Text("Log in")
                            Spacer()
                            if isLoggingIn {
                                ProgressView()
                            }
                        }
                    }
                    .disabled(isLoggingIn || settings.username.isEmpty || password.isEmpty || settings.apiBaseURL.isEmpty)

                    if let error = loginError {
                        Text(error)
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                }

                if settings.isLoggedIn {
                    Section {
                        HStack {
                            Text("Status")
                            Spacer()
                            Text("Logged in")
                                .foregroundStyle(.secondary)
                        }
                        Button("Log out", role: .destructive) {
                            settings.logout()
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

    private func login() async {
        isLoggingIn = true
        loginError = nil
        defer { isLoggingIn = false }

        do {
            let token = try await LogbookService(settings: settings).login(
                username: settings.username,
                password: password
            )
            settings.accessToken = token
            password = ""
        } catch {
            loginError = error.localizedDescription
        }
    }
}

#Preview {
    SettingsView()
        .environment(AppState())
        .environment(SettingsStore())
}
