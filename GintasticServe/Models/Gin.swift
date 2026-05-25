import Foundation
import SwiftData

@Model
final class Gin {
    @Attribute(.unique) var id: UUID
    var name: String
    var distillery: String
    var country: String
    var region: String?
    var style: GinStyle
    var abv: Double
    var botanicals: [String]
    var tasteNose: String?
    var tastePalate: String?
    var tasteFinish: String?
    var flavorTags: [FlavorTag]
    var officialURL: String?
    var bottleImageURL: String?
    var cabinetStatus: CabinetStatus
    var dateAdded: Date
    var dateAcquired: Date?
    var userNotes: String?
    var userRating: Int?
    var updatedAt: Date
    var seedId: String?

    @Relationship(deleteRule: .cascade, inverse: \GinTonicPairing.gin)
    var pairings: [GinTonicPairing] = []

    @Relationship(deleteRule: .cascade, inverse: \Recipe.gin)
    var recipes: [Recipe] = []

    init(
        id: UUID = UUID(),
        name: String,
        distillery: String,
        country: String,
        region: String? = nil,
        style: GinStyle = .londonDry,
        abv: Double = 40.0,
        botanicals: [String] = [],
        tasteNose: String? = nil,
        tastePalate: String? = nil,
        tasteFinish: String? = nil,
        flavorTags: [FlavorTag] = [],
        officialURL: String? = nil,
        bottleImageURL: String? = nil,
        cabinetStatus: CabinetStatus = .own,
        dateAdded: Date = .now,
        dateAcquired: Date? = nil,
        userNotes: String? = nil,
        userRating: Int? = nil,
        seedId: String? = nil
    ) {
        self.id = id
        self.name = name
        self.distillery = distillery
        self.country = country
        self.region = region
        self.style = style
        self.abv = abv
        self.botanicals = botanicals
        self.tasteNose = tasteNose
        self.tastePalate = tastePalate
        self.tasteFinish = tasteFinish
        self.flavorTags = flavorTags
        self.officialURL = officialURL
        self.bottleImageURL = bottleImageURL
        self.cabinetStatus = cabinetStatus
        self.dateAdded = dateAdded
        self.dateAcquired = dateAcquired
        self.userNotes = userNotes
        self.userRating = userRating
        self.updatedAt = .now
        self.seedId = seedId
    }
}

extension Gin {
    static func from(seed: SeedGin, status: CabinetStatus) -> Gin {
        Gin(
            name: seed.name,
            distillery: seed.distillery,
            country: seed.country,
            region: seed.region,
            style: GinStyle(rawValue: seed.style) ?? .other,
            abv: seed.abv,
            botanicals: seed.botanicals,
            tasteNose: seed.tasteNose,
            tastePalate: seed.tastePalate,
            tasteFinish: seed.tasteFinish,
            flavorTags: seed.flavorTags.compactMap { FlavorTag(rawValue: $0) },
            officialURL: seed.officialURL,
            bottleImageURL: seed.bottleImageURL,
            cabinetStatus: status,
            dateAcquired: status == .own ? .now : nil,
            seedId: seed.id
        )
    }
}
