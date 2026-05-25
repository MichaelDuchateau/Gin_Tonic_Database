import SwiftUI
import SwiftData

struct GinDetailView: View {
    @Bindable var gin: Gin
    @Environment(\.modelContext) private var context
    @State private var showEditor = false
    @State private var showAddPairing = false

    var body: some View {
        List {
            heroSection
            tasteSection
            botanicalsSection
            pairingsSection
            userSection
        }
        .navigationTitle(gin.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Edit") { showEditor = true }
            }
        }
        .sheet(isPresented: $showEditor) {
            NavigationStack { GinEditorView(mode: .edit(gin)) }
        }
        .sheet(isPresented: $showAddPairing) {
            NavigationStack { PairingEditorView(gin: gin) }
        }
    }

    // MARK: - Sections

    private var heroSection: some View {
        Section {
            HStack(spacing: 16) {
                AsyncImage(url: gin.bottleImageURL.flatMap(URL.init)) { phase in
                    switch phase {
                    case .success(let img): img.resizable().scaledToFit()
                    default: Image(systemName: "wineglass").font(.largeTitle).foregroundStyle(.secondary)
                    }
                }
                .frame(width: 64, height: 96)
                .clipShape(RoundedRectangle(cornerRadius: 8))

                VStack(alignment: .leading, spacing: 6) {
                    Text(gin.distillery).font(.subheadline).foregroundStyle(.secondary)
                    Text("\(gin.country)\(gin.region.map { ", \($0)" } ?? "")")
                        .font(.caption).foregroundStyle(.secondary)
                    HStack {
                        Text(String(format: "%.1f%% ABV", gin.abv))
                            .font(.caption.weight(.semibold))
                        CabinetStatusBadge(status: gin.cabinetStatus)
                    }
                }
            }
            .padding(.vertical, 4)

            // Status transition button
            Button {
                withAnimation {
                    let next = gin.cabinetStatus.nextStatus
                    gin.cabinetStatus = next
                    if next.setsAcquiredDate { gin.dateAcquired = .now }
                    gin.updatedAt = .now
                    try? context.save()
                }
            } label: {
                Label(gin.cabinetStatus.nextStatusLabel,
                      systemImage: gin.cabinetStatus.nextStatus.systemImage)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .tint(gin.cabinetStatus.nextStatus.color)

            if let url = gin.officialURL, let link = URL(string: url) {
                Link(destination: link) {
                    Label("Official Website", systemImage: "safari")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
        }
    }

    private var tasteSection: some View {
        Section("Taste Profile") {
            TasteProfileView(gin: gin)
        }
    }

    private var botanicalsSection: some View {
        Section("Botanicals") {
            FlowLayout(spacing: 6) {
                ForEach(gin.botanicals, id: \.self) { botanical in
                    Text(botanical)
                        .font(.caption)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color(.systemGray6), in: Capsule())
                }
            }
            .padding(.vertical, 4)
        }
    }

    private var pairingsSection: some View {
        Section {
            if gin.pairings.isEmpty {
                Button { showAddPairing = true } label: {
                    Label("Add a Pairing", systemImage: "plus")
                }
            } else {
                ForEach(gin.pairings) { pairing in
                    NavigationLink(value: pairing) {
                        PairingRowView(pairing: pairing)
                    }
                }
                Button { showAddPairing = true } label: {
                    Label("Add Pairing", systemImage: "plus")
                }
            }
        } header: {
            Text("Pairings")
        }
    }

    private var userSection: some View {
        Section("My Notes") {
            RatingView(rating: $gin.userRating)
            if let notes = gin.userNotes, !notes.isEmpty {
                Text(notes).font(.body)
            }
            NavigationLink("Edit Notes") {
                GinEditorView(mode: .edit(gin))
            }
        }
    }
}

struct PairingRowView: View {
    let pairing: GinTonicPairing

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(pairing.tonic.displayName).font(.subheadline.weight(.medium))
                Spacer()
                Text(pairing.source.rawValue)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            Text(pairing.ratioDescription).font(.caption).foregroundStyle(.secondary)
            if !pairing.garnishes.isEmpty {
                Text(pairing.garnishes.map(\.name).joined(separator: " · "))
                    .font(.caption).foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 2)
    }
}
