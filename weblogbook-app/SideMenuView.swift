import SwiftUI

struct SideMenuView: View {
    @Environment(AppState.self) private var appState
    @Environment(SettingsStore.self) private var settings

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if settings.isConnected {
                VStack(alignment: .leading, spacing: 4) {
                    Text(settings.ownerName.isEmpty ? "Pilot" : settings.ownerName)
                        .font(.headline)
                    if !settings.licenseNumber.isEmpty {
                        Text(settings.licenseNumber)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 16)
                Divider()
            }
            ForEach(AppSection.allCases, id: \.self) { section in
                Button {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        appState.selectedSection = section
                        appState.isMenuOpen = false
                    }
                } label: {
                    HStack(spacing: 14) {
                        Image(systemName: section.icon)
                            .frame(width: 24)
                        Text(section.title)
                        Spacer()
                    }
                    .font(appState.selectedSection == section ? .body.bold() : .body)
                    .foregroundStyle(appState.selectedSection == section ? Color.accentColor : Color.primary)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                }
            }
            Spacer()
        }
        .frame(width: 280)
        .frame(maxHeight: .infinity)
        .background(Color(.systemBackground))
        .shadow(color: .black.opacity(0.12), radius: 8, x: 4)
    }
}
