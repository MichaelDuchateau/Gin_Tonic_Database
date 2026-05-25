import SwiftUI
import SwiftData

struct RecipeEditorView: View {
    var existing: Recipe? = nil

    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Gin.name) private var gins: [Gin]
    @Query(sort: \Tonic.brand) private var tonics: [Tonic]
    @Query private var garnishes: [Garnish]

    @State private var viewModel = RecipeEditorViewModel()
    @State private var selectedGarnishes: Set<Garnish> = []

    var body: some View {
        Form {
            Section("Name") {
                TextField("e.g. Sunday Morning G&T", text: $viewModel.name)
            }

            Section("Ingredients") {
                Picker("Gin", selection: $viewModel.gin) {
                    Text("Select gin…").tag(Gin?.none)
                    ForEach(gins.filter { $0.cabinetStatus == .own }) { g in
                        Text(g.name).tag(Gin?.some(g))
                    }
                }
                Picker("Tonic", selection: $viewModel.tonic) {
                    Text("Select tonic…").tag(Tonic?.none)
                    ForEach(tonics) { t in
                        Text(t.displayName).tag(Tonic?.some(t))
                    }
                }
            }

            Section("Volumes") {
                VolumeControlView(label: "Gin", volume: $viewModel.ginVolumeMl, range: 20...100)
                VolumeControlView(label: "Tonic", volume: $viewModel.tonicVolumeMl, range: 50...300, step: 10)
            }

            Section("Glass & Ice") {
                Picker("Glass", selection: $viewModel.glassType) {
                    ForEach(GlassType.allCases) { Text($0.rawValue).tag($0) }
                }
                Picker("Ice", selection: $viewModel.iceType) {
                    ForEach(IceType.allCases) { Text($0.rawValue).tag($0) }
                }
            }

            Section("Garnishes") {
                GarnishPickerView(allGarnishes: garnishes, selected: $selectedGarnishes)
            }

            Section("Preparation") {
                TextField("Optional notes…", text: $viewModel.preparationNotes, axis: .vertical)
                    .lineLimit(3, reservesSpace: true)
            }

            Section("Rating") {
                RatingView(rating: $viewModel.userRating)
            }
        }
        .navigationTitle(existing == nil ? "New Recipe" : "Edit Recipe")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") { save() }.disabled(!viewModel.isValid)
            }
        }
        .onAppear { populateIfEditing() }
    }

    private func populateIfEditing() {
        guard let r = existing else { return }
        viewModel.name = r.name
        viewModel.gin = r.gin
        viewModel.tonic = r.tonic
        viewModel.ginVolumeMl = r.ginVolumeMl
        viewModel.tonicVolumeMl = r.tonicVolumeMl
        viewModel.glassType = r.glassType
        viewModel.iceType = r.iceType
        viewModel.preparationNotes = r.preparationNotes ?? ""
        viewModel.userRating = r.userRating
        selectedGarnishes = Set(r.garnishes)
    }

    private func save() {
        guard let gin = viewModel.gin, let tonic = viewModel.tonic else { return }
        if let r = existing {
            r.name = viewModel.name; r.gin = gin; r.tonic = tonic
            r.ginVolumeMl = viewModel.ginVolumeMl; r.tonicVolumeMl = viewModel.tonicVolumeMl
            r.glassType = viewModel.glassType; r.iceType = viewModel.iceType
            r.preparationNotes = viewModel.preparationNotes.isEmpty ? nil : viewModel.preparationNotes
            r.userRating = viewModel.userRating
            r.garnishes = Array(selectedGarnishes)
            r.updatedAt = .now
        } else {
            let recipe = Recipe(
                name: viewModel.name, gin: gin, tonic: tonic,
                ginVolumeMl: viewModel.ginVolumeMl, tonicVolumeMl: viewModel.tonicVolumeMl,
                glassType: viewModel.glassType, iceType: viewModel.iceType,
                preparationNotes: viewModel.preparationNotes.isEmpty ? nil : viewModel.preparationNotes,
                userRating: viewModel.userRating,
                garnishes: Array(selectedGarnishes)
            )
            context.insert(recipe)
        }
        try? context.save()
        dismiss()
    }
}
