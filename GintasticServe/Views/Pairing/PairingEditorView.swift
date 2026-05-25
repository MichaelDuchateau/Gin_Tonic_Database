import SwiftUI
import SwiftData

struct PairingEditorView: View {
    var gin: Gin? = nil
    var existingPairing: GinTonicPairing? = nil

    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Query private var tonics: [Tonic]
    @Query private var garnishes: [Garnish]

    @State private var selectedTonic: Tonic? = nil
    @State private var ginVolumeMl: Int = 50
    @State private var tonicVolumeMl: Int = 150
    @State private var glassType: GlassType = .copa
    @State private var iceType: IceType = .cubed
    @State private var selectedGarnishes: Set<Garnish> = []
    @State private var notes: String = ""

    private var targetGin: Gin? { gin ?? existingPairing?.gin }
    private var isValid: Bool { targetGin != nil && selectedTonic != nil }

    var body: some View {
        Form {
            if let g = targetGin {
                Section("Gin") { Text(g.name).foregroundStyle(.secondary) }
            }

            Section("Tonic") {
                Picker("Tonic", selection: $selectedTonic) {
                    Text("Select…").tag(Tonic?.none)
                    ForEach(tonics) { t in
                        Text(t.displayName).tag(Tonic?.some(t))
                    }
                }
            }

            Section("Volumes") {
                VolumeControlView(label: "Gin", volume: $ginVolumeMl, range: 20...100)
                VolumeControlView(label: "Tonic", volume: $tonicVolumeMl, range: 50...300, step: 10)
            }

            Section("Glass & Ice") {
                Picker("Glass", selection: $glassType) {
                    ForEach(GlassType.allCases) { Text($0.rawValue).tag($0) }
                }
                Picker("Ice", selection: $iceType) {
                    ForEach(IceType.allCases) { Text($0.rawValue).tag($0) }
                }
            }

            Section("Garnishes") {
                GarnishPickerView(allGarnishes: garnishes, selected: $selectedGarnishes)
            }

            Section("Notes") {
                TextField("Optional notes…", text: $notes, axis: .vertical)
                    .lineLimit(3, reservesSpace: true)
            }
        }
        .navigationTitle(existingPairing == nil ? "Add Pairing" : "Edit Pairing")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") { save() }.disabled(!isValid)
            }
        }
        .onAppear { populateIfEditing() }
    }

    private func populateIfEditing() {
        guard let p = existingPairing else { return }
        selectedTonic = p.tonic
        ginVolumeMl = p.ginVolumeMl
        tonicVolumeMl = p.tonicVolumeMl
        glassType = p.glassType
        iceType = p.iceType
        selectedGarnishes = Set(p.garnishes)
        notes = p.notes ?? ""
    }

    private func save() {
        guard let gin = targetGin, let tonic = selectedTonic else { return }
        if let p = existingPairing {
            p.tonic = tonic
            p.ginVolumeMl = ginVolumeMl; p.tonicVolumeMl = tonicVolumeMl
            p.glassType = glassType; p.iceType = iceType
            p.garnishes = Array(selectedGarnishes)
            p.notes = notes.isEmpty ? nil : notes
        } else {
            let pairing = GinTonicPairing(
                gin: gin, tonic: tonic,
                ginVolumeMl: ginVolumeMl, tonicVolumeMl: tonicVolumeMl,
                glassType: glassType, iceType: iceType,
                notes: notes.isEmpty ? nil : notes,
                source: .userCreated,
                garnishes: Array(selectedGarnishes)
            )
            context.insert(pairing)
        }
        try? context.save()
        dismiss()
    }
}
