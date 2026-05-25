import Foundation
import Observation
import SwiftData

@Observable
final class RecipeEditorViewModel {
    var name: String = ""
    var gin: Gin? = nil
    var tonic: Tonic? = nil
    var ginVolumeMl: Int = 50
    var tonicVolumeMl: Int = 150
    var glassType: GlassType = .copa
    var iceType: IceType = .cubed
    var selectedGarnishes: [Garnish] = []
    var preparationNotes: String = ""
    var userRating: Int? = nil

    var isValid: Bool { !name.isEmpty && gin != nil && tonic != nil }

    func populate(from pairing: GinTonicPairing) {
        gin = pairing.gin
        tonic = pairing.tonic
        ginVolumeMl = pairing.ginVolumeMl
        tonicVolumeMl = pairing.tonicVolumeMl
        glassType = pairing.glassType
        iceType = pairing.iceType
        selectedGarnishes = pairing.garnishes
    }

    func save(context: ModelContext) {
        guard let gin, let tonic else { return }
        let recipe = Recipe(
            name: name,
            gin: gin,
            tonic: tonic,
            ginVolumeMl: ginVolumeMl,
            tonicVolumeMl: tonicVolumeMl,
            glassType: glassType,
            iceType: iceType,
            preparationNotes: preparationNotes.isEmpty ? nil : preparationNotes,
            userRating: userRating,
            garnishes: selectedGarnishes
        )
        context.insert(recipe)
        try? context.save()
    }
}
