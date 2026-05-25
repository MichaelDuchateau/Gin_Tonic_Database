import SwiftUI
import SwiftData

struct TonicListView: View {
    @Query(sort: \Tonic.brand) private var tonics: [Tonic]
    @Environment(\.modelContext) private var context
    @State private var searchText = ""
    @State private var showAdd = false

    private var filtered: [Tonic] {
        guard !searchText.isEmpty else { return tonics }
        let q = searchText.lowercased()
        return tonics.filter {
            $0.brand.lowercased().contains(q) || $0.name.lowercased().contains(q)
        }
    }

    var body: some View {
        List {
            ForEach(filtered) { tonic in
                NavigationLink(value: tonic) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(tonic.displayName).font(.headline)
                        Text(tonic.style.rawValue).font(.caption).foregroundStyle(.secondary)
                    }
                }
            }
        }
        .navigationTitle("Tonics")
        .navigationDestination(for: Tonic.self) { TonicDetailView(tonic: $0) }
        .searchable(text: $searchText, prompt: "Search tonics…")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button { showAdd = true } label: { Image(systemName: "plus") }
            }
        }
        .sheet(isPresented: $showAdd) {
            NavigationStack { TonicEditorView() }
        }
    }
}
