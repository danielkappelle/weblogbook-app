import SwiftUI

struct NewLogView: View {
    @Environment(SettingsStore.self) private var settings
    @Environment(\.dismiss) private var dismiss

    let onSuccess: () -> Void

    @State private var date = Date()
    @State private var departurePlace = ""
    @State private var departureTime = ""
    @State private var arrivalPlace = ""
    @State private var arrivalTime = ""
    @State private var aircraftModel = ""
    @State private var aircraftReg = ""
    @State private var picName = ""
    @State private var remarks = ""
    @State private var totalTime = ""
    @State private var seTime = ""
    @State private var meTime = ""
    @State private var mccTime = ""
    @State private var nightTime = ""
    @State private var ifrTime = ""
    @State private var picTime = ""
    @State private var coPilotTime = ""
    @State private var dualTime = ""
    @State private var instructorTime = ""
    @State private var landingsDay = 0
    @State private var landingsNight = 0
    @State private var simType = ""
    @State private var simTime = ""
    @State private var isSubmitting = false
    @State private var submitError: String?

    var body: some View {
        NavigationStack {
            Form {
                Section("Route") {
                    LabeledContent("Departure") {
                        HStack {
                            TextField("ICAO", text: $departurePlace)
                                .textInputAutocapitalization(.characters)
                                .autocorrectionDisabled()
                                .multilineTextAlignment(.trailing)
                            Divider()
                            TextField("HHmm", text: $departureTime)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 60)
                        }
                    }
                    LabeledContent("Arrival") {
                        HStack {
                            TextField("ICAO", text: $arrivalPlace)
                                .textInputAutocapitalization(.characters)
                                .autocorrectionDisabled()
                                .multilineTextAlignment(.trailing)
                            Divider()
                            TextField("HHmm", text: $arrivalTime)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 60)
                        }
                    }
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }

                Section("Aircraft") {
                    TextField("Type", text: $aircraftModel)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.characters)
                    TextField("Registration", text: $aircraftReg)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.characters)
                }

                Section("Pilot") {
                    TextField("PIC name", text: $picName)
                    TextField("Remarks", text: $remarks)
                }

                Section("Flight time") {
                    timeRow("Total",       $totalTime)
                    timeRow("Single engine", $seTime)
                    timeRow("Multi engine",  $meTime)
                    timeRow("MCC",         $mccTime)
                    timeRow("Night",       $nightTime)
                    timeRow("IFR",         $ifrTime)
                    timeRow("PIC",         $picTime)
                    timeRow("Co-pilot",    $coPilotTime)
                    timeRow("Dual",        $dualTime)
                    timeRow("Instructor",  $instructorTime)
                }

                Section("Landings") {
                    Stepper("Day: \(landingsDay)",   value: $landingsDay,   in: 0...99)
                    Stepper("Night: \(landingsNight)", value: $landingsNight, in: 0...99)
                }

                Section("Simulator") {
                    TextField("Type", text: $simType)
                    timeRow("Time", $simTime)
                }

                if let error = submitError {
                    Section {
                        Text(error)
                            .foregroundStyle(.red)
                            .font(.footnote)
                    }
                }
            }
            .navigationTitle("New log")
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
                    .disabled(isSubmitting)
                }
            }
        }
    }

    @ViewBuilder
    private func timeRow(_ label: String, _ binding: Binding<String>) -> some View {
        LabeledContent(label) {
            TextField("HH:mm", text: binding)
                .keyboardType(.numbersAndPunctuation)
                .multilineTextAlignment(.trailing)
                .autocorrectionDisabled()
        }
    }

    private func submit() async {
        isSubmitting = true
        submitError = nil
        defer { isSubmitting = false }

        let request = NewLogRequest(
            date: date,
            departurePlace: departurePlace, departureTime: departureTime,
            arrivalPlace: arrivalPlace,     arrivalTime: arrivalTime,
            aircraftModel: aircraftModel,   aircraftReg: aircraftReg,
            totalTime: totalTime, seTime: seTime, meTime: meTime, mccTime: mccTime,
            nightTime: nightTime, ifrTime: ifrTime, picTime: picTime,
            coPilotTime: coPilotTime, dualTime: dualTime, instructorTime: instructorTime,
            landingsDay: landingsDay, landingsNight: landingsNight,
            simType: simType, simTime: simTime,
            picName: picName, remarks: remarks
        )

        do {
            try await LogbookService(settings: settings).createLog(request)
            dismiss()
            onSuccess()
        } catch {
            submitError = error.localizedDescription
        }
    }
}

#Preview {
    NewLogView(onSuccess: {})
        .environment(SettingsStore())
}
