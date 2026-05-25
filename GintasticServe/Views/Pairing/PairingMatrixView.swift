import SwiftUI
import SwiftData

struct PairingMatrixView: View {
    @Query private var allGins: [Gin]
    @State private var viewModel = PairingMatrixViewModel()
    @State private var selectedPairing: GinTonicPairing? = nil

    var body: some View {
        let gins = viewModel.ownedGins(allGins)
        let tonics = viewModel.relevantTonics(for: gins)

        Group {
            if gins.isEmpty {
                EmptyStateView(
                    title: "No Gins in Cabinet",
                    message: "Add gins with 'Own' status to see your pairing matrix.",
                    systemImage: "square.grid.2x2"
                )
            } else {
                ScrollView([.horizontal, .vertical]) {
                    Grid(horizontalSpacing: 1, verticalSpacing: 1) {
                        // Header row
                        GridRow {
                            Color.clear.frame(width: 140, height: 44)
                            ForEach(tonics) { tonic in
                                Text(tonic.brand)
                                    .font(.caption2.weight(.semibold))
                                    .lineLimit(2)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 80, height: 44)
                                    .background(Color(.systemGray6))
                            }
                        }
                        // Gin rows
                        ForEach(gins) { gin in
                            GridRow {
                                Text(gin.name)
                                    .font(.caption.weight(.medium))
                                    .lineLimit(2)
                                    .frame(width: 140, height: 52, alignment: .leading)
                                    .padding(.horizontal, 8)
                                    .background(Color(.systemGray6))
                                ForEach(tonics) { tonic in
                                    let pairing = viewModel.pairing(gin: gin, tonic: tonic)
                                    MatrixCell(pairing: pairing)
                                        .frame(width: 80, height: 52)
                                        .onTapGesture {
                                            if let pairing { selectedPairing = pairing }
                                        }
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Pairing Matrix")
        .toolbar {
            ToolbarItem {
                Menu {
                    Picker("Gin Style", selection: $viewModel.filterGinStyle) {
                        Text("All Styles").tag(GinStyle?.none)
                        ForEach(GinStyle.allCases) { Text($0.rawValue).tag(GinStyle?.some($0)) }
                    }
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                }
            }
        }
        .sheet(item: $selectedPairing) { pairing in
            NavigationStack { PairingDetailView(pairing: pairing) }
        }
    }
}

private struct MatrixCell: View {
    let pairing: GinTonicPairing?

    var body: some View {
        if let pairing {
            VStack(spacing: 2) {
                Image(systemName: "checkmark")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(sourceColor(pairing.source))
                if let garnish = pairing.garnishes.first {
                    Text(garnish.name)
                        .font(.system(size: 8))
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(sourceColor(pairing.source).opacity(0.08))
        } else {
            Color(.systemGray6).opacity(0.4)
        }
    }

    private func sourceColor(_ source: PairingSource) -> Color {
        switch source {
        case .distilleryRecommended: return .green
        case .editorial: return .blue
        case .userCreated: return .orange
        }
    }
}
