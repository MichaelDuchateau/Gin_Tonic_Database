import SwiftUI

struct RecipeDetailView: View {
    @Bindable var recipe: Recipe
    @Environment(\.modelContext) private var context
    @State private var showEditor = false

    var body: some View {
        List {
            Section {
                LabeledContent("Gin", value: recipe.gin.name)
                LabeledContent("Tonic", value: recipe.tonic.displayName)
            }
            Section("Serve") {
                LabeledContent("Gin", value: "\(recipe.ginVolumeMl) ml")
                LabeledContent("Tonic", value: "\(recipe.tonicVolumeMl) ml")
                LabeledContent("Glass", value: recipe.glassType.rawValue)
                LabeledContent("Ice", value: recipe.iceType.rawValue)
            }
            if !recipe.garnishes.isEmpty {
                Section("Garnishes") {
                    ForEach(recipe.garnishes) { g in
                        VStack(alignment: .leading, spacing: 2) {
                            Text(g.name).font(.subheadline)
                            if let prep = g.preparation {
                                Text(prep).font(.caption).foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            if let notes = recipe.preparationNotes {
                Section("Preparation") { Text(notes) }
            }
            Section("My Rating") {
                RatingView(rating: $recipe.userRating)
                    .onChange(of: recipe.userRating) { _, _ in try? context.save() }
                Toggle("Favourite", isOn: $recipe.isFavorite)
                    .onChange(of: recipe.isFavorite) { _, _ in try? context.save() }
            }
        }
        .navigationTitle(recipe.name)
        .toolbar {
            ToolbarItem(placement: .primaryAction) { Button("Edit") { showEditor = true } }
        }
        .sheet(isPresented: $showEditor) {
            NavigationStack { RecipeEditorView(existing: recipe) }
        }
    }
}
