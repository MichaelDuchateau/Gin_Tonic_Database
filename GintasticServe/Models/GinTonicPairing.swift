import Foundation
import SwiftData

@Model
final class GinTonicPairing {
    @Attribute(.unique) var id: UUID
    var gin: Gin
    var tonic: Tonic
    var ginVolumeMl: Int
    var tonicVolumeMl: Int
    var glassType: GlassType
    var iceType: IceType
    var notes: String?
    var source: PairingSource
    var isUserFavorite: Bool
    var createdAt: Date

    var garnishes: [Garnish]

    init(
        id: UUID = UUID(),
        gin: Gin,
        tonic: Tonic,
        ginVolumeMl: Int = 50,
        tonicVolumeMl: Int = 150,
        glassType: GlassType = .copa,
        iceType: IceType = .cubed,
        notes: String? = nil,
        source: PairingSource = .userCreated,
        isUserFavorite: Bool = false,
        garnishes: [Garnish] = []
    ) {
        self.id = id
        self.gin = gin
        self.tonic = tonic
        self.ginVolumeMl = ginVolumeMl
        self.tonicVolumeMl = tonicVolumeMl
        self.glassType = glassType
        self.iceType = iceType
        self.notes = notes
        self.source = source
        self.isUserFavorite = isUserFavorite
        self.createdAt = .now
        self.garnishes = garnishes
    }

    var ratioDescription: String { "\(ginVolumeMl)ml / \(tonicVolumeMl)ml" }
}
