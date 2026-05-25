import Foundation
import Observation

@Observable
final class PairingMatrixViewModel {
    var filterGinStyle: GinStyle? = nil
    var filterTonicStyle: TonicStyle? = nil

    func ownedGins(_ allGins: [Gin]) -> [Gin] {
        var result = allGins.filter { $0.cabinetStatus == .own }
        if let style = filterGinStyle {
            result = result.filter { $0.style == style }
        }
        return result.sorted { $0.name < $1.name }
    }

    func relevantTonics(for gins: [Gin]) -> [Tonic] {
        let allTonics = gins
            .flatMap { $0.pairings }
            .map { $0.tonic }
        var seen = Set<UUID>()
        var unique = [Tonic]()
        for tonic in allTonics where seen.insert(tonic.id).inserted {
            if let style = filterTonicStyle, tonic.style != style { continue }
            unique.append(tonic)
        }
        return unique.sorted { $0.displayName < $1.displayName }
    }

    func pairing(gin: Gin, tonic: Tonic) -> GinTonicPairing? {
        gin.pairings.first { $0.tonic.id == tonic.id }
    }
}
