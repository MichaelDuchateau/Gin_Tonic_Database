import SwiftUI
import SwiftData

struct CabinetView: View {
    var filterStatus: CabinetStatus? = nil

    @Query private var allGins: [Gin]
    @Environment(\.modelContext) private var context
    @State private var viewModel = CabinetViewModel()
    @State private var selectedStatus: CabinetStatus = .own
    @State private var showAddGin = false

    private var activeStatus: CabinetStatus { filterStatus ?? selectedStatus }

    var body: some View {
        Group {
            let gins = viewModel.filtered(allGins, status: activeStatus)
            if gins.isEmpty {
                emptyState
            } else {
                List {
                    ForEach(gins) { gin in
                        NavigationLink(value: gin) {
                            GinRowView(gin: gin)
                        }
                        .swipeActions(edge: .leading) {
                            Button {
                                viewModel.advanceStatus(of: gin, context: context)
                            } label: {
                                Label(gin.cabinetStatus.nextStatusLabel,
                                      systemImage: gin.cabinetStatus.nextStatus.systemImage)
                            }
                            .tint(gin.cabinetStatus.nextStatus.color)
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                viewModel.delete(gin, context: context)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("My Cabinet")
        .navigationDestination(for: Gin.self) { gin in
            GinDetailView(gin: gin)
        }
        .searchable(text: $viewModel.searchText, prompt: "Search gins…")
        .toolbar {
            if filterStatus == nil {
                ToolbarItem(placement: .principal) {
                    Picker("Status", selection: $selectedStatus) {
                        ForEach(CabinetStatus.allCases) { s in
                            Text(s.rawValue).tag(s)
                        }
                    }
                    .pickerStyle(.segmented)
                    .frame(maxWidth: 260)
                }
            }
            ToolbarItem(placement: .primaryAction) {
                Button { showAddGin = true } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showAddGin) {
            NavigationStack {
                GinEditorView(mode: .add)
            }
        }
    }

    private var emptyState: some View {
        EmptyStateView(
            title: "No \(activeStatus.rawValue) Gins",
            message: activeStatus == .own
                ? "Add a bottle from Discover or tap +."
                : nil,
            systemImage: activeStatus.systemImage,
            actionLabel: activeStatus == .own ? "Discover Gins" : nil
        )
    }
}
