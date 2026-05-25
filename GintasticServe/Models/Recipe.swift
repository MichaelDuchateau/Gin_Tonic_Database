import Foundation
import SwiftData

@Model
final class Recipe {
    @Attribute(.unique) var id: UUID
    var name: String
    var gin: Gin
    var tonic: Tonic
    var ginVolumeMl: Int
    var tonicVolumeMl: Int
    var glassType: GlassType
    var iceType: IceType
    var preparationNotes: String?
    var userRating: Int?
    var isFavorite: Bool
    var createdAt: Date
    var updatedAt: Date

    var garnishes: [Garnish]

    init(
        id: UUID = UUID(),
        name: String,
        gin: Gin,
        tonic: Tonic,
        ginVolumeMl: Int = 50,
        tonicVolumeMl: Int = 150,
        glassType: GlassType = .copa,
        iceType: IceType = .cubed,
        preparationNotes: String? = nil,
        userRating: Int? = nil,
        isFavorite: Bool = false,
        garnishes: [Garnish] = []
    ) {
        self.id = id
        self.name = name
        self.gin = gin
        self.tonic = tonic
        self.ginVolumeMl = ginVolumeMl
        self.tonicVolumeMl = tonicVolumeMl
        self.glassType = glassType
        self.iceType = iceType
        self.preparationNotes = preparationNotes
        self.userRating = userRating
        self.isFavorite = isFavorite
        self.createdAt = .now
        self.updatedAt = .now
        self.garnishes = garnishes
    }
}
