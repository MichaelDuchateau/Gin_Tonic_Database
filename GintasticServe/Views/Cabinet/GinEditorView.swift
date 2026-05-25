import SwiftUI
import SwiftData

struct GinEditorView: View {
    enum Mode {
        case add
        case addFromSeed(SeedGin, CabinetStatus)
        case edit(Gin)
    }

    let mode: Mode

    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var distillery: String = ""
    @State private var country: String = ""
    @State private var region: String = ""
    @State private var style: GinStyle = .londonDry
    @State private var abv: Double = 40.0
    @State private var botanicals: String = ""
    @State private var tasteNose: String = ""
    @State private var tastePalate: String = ""
    @State private var tasteFinish: String = ""
    @State private var selectedFlavorTags: Set<FlavorTag> = []
    @State private var officialURL: String = ""
    @State private var cabinetStatus: CabinetStatus = .own
    @State private var dateAcquired: Date = .now
    @State private var hasAcquiredDate: Bool = false
    @State private var userNotes: String = ""
    @State private var userRating: Int? = nil
    @State private var seedId: String? = nil

    private var isValid: Bool { !name.isEmpty && !distillery.isEmpty && !country.isEmpty }
    private var title: String {
        switch mode {
        case .add, .addFromSeed: return "Add Gin"
        case .edit: return "Edit Gin"
        }
    }

    var body: some View {
        Form {
            Section("Identity") {
                TextField("Gin name", text: $name)
                TextField("Distillery", text: $distillery)
                TextField("Country", text: $country)
                TextField("Region (optional)", text: $region)
                Picker("Style", selection: $style) {
                    ForEach(GinStyle.allCases) { Text($0.rawValue).tag($0) }
                }
                HStack {
                    Text("ABV")
                    Spacer()
                    TextField("40.0", value: $abv, format: .number.precision(.fractionLength(1)))
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 64)
                    Text("%")
                }
            }

            Section("Cabinet") {
                Picker("Status", selection: $cabinetStatus) {
                    ForEach(CabinetStatus.allCases) {
                        Label($0.rawValue, systemImage: $0.systemImage).tag($0)
                    }
                }
                Toggle("Set acquired date", isOn: $hasAcquiredDate)
                if hasAcquiredDate {
                    DatePicker("Acquired", selection: $dateAcquired, displayedComponents: .date)
                }
            }

            Section("Botanicals") {
                TextField("Comma-separated list", text: $botanicals, axis: .vertical)
                    .lineLimit(3, reservesSpace: true)
            }

            Section("Taste Profile") {
                TextField("Nose", text: $tasteNose, axis: .vertical).lineLimit(2, reservesSpace: true)
                TextField("Palate", text: $tastePalate, axis: .vertical).lineLimit(2, reservesSpace: true)
                TextField("Finish", text: $tasteFinish, axis: .vertical).lineLimit(2, reservesSpace: true)
            }

            Section("Flavor Tags") {
                FlowLayout(spacing: 8) {
                    ForEach(FlavorTag.allCases) { tag in
                        let selected = selectedFlavorTags.contains(tag)
                        Button {
                            if selected { selectedFlavorTags.remove(tag) }
                            else { selectedFlavorTags.insert(tag) }
                        } label: {
                            Text(tag.label)
                                .font(.caption.weight(.medium))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(selected ? Color.accentColor : Color(.systemGray5),
                                            in: Capsule())
                                .foregroundStyle(selected ? .white : .primary)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 4)
            }

            Section("Links") {
                TextField("Official website URL", text: $officialURL)
                    .keyboardType(.URL)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
            }

            Section("My Notes") {
                RatingView(rating: $userRating)
                TextField("Personal notes…", text: $userNotes, axis: .vertical)
                    .lineLimit(4, reservesSpace: true)
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") { save() }.disabled(!isValid)
            }
        }
        .onAppear { populate() }
    }

    // MARK: - Populate

    private func populate() {
        switch mode {
        case .add:
            break
        case .addFromSeed(let seed, let status):
            name = seed.name
            distillery = seed.distillery
            country = seed.country
            region = seed.region ?? ""
            style = GinStyle(rawValue: seed.style) ?? .other
            abv = seed.abv
            botanicals = seed.botanicals.joined(separator: ", ")
            tasteNose = seed.tasteNose ?? ""
            tastePalate = seed.tastePalate ?? ""
            tasteFinish = seed.tasteFinish ?? ""
            selectedFlavorTags = Set(seed.flavorTags.compactMap(FlavorTag.init))
            officialURL = seed.officialURL ?? ""
            cabinetStatus = status
            hasAcquiredDate = status == .own
            seedId = seed.id
        case .edit(let gin):
            name = gin.name
            distillery = gin.distillery
            country = gin.country
            region = gin.region ?? ""
            style = gin.style
            abv = gin.abv
            botanicals = gin.botanicals.joined(separator: ", ")
            tasteNose = gin.tasteNose ?? ""
            tastePalate = gin.tastePalate ?? ""
            tasteFinish = gin.tasteFinish ?? ""
            selectedFlavorTags = Set(gin.flavorTags)
            officialURL = gin.officialURL ?? ""
            cabinetStatus = gin.cabinetStatus
            if let d = gin.dateAcquired { dateAcquired = d; hasAcquiredDate = true }
            userNotes = gin.userNotes ?? ""
            userRating = gin.userRating
            seedId = gin.seedId
        }
    }

    // MARK: - Save

    private func save() {
        let botanicalList = botanicals
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }

        switch mode {
        case .add, .addFromSeed:
            let gin = Gin(
                name: name, distillery: distillery, country: country,
                region: region.isEmpty ? nil : region,
                style: style, abv: abv, botanicals: botanicalList,
                tasteNose: tasteNose.isEmpty ? nil : tasteNose,
                tastePalate: tastePalate.isEmpty ? nil : tastePalate,
                tasteFinish: tasteFinish.isEmpty ? nil : tasteFinish,
                flavorTags: Array(selectedFlavorTags),
                officialURL: officialURL.isEmpty ? nil : officialURL,
                cabinetStatus: cabinetStatus,
                dateAcquired: hasAcquiredDate ? dateAcquired : nil,
                userNotes: userNotes.isEmpty ? nil : userNotes,
                userRating: userRating, seedId: seedId
            )
            context.insert(gin)
        case .edit(let gin):
            gin.name = name; gin.distillery = distillery; gin.country = country
            gin.region = region.isEmpty ? nil : region
            gin.style = style; gin.abv = abv; gin.botanicals = botanicalList
            gin.tasteNose = tasteNose.isEmpty ? nil : tasteNose
            gin.tastePalate = tastePalate.isEmpty ? nil : tastePalate
            gin.tasteFinish = tasteFinish.isEmpty ? nil : tasteFinish
            gin.flavorTags = Array(selectedFlavorTags)
            gin.officialURL = officialURL.isEmpty ? nil : officialURL
            gin.cabinetStatus = cabinetStatus
            gin.dateAcquired = hasAcquiredDate ? dateAcquired : nil
            gin.userNotes = userNotes.isEmpty ? nil : userNotes
            gin.userRating = userRating
            gin.updatedAt = .now
        }
        try? context.save()
        dismiss()
    }
}
