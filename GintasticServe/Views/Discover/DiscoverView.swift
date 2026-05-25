import SwiftUI
import SwiftData

struct DiscoverView: View {
    @Environment(SeedDataService.self) private var seedService
    @Environment(\.modelContext) private var context
    @Query private var cabinetGins: [Gin]
    @State private var viewModel: DiscoverViewModel? = nil
    @State private var selectedSeed: SeedGin? = nil

    private var vm: DiscoverViewModel {
        viewModel ?? DiscoverViewModel(seedService: seedService)
    }

    var body: some View {
        Group {
            if vm.results.isEmpty && vm.searchText.isEmpty {
                EmptyStateView(
                    title: "Discover Gins",
                    message: "Search by name, distillery, or botanical.",
                    systemImage: "magnifyingglass"
                )
            } else if vm.results.isEmpty {
                EmptyStateView(
                    title: "No Results",
                    message: ""\(vm.searchText)" not found in catalogue.",
                    systemImage: "magnifyingglass"
                )
            } else {
                List(vm.results) { seed in
                    Button {
                        selectedSeed = seed
                    } label: {
                        SeedGinRowView(seed: seed, alreadyOwned: vm.isAlreadyInCabinet(seed, existingGins: cabinetGins))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .navigationTitle("Discover")
        .searchable(text: Binding(
            get: { vm.searchText },
            set: { vm.searchText = $0; vm.search() }
        ), prompt: "Gin name, distillery, botanical…")
        .sheet(item: $selectedSeed) { seed in
            NavigationStack {
                SeedGinPreviewView(seed: seed, onAdd: { status in
                    vm.addToCabinet(gin: seed, status: status, context: context)
                    selectedSeed = nil
                })
            }
        }
        .onAppear {
            if viewModel == nil {
                viewModel = DiscoverViewModel(seedService: seedService)
                viewModel?.search()
            }
        }
    }
}

struct SeedGinRowView: View {
    let seed: SeedGin
    let alreadyOwned: Bool

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(seed.name).font(.headline)
                Text(seed.distillery).font(.subheadline).foregroundStyle(.secondary)
                Text("\(seed.country) · \(String(format: "%.1f%%", seed.abv))")
                    .font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            if alreadyOwned {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
            } else {
                Image(systemName: "chevron.right")
                    .foregroundStyle(.tertiary)
                    .font(.caption)
            }
        }
        .padding(.vertical, 2)
        .opacity(alreadyOwned ? 0.5 : 1)
    }
}
