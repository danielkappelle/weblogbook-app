import SwiftUI

struct NewPersonView: View {
    @Environment(SettingsStore.self) private var settings
    @Environment(\.dismiss) private var dismiss

    let onSuccess: () -> Void

    @State private var firstName = ""
    @State private var middleName = ""
    @State private var lastName = ""
    @State private var phone = ""
    @State private var email = ""
    @State private var remarks = ""
    @State private var isSubmitting = false
    @State private var submitError: String?

    private var nameIsEmpty: Bool { firstName.isEmpty && lastName.isEmpty }

    var body: some View {
        NavigationStack {
            Form {
                Section("Name") {
                    TextField("First name", text: $firstName)
                        .autocorrectionDisabled()
                    TextField("Middle name", text: $middleName)
                        .autocorrectionDisabled()
                    TextField("Last name", text: $lastName)
                        .autocorrectionDisabled()
                }

                Section("Contact") {
                    TextField("Phone", text: $phone)
                        .keyboardType(.phonePad)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                }

                Section("Remarks") {
                    TextField("Remarks", text: $remarks, axis: .vertical)
                }

                if let error = submitError {
                    Section {
                        Text(error)
                            .foregroundStyle(.red)
                            .font(.footnote)
                    }
                }
            }
            .navigationTitle("New person")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task { await submit() }
                    } label: {
                        if isSubmitting {
                            ProgressView()
                        } else {
                            Text("Submit")
                        }
                    }
                    .disabled(isSubmitting || nameIsEmpty)
                }
            }
        }
    }

    private func submit() async {
        isSubmitting = true
        submitError = nil
        defer { isSubmitting = false }

        let request = NewPersonRequest(
            firstName: firstName, middleName: middleName, lastName: lastName,
            phone: phone, email: email, remarks: remarks
        )

        do {
            try await LogbookService(settings: settings).createPerson(request)
            dismiss()
            onSuccess()
        } catch {
            submitError = error.localizedDescription
        }
    }
}

#Preview {
    NewPersonView(onSuccess: {})
        .environment(SettingsStore())
}
