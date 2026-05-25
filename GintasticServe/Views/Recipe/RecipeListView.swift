import SwiftUI
import SwiftData

struct RecipeListView: View {
    @Query(sort: \Recipe.createdAt, order: .reverse) private var recipes: [Recipe]
    @Environment(\.modelContext) private var context
    @State private var showAdd = false

    var body: some View {
        Group {
            if recipes.isEmpty {
                EmptyStateView(
                    title: "No Recipes Yet",
                    message: "Save your favourite G&T combinations here.",
                    systemImage: "list.clipboard",
                    actionLabel: "Create Recipe",
                    action: { showAdd = true }
                )
            } else {
                List {
                    ForEach(recipes) { recipe in
                        NavigationLink(value: recipe) {
                            RecipeRowView(recipe: recipe)
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                context.delete(recipe)
                                try? context.save()
                            } label: { Label("Delete", systemImage: "trash") }
                        }
                        .swipeActions(edge: .leading) {
                            Button {
                                recipe.isFavorite.toggle()
                                try? context.save()
                            } label: {
                                Label(recipe.isFavorite ? "Unfavourite" : "Favourite",
                                      systemImage: recipe.isFavorite ? "heart.slash" : "heart.fill")
                            }
                            .tint(.pink)
                        }
                    }
                }
            }
        }
        .navigationTitle("My Recipes")
        .navigationDestination(for: Recipe.self) { RecipeDetailView(recipe: $0) }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button { showAdd = true } label: { Image(systemName: "plus") }
            }
        }
        .sheet(isPresented: $showAdd) {
            NavigationStack { RecipeEditorView() }
        }
    }
}

struct RecipeRowView: View {
    let recipe: Recipe

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            HStack {
                Text(recipe.name).font(.headline)
                if recipe.isFavorite {
                    Image(systemName: "heart.fill").foregroundStyle(.pink).font(.caption)
                }
                Spacer()
                RatingViewReadOnly(rating: recipe.userRating)
            }
            Text(recipe.gin.name + " · " + recipe.tonic.displayName)
                .font(.subheadline).foregroundStyle(.secondary)
            Text("\(recipe.ginVolumeMl)ml / \(recipe.tonicVolumeMl)ml · \(recipe.glassType.rawValue)")
                .font(.caption).foregroundStyle(.secondary)
        }
        .padding(.vertical, 2)
    }
}
