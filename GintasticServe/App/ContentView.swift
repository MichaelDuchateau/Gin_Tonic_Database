import SwiftUI

struct ContentView: View {
    @Environment(\.horizontalSizeClass) private var sizeClass

    var body: some View {
        if sizeClass == .compact {
            compactLayout
        } else {
            regularLayout
        }
    }

    // MARK: - iPhone: TabView

    private var compactLayout: some View {
        TabView {
            NavigationStack {
                CabinetView()
            }
            .tabItem { Label("My Cabinet", systemImage: "cabinet.fill") }

            NavigationStack {
                DiscoverView()
            }
            .tabItem { Label("Discover", systemImage: "magnifyingglass") }

            NavigationStack {
                TonicListView()
            }
            .tabItem { Label("Tonics", systemImage: "drop.fill") }

            NavigationStack {
                PairingMatrixView()
            }
            .tabItem { Label("Pairings", systemImage: "square.grid.2x2.fill") }

            NavigationStack {
                RecipeListView()
            }
            .tabItem { Label("My Recipes", systemImage: "list.clipboard.fill") }

            NavigationStack {
                SettingsView()
            }
            .tabItem { Label("Settings", systemImage: "gearshape.fill") }
        }
    }

    // MARK: - macOS / iPad: NavigationSplitView

    @State private var selection: SidebarItem? = .cabinet(.own)

    private var regularLayout: some View {
        NavigationSplitView {
            SidebarView(selection: $selection)
        } content: {
            contentColumn
        } detail: {
            EmptyStateView(title: "Select an item", systemImage: "arrow.left")
        }
    }

    @ViewBuilder
    private var contentColumn: some View {
        switch selection {
        case .cabinet(let status):
            CabinetView(filterStatus: status)
        case .discover:
            DiscoverView()
        case .tonics:
            TonicListView()
        case .pairings:
            PairingMatrixView()
        case .recipes:
            RecipeListView()
        case .settings:
            SettingsView()
        case .none:
            EmptyStateView(title: "Select a section", systemImage: "sidebar.left")
        }
    }
}

// MARK: - Sidebar

enum SidebarItem: Hashable {
    case cabinet(CabinetStatus)
    case discover
    case tonics
    case pairings
    case recipes
    case settings
}

struct SidebarView: View {
    @Binding var selection: SidebarItem?
    @Query private var gins: [Gin]

    var body: some View {
        List(selection: $selection) {
            Section("My Cabinet") {
                ForEach(CabinetStatus.allCases) { status in
                    Label {
                        HStack {
                            Text(status.rawValue)
                            Spacer()
                            Text("\(count(for: status))")
                                .foregroundStyle(.secondary)
                                .font(.caption)
                        }
                    } icon: {
                        Image(systemName: status.systemImage)
                            .foregroundStyle(status.color)
                    }
                    .tag(SidebarItem.cabinet(status))
                }
            }

            Section {
                Label("Discover", systemImage: "magnifyingglass")
                    .tag(SidebarItem.discover)
                Label("Tonics", systemImage: "drop.fill")
                    .tag(SidebarItem.tonics)
                Label("Pairing Matrix", systemImage: "square.grid.2x2.fill")
                    .tag(SidebarItem.pairings)
                Label("My Recipes", systemImage: "list.clipboard.fill")
                    .tag(SidebarItem.recipes)
            }

            Section {
                Label("Settings", systemImage: "gearshape.fill")
                    .tag(SidebarItem.settings)
            }
        }
        .navigationTitle("The Gintastic Serve")
    }

    private func count(for status: CabinetStatus) -> Int {
        gins.filter { $0.cabinetStatus == status }.count
    }
}
