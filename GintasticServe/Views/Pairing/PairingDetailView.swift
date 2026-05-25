import SwiftUI

struct PairingDetailView: View {
    @Bindable var pairing: GinTonicPairing
    @Environment(\.modelContext) private var context
    @State private var showEditor = false

    var body: some View {
        List {
            Section {
                LabeledContent("Gin", value: pairing.gin.name)
                LabeledContent("Tonic", value: pairing.tonic.displayName)
                LabeledContent("Source") {
                    Text(pairing.source.rawValue)
                        .foregroundStyle(sourceColor)
                }
            }

            Section("Serve") {
                LabeledContent("Gin", value: "\(pairing.ginVolumeMl) ml")
                LabeledContent("Tonic", value: "\(pairing.tonicVolumeMl) ml")
                LabeledContent("Ratio", value: "1 : \(pairing.tonicVolumeMl / pairing.ginVolumeMl)")
                LabeledContent("Glass", value: pairing.glassType.rawValue)
                LabeledContent("Ice", value: pairing.iceType.rawValue)
            }

            if !pairing.garnishes.isEmpty {
                Section("Garnish") {
                    ForEach(pairing.garnishes) { garnish in
                        VStack(alignment: .leading, spacing: 2) {
                            Text(garnish.name).font(.subheadline)
                            if let prep = garnish.preparation {
                                Text(prep).font(.caption).foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }

            if let notes = pairing.notes {
                Section("Notes") { Text(notes) }
            }

            Section {
                Toggle("Favourite", isOn: $pairing.isUserFavorite)
                Button("Save to My Recipes") {
                    // Handled by RecipeEditorView pre-fill
                }
            }
        }
        .navigationTitle("Pairing Detail")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Edit") { showEditor = true }
            }
        }
        .sheet(isPresented: $showEditor) {
            NavigationStack { PairingEditorView(existingPairing: pairing) }
        }
    }

    private var sourceColor: Color {
        switch pairing.source {
        case .distilleryRecommended: return .green
        case .editorial: return .blue
        case .userCreated: return .orange
        }
    }
}
