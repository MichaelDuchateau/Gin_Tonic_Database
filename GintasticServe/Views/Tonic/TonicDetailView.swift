import SwiftUI

struct TonicDetailView: View {
    let tonic: Tonic

    var body: some View {
        List {
            Section {
                LabeledContent("Brand", value: tonic.brand)
                LabeledContent("Style", value: tonic.style.rawValue)
                if let desc = tonic.flavorDescription { LabeledContent("Profile", value: desc) }
                if !tonic.flavorTags.isEmpty {
                    FlavorTagView(tags: tonic.flavorTags).padding(.vertical, 4)
                }
                if let url = tonic.officialURL, let link = URL(string: url) {
                    Link(destination: link) { Label("Official Website", systemImage: "safari") }
                }
            }

            if !tonic.pairings.isEmpty {
                Section("Paired With") {
                    ForEach(tonic.pairings) { pairing in
                        NavigationLink(value: pairing) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(pairing.gin.name).font(.subheadline)
                                Text(pairing.ratioDescription).font(.caption).foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(tonic.displayName)
        .navigationDestination(for: GinTonicPairing.self) { PairingDetailView(pairing: $0) }
    }
}

struct TonicEditorView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var brand = ""
    @State private var style: TonicStyle = .indian
    @State private var flavorDescription = ""
    @State private var officialURL = ""

    var body: some View {
        Form {
            Section("Identity") {
                TextField("Brand", text: $brand)
                TextField("Name", text: $name)
                Picker("Style", selection: $style) {
                    ForEach(TonicStyle.allCases) { Text($0.rawValue).tag($0) }
                }
            }
            Section("Details") {
                TextField("Flavor description", text: $flavorDescription, axis: .vertical)
                    .lineLimit(2, reservesSpace: true)
                TextField("Official website URL", text: $officialURL)
                    .keyboardType(.URL).autocorrectionDisabled()
            }
        }
        .navigationTitle("Add Tonic")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    let tonic = Tonic(name: name, brand: brand, style: style,
                                     flavorDescription: flavorDescription.isEmpty ? nil : flavorDescription,
                                     officialURL: officialURL.isEmpty ? nil : officialURL)
                    context.insert(tonic)
                    try? context.save()
                    dismiss()
                }
                .disabled(name.isEmpty || brand.isEmpty)
            }
        }
    }
}
