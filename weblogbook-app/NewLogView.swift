import SwiftUI

struct NewLogView: View {
    @Environment(SettingsStore.self) private var settings
    @Environment(\.dismiss) private var dismiss

    let onSuccess: (String) -> Void

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
                                .onChange(of: departurePlace, {
                                    departurePlace = String(departurePlace.prefix(4))
                                })
                            Divider()
                            TextField("HHmm", text: $departureTime)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 60)
                                .onChange(of: departureTime, {
                                    departureTime = String(departureTime.prefix(4))
                                })
                        }
                    }
                    LabeledContent("Arrival") {
                        HStack {
                            TextField("ICAO", text: $arrivalPlace)
                                .textInputAutocapitalization(.characters)
                                .autocorrectionDisabled()
                                .multilineTextAlignment(.trailing)
                                .onChange(of: arrivalPlace, {
                                    arrivalPlace = String(arrivalPlace.prefix(4))
                                })
                            Divider()
                            TextField("HHmm", text: $arrivalTime)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 60)
                                .onChange(of: arrivalTime, {
                                    arrivalTime = String(arrivalTime.prefix(4))
                                })
                        }
                    }
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }
                
                Section("Landings") {
                    Stepper("Day: \(landingsDay)",   value: $landingsDay,   in: 0...99)
                    Stepper("Night: \(landingsNight)", value: $landingsNight, in: 0...99)
                }

                Section("Flight details") {
                    TextField("Aircraft type", text: $aircraftModel)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.characters)
                    TextField("Aircraft registration", text: $aircraftReg)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.characters)
                    TextField("PIC name", text: $picName)
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

                Section("Simulator") {
                    TextField("Type", text: $simType)
                    timeRow("Time", $simTime, auto: false)
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
    private func timeRow(_ label: String, _ binding: Binding<String>, auto: Bool = true) -> some View {
        LabeledContent(label) {
            HStack(spacing: 20) {
                TextField("HH:mm", text: binding)
                    .keyboardType(.numbersAndPunctuation)
                    .multilineTextAlignment(.trailing)
                    .autocorrectionDisabled()
                    .onChange(of: binding.wrappedValue) { _, new in
                        let digits = String(new.filter(\.isNumber).prefix(4))
                        let formatted: String = switch digits.count {
                        case 3:  String(digits.prefix(1)) + ":" + String(digits.suffix(2))
                        case 4:  String(digits.prefix(2)) + ":" + String(digits.suffix(2))
                        default: digits
                        }
                        if formatted != new { binding.wrappedValue = formatted }
                    }
                
                if(auto) {
                    Button { autoFillTime(binding) } label: {
                        Image(systemName: "wand.and.sparkles")
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(.secondary)
                    
                }
            }
        }
    }

    private func autoFillTime(_ binding: Binding<String>) {
        guard departureTime.count == 4, arrivalTime.count == 4,
              let depH = Int(departureTime.prefix(2)),
              let depM = Int(departureTime.suffix(2)),
              let arrH = Int(arrivalTime.prefix(2)),
              let arrM = Int(arrivalTime.suffix(2)) else { return }

        let depMinutes = depH * 60 + depM
        var arrMinutes = arrH * 60 + arrM
        if arrMinutes < depMinutes { arrMinutes += 24 * 60 }

        let diff = arrMinutes - depMinutes
        binding.wrappedValue = String(format: "%d:%02d", diff / 60, diff % 60)
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
            let uuid = try await LogbookService(settings: settings).createLog(request)
            dismiss()
            onSuccess(uuid)
        } catch {
            submitError = error.localizedDescription
        }
    }
}

#Preview {
    NewLogView(onSuccess: { _ in })
        .environment(SettingsStore())
}
