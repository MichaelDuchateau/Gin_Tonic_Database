import SwiftUI

struct SeedGinPreviewView: View {
    let seed: SeedGin
    let onAdd: (CabinetStatus) -> Void

    @Environment(SeedDataService.self) private var seedService
    @Environment(\.dismiss) private var dismiss
    @State private var showStatusPicker = false
    @State private var pendingStatus: CabinetStatus = .own

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 6) {
                    Text(seed.distillery).font(.subheadline).foregroundStyle(.secondary)
                    Text("\(seed.country)\(seed.region.map { ", \($0)" } ?? "")")
                        .font(.caption).foregroundStyle(.secondary)
                    HStack {
                        Text(String(format: "%.1f%% ABV", seed.abv)).font(.caption.weight(.semibold))
                        Text("·").foregroundStyle(.tertiary)
                        Text(seed.style.capitalized).font(.caption)
                    }
                }

                if let url = seed.officialURL, let link = URL(string: url) {
                    Link(destination: link) {
                        Label("Official Website", systemImage: "safari")
                    }
                }
            }

            if let nose = seed.tasteNose { Section("Nose") { Text(nose) } }
            if let palate = seed.tastePalate { Section("Palate") { Text(palate) } }
            if let finish = seed.tasteFinish { Section("Finish") { Text(finish) } }

            if !seed.flavorTags.isEmpty {
                Section("Flavor Tags") {
                    FlavorTagView(tags: seed.flavorTags.compactMap(FlavorTag.init))
                        .padding(.vertical, 4)
                }
            }

            if !seed.botanicals.isEmpty {
                Section("Botanicals") {
                    FlowLayout(spacing: 6) {
                        ForEach(seed.botanicals, id: \.self) { b in
                            Text(b).font(.caption).padding(.horizontal, 10).padding(.vertical, 4)
                                .background(Color(.systemGray6), in: Capsule())
                        }
                    }
                    .padding(.vertical, 4)
                }
            }

            let pairings = seedService.pairings(forGinId: seed.id)
            if !pairings.isEmpty {
                Section("Suggested Pairings") {
                    ForEach(pairings) { pairing in
                        if let tonic = seedService.tonic(withId: pairing.tonicId) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(tonic.brand + " " + tonic.name).font(.subheadline.weight(.medium))
                                Text("\(pairing.ginVolumeMl)ml gin · \(pairing.tonicVolumeMl)ml tonic · \(pairing.glassType.capitalized)")
                                    .font(.caption).foregroundStyle(.secondary)
                                let garnishes = seedService.garnishes(withIds: pairing.garnishIds)
                                if !garnishes.isEmpty {
                                    Text(garnishes.map(\.name).joined(separator: " · "))
                                        .font(.caption).foregroundStyle(.secondary)
                                }
                            }
                            .padding(.vertical, 2)
                        }
                    }
                }
            }

            Section {
                Button {
                    pendingStatus = .own
                    showStatusPicker = true
                } label: {
                    Label("Add to My Cabinet", systemImage: "cabinet.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .listRowBackground(Color.clear)
            }
        }
        .navigationTitle(seed.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
            }
        }
        .confirmationDialog("Add to Cabinet as…", isPresented: $showStatusPicker) {
            Button("Own — I have this bottle") { onAdd(.own) }
            Button("Wishlist — I want to try it") { onAdd(.wishlist) }
            Button("Cancel", role: .cancel) {}
        }
    }
}
