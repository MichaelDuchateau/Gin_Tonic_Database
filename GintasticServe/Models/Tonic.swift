import Foundation
import SwiftData

@Model
final class Tonic {
    @Attribute(.unique) var id: UUID
    var name: String
    var brand: String
    var style: TonicStyle
    var flavorDescription: String?
    var flavorTags: [FlavorTag]
    var officialURL: String?
    var isUserAdded: Bool
    var createdAt: Date

    @Relationship(deleteRule: .cascade, inverse: \GinTonicPairing.tonic)
    var pairings: [GinTonicPairing] = []

    init(
        id: UUID = UUID(),
        name: String,
        brand: String,
        style: TonicStyle = .indian,
        flavorDescription: String? = nil,
        flavorTags: [FlavorTag] = [],
        officialURL: String? = nil,
        isUserAdded: Bool = true
    ) {
        self.id = id
        self.name = name
        self.brand = brand
        self.style = style
        self.flavorDescription = flavorDescription
        self.flavorTags = flavorTags
        self.officialURL = officialURL
        self.isUserAdded = isUserAdded
        self.createdAt = .now
    }

    var displayName: String { "\(brand) \(name)" }
}
